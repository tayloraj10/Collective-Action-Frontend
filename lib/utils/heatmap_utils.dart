import 'package:collective_action_frontend/api/lib/api.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Classic Google Maps heatmap gradient (blue → green → yellow → red).
const HeatmapGradient kMapHeatmapGradient = HeatmapGradient([
  HeatmapGradientColor(Color(0xFF0000FF), 0.0),
  HeatmapGradientColor(Color(0xFF00BFFF), 0.2),
  HeatmapGradientColor(Color(0xFF00FF00), 0.45),
  HeatmapGradientColor(Color(0xFFFFFF00), 0.65),
  HeatmapGradientColor(Color(0xFFFF8000), 0.85),
  HeatmapGradientColor(Color(0xFFFF0000), 1.0),
]);

/// Base heatmap radius when zoom is unknown; web/native scale up at close zoom.
const int kMapHeatmapBaseRadiusPixels = 40;
const HeatmapRadius kMapHeatmapRadius =
    HeatmapRadius.fromPixels(kMapHeatmapBaseRadiusPixels);
const double kMapHeatmapOpacity = 0.65;

/// Larger radius at close zoom so nearby points merge into soft blobs.
int heatmapRadiusPixelsForZoom(double? zoom) {
  final z = zoom ?? 10.0;
  const minRadius = 28.0;
  const maxRadius = 145.0;
  const lowZoom = 4.0;
  const highZoom = 14.0;
  final tLinear =
      ((z - lowZoom) / (highZoom - lowZoom)).clamp(0.0, 1.0);
  // Ramp up faster at neighborhood zoom (~0.5 mile view).
  final t = 1.0 - (1.0 - tLinear) * (1.0 - tLinear);
  return (minRadius + (maxRadius - minRadius) * t).round();
}

Set<Heatmap> buildMapHeatmaps(List<WeightedLatLng> points, {double? zoom}) {
  if (points.isEmpty) return {};
  return {
    Heatmap(
      heatmapId: const HeatmapId('campaign_events'),
      data: points,
      gradient: kMapHeatmapGradient,
      radius: HeatmapRadius.fromPixels(heatmapRadiusPixelsForZoom(zoom)),
      opacity: kMapHeatmapOpacity,
      dissipating: false,
    ),
  };
}

List<WeightedLatLng> weightedPointsFromActions(
  Iterable<ActionSchema> actions, {
  Map<String, LatLng>? positionOverrides,
}) {
  final out = <WeightedLatLng>[];
  for (final action in actions) {
    if (action.latitude == null || action.longitude == null) continue;
    final override = positionOverrides?[action.id];
    final point = override ??
        LatLng(action.latitude!.toDouble(), action.longitude!.toDouble());
    out.add(WeightedLatLng(point, weight: 1.0));
  }
  return out;
}
