import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Native maps render heatmaps via [GoogleMap.heatmaps]; no web overlay needed.
class MapHeatmapOverlay extends StatelessWidget {
  final GoogleMapController? controller;
  final List<WeightedLatLng> points;
  final bool enabled;
  final double? zoom;

  const MapHeatmapOverlay({
    super.key,
    required this.controller,
    required this.points,
    required this.enabled,
    this.zoom,
  });

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
