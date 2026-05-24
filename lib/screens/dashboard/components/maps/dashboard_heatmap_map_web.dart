import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:collective_action_frontend/screens/maps/map_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web/web.dart';

@JS('dashboardMapApi')
external _DashboardMapApi get _dashboardMapApi;

extension type _DashboardMapApi._(JSObject _) implements JSObject {
  external int create(HTMLElement container, String optionsJson);
  external void updateHeatmap(int id, String optionsJson);
  external void setStyle(int id, String? styleJson);
  external void destroy(int id);
}

/// Web dashboard map using deck.gl HeatmapLayer (Google's recommended replacement).
class DashboardHeatmapMap extends StatefulWidget {
  final List<WeightedLatLng> points;
  final bool darkMode;
  final LatLng initialCenter;
  final double initialZoom;
  final double fitBoundsPadding;
  final ValueChanged<GoogleMapController>? onMapCreated;

  const DashboardHeatmapMap({
    super.key,
    required this.points,
    required this.darkMode,
    this.initialCenter = const LatLng(39.8283, -98.5795),
    this.initialZoom = 3.5,
    this.fitBoundsPadding = 60,
    this.onMapCreated,
  });

  @override
  State<DashboardHeatmapMap> createState() => _DashboardHeatmapMapState();
}

class _DashboardHeatmapMapState extends State<DashboardHeatmapMap> {
  static int _viewCounter = 0;

  late final String _viewType;
  late final HTMLDivElement _container;
  int? _mapHandle;

  @override
  void initState() {
    super.initState();
    _viewType = 'dashboard-map-${_viewCounter++}';
    _container = HTMLDivElement()
      ..style.width = '100%'
      ..style.height = '100%';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int _) => _container,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _createOrUpdateMap());
  }

  String _optionsJson() {
    return jsonEncode(<String, Object?>{
      'center': <String, double>{
        'lat': widget.initialCenter.latitude,
        'lng': widget.initialCenter.longitude,
      },
      'zoom': widget.initialZoom,
      'padding': widget.fitBoundsPadding,
      'styleJson': widget.darkMode ? kDarkMapStyle : null,
      'points': widget.points
          .map(
            (p) => <String, double>{
              'lat': p.point.latitude,
              'lng': p.point.longitude,
              'weight': p.weight,
            },
          )
          .toList(),
    });
  }

  void _createOrUpdateMap() {
    if (!mounted) return;
    if (_mapHandle == null) {
      final handle = _dashboardMapApi.create(_container, _optionsJson());
      if (handle < 0) {
        Future<void>.delayed(
          const Duration(milliseconds: 50),
          _createOrUpdateMap,
        );
        return;
      }
      _mapHandle = handle;
      return;
    }
    _dashboardMapApi.updateHeatmap(_mapHandle!, _optionsJson());
  }

  @override
  void didUpdateWidget(covariant DashboardHeatmapMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_mapHandle == null) return;
    if (widget.points != oldWidget.points) {
      _dashboardMapApi.updateHeatmap(_mapHandle!, _optionsJson());
    }
    if (widget.darkMode != oldWidget.darkMode) {
      _dashboardMapApi.setStyle(
        _mapHandle!,
        widget.darkMode ? kDarkMapStyle : null,
      );
    }
  }

  @override
  void dispose() {
    final handle = _mapHandle;
    if (handle != null) {
      _dashboardMapApi.destroy(handle);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
