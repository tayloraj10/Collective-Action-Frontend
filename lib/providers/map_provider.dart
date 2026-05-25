import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/map_service.dart';
import 'package:collective_action_frontend/utils/map_filter_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapServiceProvider = Provider<MapService>((ref) {
  return MapService();
});

/// When true, the map shows only the current user's submissions (cleanups, trash reports, routes).
class MapFilterMySubmissionsOnlyNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setFilter(bool value) {
    state = value;
  }
}

final mapFilterMySubmissionsOnlyProvider =
    NotifierProvider<MapFilterMySubmissionsOnlyNotifier, bool>(
        MapFilterMySubmissionsOnlyNotifier.new);

class MapNearbyFilterState {
  const MapNearbyFilterState({
    this.enabled = false,
    this.radiusMiles = kMapNearbyFilterDefaultRadiusMiles,
  });

  final bool enabled;
  final double radiusMiles;

  MapNearbyFilterState copyWith({bool? enabled, double? radiusMiles}) {
    return MapNearbyFilterState(
      enabled: enabled ?? this.enabled,
      radiusMiles: radiusMiles ?? this.radiusMiles,
    );
  }
}

class MapNearbyFilterNotifier extends Notifier<MapNearbyFilterState> {
  @override
  MapNearbyFilterState build() => const MapNearbyFilterState();

  void setEnabled(bool value) {
    state = state.copyWith(enabled: value);
  }

  void setRadiusMiles(double miles) {
    state = state.copyWith(radiusMiles: miles);
  }
}

final mapNearbyFilterProvider =
    NotifierProvider<MapNearbyFilterNotifier, MapNearbyFilterState>(
      MapNearbyFilterNotifier.new,
    );

class MapHeatmapEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setEnabled(bool value) {
    state = value;
  }
}

final mapHeatmapEnabledProvider =
    NotifierProvider<MapHeatmapEnabledNotifier, bool>(
      MapHeatmapEnabledNotifier.new,
    );

/// Pin categories that can be hidden independently on map views.
enum MapPinCategory {
  cleanup,
  trashReport,
  planting,
  hotspot,
}

class MapPinVisibilityState {
  const MapPinVisibilityState({
    this.cleanup = true,
    this.trashReport = true,
    this.planting = true,
    this.hotspot = true,
  });

  final bool cleanup;
  final bool trashReport;
  final bool planting;
  final bool hotspot;

  bool isVisible(MapPinCategory category) => switch (category) {
        MapPinCategory.cleanup => cleanup,
        MapPinCategory.trashReport => trashReport,
        MapPinCategory.planting => planting,
        MapPinCategory.hotspot => hotspot,
      };

  MapPinVisibilityState copyWith({
    bool? cleanup,
    bool? trashReport,
    bool? planting,
    bool? hotspot,
  }) {
    return MapPinVisibilityState(
      cleanup: cleanup ?? this.cleanup,
      trashReport: trashReport ?? this.trashReport,
      planting: planting ?? this.planting,
      hotspot: hotspot ?? this.hotspot,
    );
  }
}

class MapPinVisibilityNotifier extends Notifier<MapPinVisibilityState> {
  @override
  MapPinVisibilityState build() => const MapPinVisibilityState();

  void setVisible(MapPinCategory category, bool visible) {
    state = switch (category) {
      MapPinCategory.cleanup => state.copyWith(cleanup: visible),
      MapPinCategory.trashReport => state.copyWith(trashReport: visible),
      MapPinCategory.planting => state.copyWith(planting: visible),
      MapPinCategory.hotspot => state.copyWith(hotspot: visible),
    };
  }

  void toggle(MapPinCategory category) {
    setVisible(category, !state.isVisible(category));
  }
}

final mapPinVisibilityProvider =
    NotifierProvider<MapPinVisibilityNotifier, MapPinVisibilityState>(
      MapPinVisibilityNotifier.new,
    );

final activeMapCampaignsProvider =
    AsyncNotifierProvider<ActiveMapCampaignsNotifier, List<MapCampaignSchema>>(
      ActiveMapCampaignsNotifier.new,
    );

final mapCampaignsByCreatorProvider =
    AsyncNotifierProvider<MapCampaignsByCreatorNotifier, List<MapCampaignSchema>>(
      MapCampaignsByCreatorNotifier.new,
    );

final mapCampaignByIdProvider =
    FutureProvider.family<MapCampaignSchema?, String>((ref, campaignId) async {
  final service = ref.watch(mapServiceProvider);
  return service.getMapCampaign(campaignId);
});

final mapCampaignsByTypeProvider =
    FutureProvider.family<List<MapCampaignSchema>, MapCampaignTypeEnum>(
  (ref, campaignType) async {
    final service = ref.watch(mapServiceProvider);
    return service.listMapCampaignsByType(campaignType);
  },
);

class ActiveMapCampaignsNotifier extends AsyncNotifier<List<MapCampaignSchema>> {
  @override
  Future<List<MapCampaignSchema>> build() async {
    return ref.read(mapServiceProvider).listActiveMapCampaigns();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(mapServiceProvider).listActiveMapCampaigns();
    });
  }
}

class MapCampaignsByCreatorNotifier
    extends AsyncNotifier<List<MapCampaignSchema>> {
  @override
  Future<List<MapCampaignSchema>> build() async {
    final currentUser = await ref.watch(currentUserProvider.future);
    final userId = currentUser?.id;
    if (userId == null) return [];
    return ref.read(mapServiceProvider).listMapCampaignsByCreator(userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(currentUserProvider).value;
      final userId = currentUser?.id;
      if (userId == null) {
        return [];
      }
      return ref.read(mapServiceProvider).listMapCampaignsByCreator(userId);
    });
  }
}
