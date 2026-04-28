import 'dart:async';

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Category → Google Maps hue (0–360).
const Map<String, double> _kCategoryHues = {
  'environment': BitmapDescriptor.hueGreen,
  'water': BitmapDescriptor.hueCyan,
  'trash': BitmapDescriptor.hueAzure,
  'animals': BitmapDescriptor.hueOrange,
  'fitness': BitmapDescriptor.hueRed,
  'nature': BitmapDescriptor.hueMagenta,
};

class NetworkMapView extends StatefulWidget {
  const NetworkMapView({
    super.key,
    required this.dogs,
    required this.categories,
    required this.dogSummaries,
    required this.selectedId,
    required this.onSelect,
  });

  final List<DirectoryOfGoodSchema> dogs;
  final List<CategorySchema> categories;
  final Map<String, ConnectionSummarySchema> dogSummaries;
  final String? selectedId;
  final void Function(String id, String type) onSelect;

  @override
  State<NetworkMapView> createState() => _NetworkMapViewState();
}

class _NetworkMapViewState extends State<NetworkMapView> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void didUpdateWidget(NetworkMapView old) {
    super.didUpdateWidget(old);
    if (old.dogs != widget.dogs ||
        old.dogSummaries != widget.dogSummaries ||
        old.selectedId != widget.selectedId) {
      _buildMarkers();
    }
  }

  void _buildMarkers() {
    final catById = {
      for (final c in widget.categories) c.id: c
    };

    final markers = <Marker>{};
    for (final d in widget.dogs) {
      final lat = d.latitude?.toDouble();
      final lng = d.longitude?.toDouble();
      if (lat == null || lng == null) continue;

      final id = d.id ?? d.name;
      final summary = widget.dogSummaries[id];
      final totalConns = summary?.totalCount ?? 0;
      final isSelected = widget.selectedId == id;

      // Pick hue from primary category name.
      double hue = BitmapDescriptor.hueGreen;
      if (d.categoryIds.isNotEmpty) {
        final catName =
            catById[d.categoryIds.first]?.name.toLowerCase() ?? '';
        for (final entry in _kCategoryHues.entries) {
          if (catName.contains(entry.key)) {
            hue = entry.value;
            break;
          }
        }
      }

      markers.add(Marker(
        markerId: MarkerId(id),
        position: LatLng(lat, lng),
        icon: isSelected
            ? BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow)
            : BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: d.name,
          snippet: totalConns > 0
              ? '$totalConns connection${totalConns == 1 ? '' : 's'}'
              : d.location?.city ?? '',
          onTap: () => widget.onSelect(id, 'directory_of_good'),
        ),
        onTap: () => widget.onSelect(id, 'directory_of_good'),
        zIndexInt: isSelected ? 2 : (1 + (totalConns * 0.1).round()),
      ));
    }

    setState(() => _markers = markers);
  }

  LatLng _initialCenter() {
    // Centroid of geocoded entries, fallback to continental US.
    final geocoded = widget.dogs
        .where((d) => d.latitude != null && d.longitude != null)
        .toList();
    if (geocoded.isEmpty) return const LatLng(39.5, -98.35);
    final avgLat = geocoded
            .map((d) => d.latitude!.toDouble())
            .reduce((a, b) => a + b) /
        geocoded.length;
    final avgLng = geocoded
            .map((d) => d.longitude!.toDouble())
            .reduce((a, b) => a + b) /
        geocoded.length;
    return LatLng(avgLat, avgLng);
  }

  @override
  Widget build(BuildContext context) {
    final geocodedCount =
        widget.dogs.where((d) => d.latitude != null).length;

    if (geocodedCount == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined,
                size: 48,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(60)),
            const SizedBox(height: 16),
            Text(
              'No geocoded entries yet.\nRun the sheet sync to populate coordinates.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withAlpha(120)),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialCenter(),
            zoom: geocodedCount > 20 ? 4.0 : 6.0,
          ),
          markers: _markers,
          onMapCreated: (c) => _ctrl.complete(c),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
        ),
        // Pin count overlay
        Positioned(
          bottom: 16, left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(160),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$geocodedCount locations mapped',
              style: const TextStyle(
                  color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
