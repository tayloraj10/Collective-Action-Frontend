import 'package:collective_action_frontend/screens/maps/map_styles.dart';
import 'package:collective_action_frontend/utils/heatmap_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Native/mobile dashboard map using the platform Google Maps heatmap layer.
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
  GoogleMapController? _controller;

  Set<Heatmap> _buildHeatmaps() {
    return buildMapHeatmaps(widget.points);
  }

  Future<void> _fitBoundsIfNeeded() async {
    if (widget.points.isEmpty || _controller == null) return;

    final points = widget.points.map((p) => p.point).toList();
    if (points.length == 1) {
      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 10.0),
        ),
      );
      return;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final latDiff = (maxLat - minLat).abs();
    final lngDiff = (maxLng - minLng).abs();
    final latPadding = latDiff < 0.002 ? 0.02 : 0.0;
    final lngPadding = lngDiff < 0.002 ? 0.02 : 0.0;
    final bounds = LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );
    await _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, widget.fitBoundsPadding),
    );
  }

  @override
  void didUpdateWidget(covariant DashboardHeatmapMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.points != oldWidget.points) {
      _fitBoundsIfNeeded();
    }
    if (widget.darkMode != oldWidget.darkMode && _controller != null) {
      // ignore: deprecated_member_use
      _controller!.setMapStyle(widget.darkMode ? kDarkMapStyle : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.initialCenter,
        zoom: widget.initialZoom,
      ),
      style: widget.darkMode ? kDarkMapStyle : null,
      onMapCreated: (GoogleMapController c) async {
        _controller = c;
        widget.onMapCreated?.call(c);
        if (!mounted) return;
        await _fitBoundsIfNeeded();
      },
      heatmaps: _buildHeatmaps(),
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      liteModeEnabled: false,
    );
  }
}
