import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@JS('dashboardMapApi')
external _DashboardMapApi get _dashboardMapApi;

extension type _DashboardMapApi._(JSObject _) implements JSObject {
  external int attachHeatmapToFlutterMap(int flutterMapId, String pointsJson);
  external void updateFlutterMapHeatmap(int overlayId, String pointsJson);
  external void detachHeatmap(int overlayId);
}

/// Attaches a deck.gl heatmap to an existing Flutter [GoogleMap] on web.
class MapHeatmapOverlay extends StatefulWidget {
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
  State<MapHeatmapOverlay> createState() => _MapHeatmapOverlayState();
}

class _MapHeatmapOverlayState extends State<MapHeatmapOverlay> {
  int? _overlayId;
  int? _flutterMapId;

  String _configJson() {
    return jsonEncode(<String, Object?>{
      'points': widget.points
          .map(
            (p) => <String, double>{
              'lat': p.point.latitude,
              'lng': p.point.longitude,
              'weight': p.weight,
            },
          )
          .toList(),
      if (widget.zoom != null) 'zoom': widget.zoom,
    });
  }

  void _syncOverlay() {
    if (!widget.enabled || widget.controller == null) {
      _detach();
      return;
    }

    final mapId = widget.controller!.mapId;
    if (_overlayId != null && _flutterMapId == mapId) {
      _dashboardMapApi.updateFlutterMapHeatmap(_overlayId!, _configJson());
      return;
    }

    _detach();
    final overlayId = _dashboardMapApi.attachHeatmapToFlutterMap(
      mapId,
      _configJson(),
    );
    if (overlayId < 0) {
      Future<void>.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _syncOverlay();
      });
      return;
    }
    _overlayId = overlayId;
    _flutterMapId = mapId;
  }

  void _detach() {
    final overlayId = _overlayId;
    if (overlayId != null) {
      _dashboardMapApi.detachHeatmap(overlayId);
    }
    _overlayId = null;
    _flutterMapId = null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  @override
  void didUpdateWidget(covariant MapHeatmapOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled ||
        widget.controller != oldWidget.controller ||
        widget.points != oldWidget.points ||
        widget.zoom != oldWidget.zoom) {
      _syncOverlay();
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
