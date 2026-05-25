import 'package:collective_action_frontend/utils/map_area_geometry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapAreaGeometryServiceProvider = Provider<MapAreaGeometryService>((ref) {
  return MapAreaGeometryService();
});

/// Loaded GeoJSON regions/layers from [assets/data/map_areas/manifest.json].
final mapAreaGeometryProvider = FutureProvider<List<MapAreaGeometryRegion>>((ref) async {
  return ref.read(mapAreaGeometryServiceProvider).loadManifest();
});

class MapAreaLayersVisibleState {
  const MapAreaLayersVisibleState({
    this.showAreas = true,
    this.showNeighborhoods = false,
  });

  final bool showAreas;
  final bool showNeighborhoods;

  MapAreaLayersVisibleState copyWith({bool? showAreas, bool? showNeighborhoods}) {
    return MapAreaLayersVisibleState(
      showAreas: showAreas ?? this.showAreas,
      showNeighborhoods: showNeighborhoods ?? this.showNeighborhoods,
    );
  }
}

class MapAreaLayersVisibleNotifier extends Notifier<MapAreaLayersVisibleState> {
  @override
  MapAreaLayersVisibleState build() => const MapAreaLayersVisibleState();

  void setShowAreas(bool value) {
    state = state.copyWith(
      showAreas: value,
      showNeighborhoods: value ? state.showNeighborhoods : false,
    );
  }

  void setShowNeighborhoods(bool value) {
    if (value && !state.showAreas) return;
    state = state.copyWith(showNeighborhoods: value);
  }
}

final mapAreaLayersVisibleProvider =
    NotifierProvider<MapAreaLayersVisibleNotifier, MapAreaLayersVisibleState>(
  MapAreaLayersVisibleNotifier.new,
);
