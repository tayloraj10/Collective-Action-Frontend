import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:collective_action_frontend/screens/maps/map_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Dashboard Maps pane: Google Maps heatmap of recent Map Submission actions.
class MapsSummary extends ConsumerStatefulWidget {
  final IconData icon;
  final Color color;

  const MapsSummary({super.key, required this.icon, required this.color});

  @override
  ConsumerState<MapsSummary> createState() => _MapsSummaryState();
}

class _MapsSummaryState extends ConsumerState<MapsSummary> {
  GoogleMapController? _mapController;
  static const LatLng _defaultCenter = LatLng(39.8283, -98.5795); // US center
  static const double _defaultZoom = 3.5;

  /// User preference for map style only (independent of app theme).
  bool _mapDarkMode = false;

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }

  /// Map submission actions that have latitude/longitude.
  List<ActionSchema> _mapSubmissionsWithLocation(List<ActionSchema>? actions) {
    if (actions == null) return [];
    return actions
        .where(
          (a) =>
              a.actionType == ActionTypeValuesEnum.mapSubmission.value &&
              a.latitude != null &&
              a.longitude != null,
        )
        .toList();
  }

  Set<Heatmap> _buildHeatmaps(List<ActionSchema> submissions) {
    if (submissions.isEmpty) return {};
    final points = submissions
        .map(
          (a) => WeightedLatLng(
            LatLng(a.latitude!.toDouble(), a.longitude!.toDouble()),
            weight: 1.0,
          ),
        )
        .toList();
    return {
      Heatmap(
        heatmapId: const HeatmapId('map_submissions'),
        data: points,
        radius: HeatmapRadius.fromPixels(30),
        opacity: 0.7,
        dissipating: true,
      ),
    };
  }

  Future<void> _fitBoundsIfNeeded(List<ActionSchema> submissions) async {
    if (submissions.isEmpty || _mapController == null) return;
    final points = submissions
        .map((a) => LatLng(a.latitude!.toDouble(), a.longitude!.toDouble()))
        .toList();
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
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final latPadding = latDiff > 0.001 ? latDiff * 0.15 : 0.05;
    final lngPadding = lngDiff > 0.001 ? lngDiff * 0.15 : 0.05;
    final bounds = LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final actionsAsync = ref.watch(activeActionProvider);
    final submissions = actionsAsync.maybeWhen(
      data: (actions) => _mapSubmissionsWithLocation(actions),
      orElse: () => <ActionSchema>[],
    );
    final heatmaps = _buildHeatmaps(submissions);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isMobile ? () => context.go('/maps/cleanup') : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 6 : 10,
            vertical: isMobile ? 4 : 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => context.go('/maps/cleanup'),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 10 : 12),
                      decoration: BoxDecoration(
                        color: widget.color.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: isMobile ? 20 : 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: isMobile
                          ? () => context.go('/maps/cleanup')
                          : null,
                      splashColor: isMobile
                          ? Theme.of(context).colorScheme.primary.withAlpha(30)
                          : null,
                      highlightColor: isMobile
                          ? Theme.of(context).colorScheme.primary.withAlpha(20)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Maps',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            if (isMobile) ...[
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(18),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withAlpha(38),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.open_in_new,
                                    size: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.color
                                        ?.withAlpha(210),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: actionsAsync.when(
                    data: (_) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          GoogleMap(
                            initialCameraPosition: const CameraPosition(
                              target: _defaultCenter,
                              zoom: _defaultZoom,
                            ),
                            style: _mapDarkMode ? kDarkMapStyle : null,
                            onMapCreated: (GoogleMapController c) async {
                              _mapController = c;
                              if (!mounted) return;
                              _fitBoundsIfNeeded(submissions);
                            },
                            heatmaps: heatmaps,
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            liteModeEnabled: false,
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Material(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(6),
                              child: IconButton(
                                iconSize: 20,
                                icon: Icon(
                                  _mapDarkMode
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  size: 20,
                                ),
                                tooltip: _mapDarkMode
                                    ? 'Map style: dark (tap for light)'
                                    : 'Map style: light (tap for dark)',
                                onPressed: () async {
                                  setState(() => _mapDarkMode = !_mapDarkMode);
                                  // ignore: deprecated_member_use
                                  await _mapController?.setMapStyle(
                                    _mapDarkMode ? kDarkMapStyle : null,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 8),
                          Text(
                            'Loading map…',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Could not load map',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SummaryCount(
                count: submissions.length,
                title: 'recent map submissions',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
