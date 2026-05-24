import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/maps/dashboard_heatmap_map.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// On web, delay building the map by this much so the rest of the dashboard
/// can paint first (reduces mobile Chrome reloads when navigating back to home).
const Duration _kDeferMapBuildOnWeb = Duration(milliseconds: 280);

/// Dashboard Maps pane: Google Maps heatmap of recent Map Submission actions.
class MapsSummary extends ConsumerStatefulWidget {
  final IconData icon;
  final Color color;

  const MapsSummary({super.key, required this.icon, required this.color});

  @override
  ConsumerState<MapsSummary> createState() => _MapsSummaryState();
}

class _MapsSummaryState extends ConsumerState<MapsSummary> {
  static const LatLng _defaultCenter = LatLng(39.8283, -98.5795); // US center
  static const double _defaultZoom = 3.5;
  static const double _fitBoundsScreenPadding = 60.0;

  /// User preference for map style only (independent of app theme).
  bool _mapDarkMode = false;

  /// On web we defer building the map so the dashboard can paint first.
  bool _showMap = !kIsWeb;

  @override
  void initState() {
    super.initState();
    if (!_showMap) {
      // Skip delay if action data is already cached — navigating back, not first load.
      final alreadyCached = ref.read(activeActionProvider).hasValue;
      if (alreadyCached) {
        _showMap = true;
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Future.delayed(_kDeferMapBuildOnWeb, () {
          if (mounted) setState(() => _showMap = true);
        });
      });
    }
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

  List<WeightedLatLng> _heatmapPoints(List<ActionSchema> submissions) {
    return submissions
        .map(
          (a) => WeightedLatLng(
            LatLng(a.latitude!.toDouble(), a.longitude!.toDouble()),
            weight: 1.0,
          ),
        )
        .toList();
  }

  Widget _buildGradientHeader(BuildContext context, bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradStart = isDark
        ? Color.lerp(widget.color, Colors.black, 0.45)!
        : const Color(0xFF14532D);
    final gradEnd = isDark
        ? Color.lerp(widget.color, Colors.black, 0.15)!
        : widget.color;

    return InkWell(
      onTap: () => safeGo(context, '/maps/cleanup'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14, isMobile ? 9 : 12, 14, isMobile ? 9 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradStart, gradEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 5 : 7),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: isMobile ? 17 : 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Maps',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: isMobile ? 14 : 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (!isMobile)
                    Text(
                      'Where action is happening',
                      style: TextStyle(
                        color: Colors.white.withAlpha(210),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withAlpha(200),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final actionsAsync = ref.watch(activeActionProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildGradientHeader(context, isMobile),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 8 : 12,
                isMobile ? 6 : 8,
                isMobile ? 8 : 12,
                isMobile ? 4 : 6,
              ),
              child: actionsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Failed to load map',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                data: (actions) {
                  final submissions = _mapSubmissionsWithLocation(actions);
                  if (!_showMap) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: SummaryCount(
                            count: submissions.length,
                            title: 'recent map submissions',
                          ),
                        ),
                      ],
                    );
                  }
                  final heatmapPoints = _heatmapPoints(submissions);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              DashboardHeatmapMap(
                                points: heatmapPoints,
                                darkMode: _mapDarkMode,
                                initialCenter: _defaultCenter,
                                initialZoom: _defaultZoom,
                                fitBoundsPadding: _fitBoundsScreenPadding,
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Material(
                                  color: Theme.of(context).colorScheme.surface
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
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
                                    onPressed: () {
                                      setState(
                                        () => _mapDarkMode = !_mapDarkMode,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SummaryCount(
                        count: submissions.length,
                        title: 'recent map submissions',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
