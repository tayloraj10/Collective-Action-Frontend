import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/map_service.dart';
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
