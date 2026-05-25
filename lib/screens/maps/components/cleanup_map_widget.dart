import 'dart:async';

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/hotspot_provider.dart';
import 'package:collective_action_frontend/providers/map_area_geometry_provider.dart';
import 'package:collective_action_frontend/providers/map_events_provider.dart';
import 'package:collective_action_frontend/providers/map_provider.dart';
import 'package:collective_action_frontend/providers/map_zoom_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/maps/components/area_captain_map_badges.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_event_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_event_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/hotspot_event_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/hotspot_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/map_heatmap_overlay.dart';
import 'package:collective_action_frontend/screens/maps/components/nearby_filter_mask_overlay.dart';
import 'package:collective_action_frontend/screens/maps/components/pin_confirmation_bar.dart';
import 'package:collective_action_frontend/screens/maps/components/planting_event_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/planting_event_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/trash_report_event_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/trash_report_event_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/map_styles.dart';
import 'package:collective_action_frontend/services/actions_service.dart';
import 'package:collective_action_frontend/services/hotspot_service.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:collective_action_frontend/utils/heatmap_utils.dart';
import 'package:collective_action_frontend/utils/map_filter_utils.dart';
import 'package:collective_action_frontend/utils/map_area_geometry.dart';
import 'package:collective_action_frontend/utils/map_area_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Action type enum values used for map campaign actions.
const EventDataType _kActionTypeCleanup = EventDataType.cleanup;
const EventDataType _kActionTypeTrashReport = EventDataType.trashReport;
const EventDataType _kActionTypeCleanupRoute = EventDataType.cleanupRoute;
const EventDataType _kActionTypeTreePlanting = EventDataType.treePlanting;
const EventDataType _kActionTypeWildflowerPlanting =
    EventDataType.wildflowerPlanting;

/// Asset paths for map pins and mode buttons.
const String _kAssetClean = 'assets/images/clean.png';
const String _kAssetCleanScheduled = 'assets/images/clean-scheduled.png';
const String _kAssetTrash = 'assets/images/trash.png';
const String _kAssetPlanting = 'assets/images/planting.png';
// const String _kAssetDraw = 'assets/images/draw.png';
const String _kAssetCurrentLocation = 'assets/images/current-location.png';

/// Widget for cleanup map type - supports dropping pins and drawing routes.
class CleanupMapWidget extends ConsumerStatefulWidget {
  final MapCampaignSchema campaign;
  final GoogleMapController? mapController;

  const CleanupMapWidget({
    super.key,
    required this.campaign,
    this.mapController,
  });

  @override
  ConsumerState<CleanupMapWidget> createState() => _CleanupMapWidgetState();
}

/// Default zoom when centering on user location.
const double _kUserLocationZoom = 15.6;

/// Hide user location marker when zoomed out past this level so it doesn't look like it's floating.
const double _kMinZoomToShowUserLocation = 12;

/// Delay before showing the "click a button" instruction when user is idle.
const Duration _kInstructionDelay = Duration(seconds: 10);

class _CleanupMapWidgetState extends ConsumerState<CleanupMapWidget> {
  Set<Marker> _tempMarkers = {};
  Set<Polyline> _tempPolylines = {};
  List<LatLng> _routePoints = [];

  String? _mode;
  bool _pinDropped = false;
  LatLng? _droppedPosition;
  String? _droppedType;
  bool _confirmingRoute = false;

  /// True while Add Cleanup or Report Trash dialog is open; disables map gestures.
  bool _isAddEventDialogOpen = false;

  /// True while Cleanup or Trash Report info (view) dialog is open; disables map gestures.
  bool _isInfoDialogOpen = false;

  /// Positions we dropped pins at; used when building markers so pins stay where the user clicked
  /// even if the backend (e.g. after photo upload) returns different coordinates.
  final Map<String, LatLng> _createdActionPositionOverride = {};

  BitmapDescriptor? _cleanupMarkerIcon;
  BitmapDescriptor? _scheduledCleanupMarkerIcon;
  BitmapDescriptor? _trashMarkerIcon;
  BitmapDescriptor? _plantingMarkerIcon;
  BitmapDescriptor? _currentLocationMarkerIcon;
  BitmapDescriptor? _hotspotMarkerIcon;

  GoogleMapController? _mapController;
  LatLng? _userLocation;
  double? _currentZoom;
  bool _didAutoZoomToData = false;

  /// User preference for map style only (independent of app theme).
  bool _mapDarkMode = false;

  Timer? _inactivityTimer;
  Timer? _nearbyMaskGeometryDebounce;
  Timer? _captainBadgeGeometryDebounce;
  Timer? _areaTooltipTimer;
  bool _showInstruction = false;
  final bool _isDisposed = false;

  /// Screen-space center and radius for the nearby-filter dim overlay.
  Offset? _nearbyMaskCenterPx;
  double? _nearbyMaskRadiusPx;

  String? _areaTooltipName;
  Offset? _areaTooltipOffset;
  List<AreaCaptainBadgeLayout> _captainBadgeLayouts = [];

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    if (_showInstruction && mounted) {
      setState(() => _showInstruction = false);
    }
    _inactivityTimer = Timer(_kInstructionDelay, () {
      if (!mounted) return;
      if (_mode == null && !_pinDropped && !_confirmingRoute) {
        setState(() => _showInstruction = true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Defer async work to after first frame (Flutter 3.38 / Riverpod 3.x safety)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadMarkerIcons();
      _resetInactivityTimer();
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _nearbyMaskGeometryDebounce?.cancel();
    _captainBadgeGeometryDebounce?.cancel();
    _areaTooltipTimer?.cancel();
    _mapController = null;
    super.dispose();
  }

  void _scheduleNearbyMaskGeometryUpdate() {
    final nearby = ref.read(mapNearbyFilterProvider);
    if (!nearby.enabled || _userLocation == null || _mapController == null) {
      return;
    }
    _nearbyMaskGeometryDebounce?.cancel();
    _nearbyMaskGeometryDebounce = Timer(const Duration(milliseconds: 32), () {
      if (mounted) unawaited(_updateNearbyMaskGeometry());
    });
  }

  Future<void> _updateNearbyMaskGeometry() async {
    final nearby = ref.read(mapNearbyFilterProvider);
    if (!mounted ||
        !nearby.enabled ||
        _userLocation == null ||
        _mapController == null) {
      if (mounted &&
          (_nearbyMaskCenterPx != null || _nearbyMaskRadiusPx != null)) {
        setState(() {
          _nearbyMaskCenterPx = null;
          _nearbyMaskRadiusPx = null;
        });
      }
      return;
    }

    final controller = _mapController!;
    final center = _userLocation!;
    final radiusMeters = nearby.radiusMiles * 1609.344;

    try {
      final centerSc = await controller.getScreenCoordinate(center);
      final edgeSc = await controller.getScreenCoordinate(
        offsetLatLngMeters(center, radiusMeters, 90),
      );
      if (!mounted) return;

      final centerPx = Offset(centerSc.x.toDouble(), centerSc.y.toDouble());
      final edgePx = Offset(edgeSc.x.toDouble(), edgeSc.y.toDouble());
      final radiusPx = (edgePx - centerPx).distance;

      if (_nearbyMaskCenterPx == centerPx &&
          _nearbyMaskRadiusPx != null &&
          (_nearbyMaskRadiusPx! - radiusPx).abs() < 0.5) {
        return;
      }

      setState(() {
        _nearbyMaskCenterPx = centerPx;
        _nearbyMaskRadiusPx = radiusPx;
      });
    } catch (_) {}
  }

  void _scheduleCaptainBadgeUpdate() {
    if (!_isCleanupCampaign || _mapController == null) return;
    final visibility = ref.read(mapAreaLayersVisibleProvider);
    if (!visibility.showAreas || visibility.showNeighborhoods) {
      if (_captainBadgeLayouts.isNotEmpty) {
        setState(() => _captainBadgeLayouts = []);
      }
      return;
    }
    _captainBadgeGeometryDebounce?.cancel();
    _captainBadgeGeometryDebounce = Timer(const Duration(milliseconds: 32), () {
      if (mounted) unawaited(_updateCaptainBadgePositions());
    });
  }

  List<MapAreaPolygonFeature> _boroughGeometryFeatures(
    AsyncValue<List<MapAreaGeometryRegion>>? geometryAsync,
  ) {
    final regions = geometryAsync?.value;
    if (regions == null) return [];
    for (final region in regions) {
      for (final layer in region.layers) {
        if (layer.id == 'boroughs') return layer.features;
      }
    }
    return [];
  }

  Future<void> _updateCaptainBadgePositions() async {
    if (!mounted || !_isCleanupCampaign || _mapController == null) return;

    final backendAreas =
        ref.read(mapAreasForCampaignProvider(widget.campaign.id)).value ??
        const [];
    final captains =
        ref.read(areaCaptainsForCampaignProvider(widget.campaign.id)).value ??
        const [];
    if (captains.isEmpty) {
      if (_captainBadgeLayouts.isNotEmpty) {
        setState(() => _captainBadgeLayouts = []);
      }
      return;
    }

    final boroughFeatures = _boroughGeometryFeatures(
      ref.read(mapAreaGeometryProvider),
    );
    final grouped = groupCaptainsByAreaId(captains);
    final controller = _mapController!;
    final layouts = <AreaCaptainBadgeLayout>[];

    for (final area in backendAreas.where((a) => a.areaType == 'borough')) {
      final assignments = grouped[area.id];
      if (assignments == null || assignments.isEmpty) continue;
      final anchor = areaBadgeAnchor(area, boroughFeatures);
      if (anchor == null) continue;
      try {
        final screenPoint = await controller.getScreenCoordinate(anchor);
        layouts.add(
          AreaCaptainBadgeLayout(
            area: area,
            assignments: assignments,
            screenOffset: Offset(
              screenPoint.x.toDouble(),
              screenPoint.y.toDouble(),
            ),
          ),
        );
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() => _captainBadgeLayouts = layouts);
  }

  Future<void> _loadMarkerIcons() async {
    if (!mounted) return;
    const config = ImageConfiguration(size: Size(40, 40));
    final clean = await BitmapDescriptor.asset(config, _kAssetClean);
    if (!mounted) return;
    final cleanScheduled = await BitmapDescriptor.asset(
      config,
      _kAssetCleanScheduled,
    );
    if (!mounted) return;
    final trash = await BitmapDescriptor.asset(config, _kAssetTrash);
    if (!mounted) return;
    final planting = await BitmapDescriptor.asset(config, _kAssetPlanting);
    if (!mounted) return;
    const currentLocationConfig = ImageConfiguration(size: Size(30, 30));
    final currentLocation = await BitmapDescriptor.asset(
      currentLocationConfig,
      _kAssetCurrentLocation,
    );
    if (!mounted) return;
    final hotspot = await createHotspotMarkerIcon();
    if (mounted) {
      setState(() {
        _cleanupMarkerIcon = clean;
        _scheduledCleanupMarkerIcon = cleanScheduled;
        _trashMarkerIcon = trash;
        _plantingMarkerIcon = planting;
        _currentLocationMarkerIcon = currentLocation;
        _hotspotMarkerIcon = hotspot;
      });
    }
  }

  /// Purple pin only while the cleanup is still upcoming (same cutoff as RSVP).
  static bool _isScheduledCleanup(ActionSchema action) {
    final data = CleanupEventInfoDialog.eventDataFromAction(action);
    final scheduledStart = data?.scheduledStart;
    if (scheduledStart == null) return false;
    final cutoff = data?.scheduledEnd ?? scheduledStart;
    return !DateTime.now().isAfter(cutoff.toLocal());
  }

  BitmapDescriptor _iconForCleanup({bool scheduled = false}) {
    if (scheduled) {
      return _scheduledCleanupMarkerIcon ??
          _cleanupMarkerIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    }
    return _cleanupMarkerIcon ??
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  BitmapDescriptor _iconForTrash() =>
      _trashMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor _iconForPlanting() =>
      _plantingMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor _iconForCurrentLocation() =>
      _currentLocationMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  BitmapDescriptor _iconForHotspot() =>
      _hotspotMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);

  bool get _isCleanupCampaign =>
      widget.campaign.mapCampaignType == MapCampaignTypeEnum.cleanupMap.value;

  bool get _isPlantingCampaign =>
      widget.campaign.mapCampaignType == MapCampaignTypeEnum.plantingMap.value;

  /// Fetches current position, updates state, and optionally zooms the map.
  Future<bool> _loadUserLocation({bool zoomToNearbyFilter = false}) async {
    if (!mounted) return false;
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return false;
    if (!serviceEnabled && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.warning('Location services are disabled'));
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (!mounted) return false;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!mounted) return false;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.warning('Location permission denied'));
      }
      return false;
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
      if (!mounted) return false;
      final latLng = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() => _userLocation = latLng);
      }
      if (mounted) {
        final nearby = ref.read(mapNearbyFilterProvider);
        if (zoomToNearbyFilter && nearby.enabled) {
          await _zoomToNearbyRadius(nearby.radiusMiles);
        } else {
          await _goToUserLocation();
        }
      }
      if (mounted) {
        _scheduleNearbyMaskGeometryUpdate();
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Could not get location: $e'));
      }
      return false;
    }
  }

  /// Moves the map camera to the user's location (if known).
  Future<void> _goToUserLocation() async {
    if (!mounted || _userLocation == null || _mapController == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(_userLocation!, _kUserLocationZoom),
    );
  }

  /// Zooms the map to fit the nearby-filter circle around the user.
  Future<void> _zoomToNearbyRadius(double radiusMiles) async {
    if (!mounted || _userLocation == null || _mapController == null) return;
    final bounds = nearbyRadiusBounds(_userLocation!, radiusMiles);
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
    if (mounted) {
      _scheduleNearbyMaskGeometryUpdate();
    }
  }

  /// Zooms to show all markers and polylines on the map.
  Future<bool> _zoomToFullExtent() async {
    if (!mounted || _mapController == null) return false;

    final eventsAsync = ref.read(
      mapEventsForCampaignProvider(widget.campaign.id),
    );
    final currentUser = ref.read(currentUserProvider).value;
    final rawEvents = eventsAsync.value;
    final eventsToShow = _filterMapEvents(
      rawEvents,
      currentUser,
      filterMySubmissionsOnly: ref.read(mapFilterMySubmissionsOnlyProvider),
      nearbyFilter: ref.read(mapNearbyFilterProvider),
    );
    final markers = _buildMarkers(eventsToShow, currentUser);
    final polylines = _buildPolylines(eventsToShow);

    // Collect all LatLng positions from markers and polylines (exclude user location)
    final List<LatLng> allPoints = [];

    // Add marker positions (ignore user position icon so extent is data-only)
    const userLocationMarkerId = MarkerId('current_location');
    for (final marker in markers) {
      if (marker.markerId == userLocationMarkerId) continue;
      allPoints.add(marker.position);
    }

    // Add polyline points
    for (final polyline in polylines) {
      allPoints.addAll(polyline.points);
    }

    // Add temp markers and polylines
    for (final marker in _tempMarkers) {
      allPoints.add(marker.position);
    }
    for (final polyline in _tempPolylines) {
      allPoints.addAll(polyline.points);
    }

    if (_isCleanupCampaign) {
      final hotspots =
          ref.read(mapHotspotsForCampaignProvider(widget.campaign.id)).value ??
          const [];
      for (final h in hotspots) {
        if (h.active) {
          allPoints.add(LatLng(h.latitude.toDouble(), h.longitude.toDouble()));
        }
      }
    }

    if (allPoints.isEmpty) return false;

    // Calculate bounds
    double minLat = allPoints.first.latitude;
    double maxLat = allPoints.first.latitude;
    double minLng = allPoints.first.longitude;
    double maxLng = allPoints.first.longitude;

    for (final point in allPoints) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    // Add padding to bounds (use minimum padding if bounds are too small)
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final latPadding = latDiff > 0.001 ? latDiff * 0.1 : 0.01;
    final lngPadding = lngDiff > 0.001 ? lngDiff * 0.1 : 0.01;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0),
    );
    return true;
  }

  List<ActionSchema>? _filterMapEvents(
    List<ActionSchema>? rawEvents,
    UserSchema? currentUser, {
    required bool filterMySubmissionsOnly,
    required MapNearbyFilterState nearbyFilter,
  }) {
    if (rawEvents == null) return null;
    var events = rawEvents;
    if (filterMySubmissionsOnly && currentUser != null) {
      events = events.where((a) => a.userId == currentUser.id).toList();
    }
    if (nearbyFilter.enabled && _userLocation != null) {
      events = filterActionsByNearbyRadius(
        events,
        _userLocation!,
        nearbyFilter.radiusMiles,
      );
    }
    return events;
  }

  List<WeightedLatLng> _heatmapPointsFromEvents(List<ActionSchema>? events) {
    if (events == null) return [];
    final points = <WeightedLatLng>[];
    for (final a in events) {
      if (a.latitude == null || a.longitude == null) continue;
      if (a.actionType != ActionTypeValuesEnum.mapSubmission.value ||
          a.eventData == null) {
        continue;
      }
      final eventType = a.eventData!['type'] as String?;
      final isCleanup = eventType == _kActionTypeCleanup.value;
      final isTrash = eventType == _kActionTypeTrashReport.value;
      if (isTrash && a.resolvedAt != null) continue;
      final isPlanting =
          eventType == _kActionTypeTreePlanting.value ||
          eventType == _kActionTypeWildflowerPlanting.value;
      if (!isCleanup && !isTrash && !isPlanting) continue;
      final position =
          _createdActionPositionOverride[a.id] ??
          LatLng(a.latitude!.toDouble(), a.longitude!.toDouble());
      points.add(WeightedLatLng(position, weight: 1.0));
    }
    return points;
  }

  double _modeSelectorTopPadding(BuildContext context) {
    const baseTop = 108.0;
    var top = baseTop;
    final nearby = ref.watch(mapNearbyFilterProvider);
    top += 44;
    if (nearby.enabled) {
      top += 44;
    }
    if (ref.watch(currentUserProvider).value != null) {
      top += 44;
    }
    top += 44; // Heatmap toggle row on map screen
    if (_isCleanupCampaign) {
      top += 44; // Areas toggle row on map screen
      if (ref.watch(mapAreaLayersVisibleProvider).showAreas) {
        top += 44; // Neighborhoods toggle row on map screen
      }
    }
    return top;
  }

  Future<void> _zoomToUSAExtent() async {
    if (!mounted || _mapController == null) return;
    final usaBounds = LatLngBounds(
      southwest: LatLng(24.396308, -124.848974),
      northeast: LatLng(49.384358, -66.885444),
    );
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(usaBounds, 40.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink();
    }
    ref.listen<LatLng?>(mapZoomToLocationProvider, (prev, next) {
      if (next != null && _mapController != null && mounted && !_isDisposed) {
        // Offset target slightly south so the pin appears in the upper half
        // (campaign drawer covers bottom half of screen).
        const offsetDegrees = 0.003;
        final target = LatLng(next.latitude - offsetDegrees, next.longitude);
        _mapController!.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
        ref.read(mapZoomToLocationProvider.notifier).setLocation(null);
      }
    });
    ref.listen<MapNearbyFilterState>(mapNearbyFilterProvider, (prev, next) {
      if (!mounted || _isDisposed) return;

      final turnedOn = next.enabled && prev?.enabled != true;
      final radiusChanged =
          next.enabled && prev?.radiusMiles != next.radiusMiles;
      final shouldZoomToCircle = turnedOn || radiusChanged;

      if (shouldZoomToCircle) {
        if (_userLocation != null) {
          unawaited(_zoomToNearbyRadius(next.radiusMiles));
        } else {
          unawaited(_loadUserLocation(zoomToNearbyFilter: true));
        }
      } else if (next.enabled && _userLocation == null) {
        unawaited(_loadUserLocation());
      }

      if (!next.enabled) {
        setState(() {
          _nearbyMaskCenterPx = null;
          _nearbyMaskRadiusPx = null;
        });
      } else {
        _scheduleNearbyMaskGeometryUpdate();
      }
    });
    ref.listen<MapAreaLayersVisibleState>(
      mapAreaLayersVisibleProvider,
      (prev, next) {
        if (!mounted || _isDisposed) return;
        if (next.showNeighborhoods || !next.showAreas) {
          if (_captainBadgeLayouts.isNotEmpty) {
            setState(() => _captainBadgeLayouts = []);
          }
          return;
        }
        if (prev?.showNeighborhoods == true && !next.showNeighborhoods) {
          _scheduleCaptainBadgeUpdate();
        }
      },
    );
    ref.watch(mapFilterMySubmissionsOnlyProvider);
    final heatmapEnabled = ref.watch(mapHeatmapEnabledProvider);
    final nearbyFilter = ref.watch(mapNearbyFilterProvider);
    final eventsAsync = ref.watch(
      mapEventsForCampaignProvider(widget.campaign.id),
    );
    final hotspotsAsync = _isCleanupCampaign
        ? ref.watch(mapHotspotsForCampaignProvider(widget.campaign.id))
        : null;
    final captainsAsync = _isCleanupCampaign
        ? ref.watch(areaCaptainsForCampaignProvider(widget.campaign.id))
        : null;
    final hotspots = hotspotsAsync?.value ?? const [];
    final captains = captainsAsync?.value ?? const [];
    final currentUser = ref.watch(currentUserProvider).value;
    final canManageHotspots = _isCleanupCampaign &&
        canUserManageHotspots(
          userId: currentUser?.id,
          captainsAsync: captainsAsync ?? const AsyncValue.data([]),
        );
    if (_isCleanupCampaign && captainsAsync != null) {
      ref.listen(areaCaptainsForCampaignProvider(widget.campaign.id), (
        prev,
        next,
      ) {
        if (!canUserManageHotspots(
          userId: ref.read(currentUserProvider).value?.id,
          captainsAsync: next,
        )) {
          if (mounted && _mode == 'hotspot') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _mode = null);
            });
          }
        }
      });
    }
    ref.listen(currentUserProvider, (prev, next) {
      if (!_isCleanupCampaign) return;
      if (!canUserManageHotspots(
        userId: next.value?.id,
        captainsAsync: ref.read(
          areaCaptainsForCampaignProvider(widget.campaign.id),
        ),
      )) {
        if (mounted && _mode == 'hotspot') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _mode = null);
          });
        }
      }
    });
    final backendAreasAsync = _isCleanupCampaign
        ? ref.watch(mapAreasForCampaignProvider(widget.campaign.id))
        : null;
    final geometryAsync = _isCleanupCampaign
        ? ref.watch(mapAreaGeometryProvider)
        : null;
    final areaLayerVisibility = ref.watch(mapAreaLayersVisibleProvider);
    final backendAreas = backendAreasAsync?.value ?? const [];
    final rawEvents = eventsAsync.value;
    final eventsToShow = _filterMapEvents(
      rawEvents,
      currentUser,
      filterMySubmissionsOnly: ref.read(mapFilterMySubmissionsOnlyProvider),
      nearbyFilter: nearbyFilter,
    );
    final heatmapPoints = _heatmapPointsFromEvents(eventsToShow);
    final campaignDrawerOpen = ref.watch(campaignDrawerOpenProvider);
    final areaCaptainsSheetOpen = ref.watch(areaCaptainsSheetOpenProvider);
    final areaPolygons = _buildAreaBoundaryPolygons(
      geometryAsync: geometryAsync,
      backendAreas: backendAreas,
      captains: captains,
      currentUserId: currentUser?.id,
      showAreas: areaLayerVisibility.showAreas,
      showNeighborhoods: areaLayerVisibility.showNeighborhoods,
      enableAreaTap: _mode == null && !_pinDropped,
    );
    final gesturesEnabled =
        !_isAddEventDialogOpen &&
        !_isInfoDialogOpen &&
        !campaignDrawerOpen &&
        !areaCaptainsSheetOpen;

    if (_isCleanupCampaign &&
        _mapController != null &&
        captainsAsync?.value != null &&
        areaLayerVisibility.showAreas &&
        !areaLayerVisibility.showNeighborhoods) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scheduleCaptainBadgeUpdate();
      });
    }

    if (nearbyFilter.enabled &&
        _userLocation != null &&
        _mapController != null &&
        _nearbyMaskCenterPx == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scheduleNearbyMaskGeometryUpdate();
      });
    }

    // If we don't have user location (permission denied/unavailable), auto-zoom
    // to data extent once data arrives; if there's no data, keep USA extent.
    if (_mapController != null &&
        _userLocation == null &&
        rawEvents != null &&
        !_didAutoZoomToData) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || _mapController == null || _didAutoZoomToData) return;
        final didZoom = await _zoomToFullExtent();
        if (!mounted || _mapController == null) return;
        if (!didZoom) {
          await _zoomToUSAExtent();
        }
        if (mounted) setState(() => _didAutoZoomToData = true);
      });
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(39.8283, -98.5795), // US center
            zoom: 3.5,
          ),
          style: _mapDarkMode ? kDarkMapStyle : null,
          onMapCreated: (GoogleMapController c) async {
            if (!mounted || _isDisposed) return;
            _mapController = c;
            final gotLocation = await _loadUserLocation();
            if (!mounted || _isDisposed) return;
            if (!gotLocation) {
              // Try to zoom to extent of already-loaded data; otherwise show USA.
              final didZoom = await _zoomToFullExtent();
              if (!mounted || _isDisposed) return;
              if (!didZoom) {
                await _zoomToUSAExtent();
              }
              if (mounted) setState(() => _didAutoZoomToData = true);
            }
            if (!mounted || _isDisposed) return;
            final zoom = await c.getZoomLevel();
            if (mounted && !_isDisposed) {
              setState(() => _currentZoom = zoom);
            }
            _scheduleNearbyMaskGeometryUpdate();
            _scheduleCaptainBadgeUpdate();
          },
          onCameraMove: (CameraPosition position) {
            if (mounted && !_isDisposed) {
              setState(() => _currentZoom = position.zoom);
            }
            _clearAreaTooltip();
            _scheduleNearbyMaskGeometryUpdate();
          },
          onCameraIdle: () {
            _scheduleNearbyMaskGeometryUpdate();
            _scheduleCaptainBadgeUpdate();
          },
          markers: {
            ..._buildMarkers(
              eventsToShow,
              currentUser,
              hideEventPins: heatmapEnabled,
            ),
            ..._buildHotspotMarkers(
              hotspots,
              captains,
              hideWhenHeatmap: heatmapEnabled,
            ),
          },
          circles: {
            ..._buildHotspotCircles(hotspots, hideWhenHeatmap: heatmapEnabled),
            ..._buildHotspotPreviewCircles(),
          },
          polygons: areaPolygons,
          polylines: _buildPolylines(eventsToShow),
          onTap: _handleMapTap,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          scrollGesturesEnabled: gesturesEnabled,
          zoomGesturesEnabled: gesturesEnabled,
          tiltGesturesEnabled: gesturesEnabled,
          rotateGesturesEnabled: gesturesEnabled,
          heatmaps: !kIsWeb && heatmapEnabled
              ? buildMapHeatmaps(heatmapPoints, zoom: _currentZoom)
              : const {},
        ),
        MapHeatmapOverlay(
          controller: _mapController,
          points: heatmapPoints,
          enabled: kIsWeb && heatmapEnabled,
          zoom: _currentZoom,
        ),
        if (nearbyFilter.enabled &&
            _nearbyMaskCenterPx != null &&
            _nearbyMaskRadiusPx != null)
          Positioned.fill(
            child: NearbyFilterMaskOverlay(
              center: _nearbyMaskCenterPx!,
              radius: _nearbyMaskRadiusPx!,
              dimColor: _mapDarkMode
                  ? Colors.black.withValues(alpha: 0.55)
                  : Colors.black.withValues(alpha: 0.42),
              borderColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.55),
            ),
          ),
        if (_areaTooltipName != null && _areaTooltipOffset != null)
          Positioned(
            left: _areaTooltipOffset!.dx,
            top: _areaTooltipOffset!.dy,
            child: IgnorePointer(
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.inverseSurface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    _areaTooltipName!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (_isCleanupCampaign &&
            areaLayerVisibility.showAreas &&
            !areaLayerVisibility.showNeighborhoods &&
            _captainBadgeLayouts.isNotEmpty)
          ...buildAreaCaptainBadgeWidgets(_captainBadgeLayouts),
        // Map style toggle (light/dark) – top right
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, right: 12),
              child: PointerInterceptor(
                child: Material(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  child: IconButton(
                    icon: Icon(
                      _mapDarkMode ? Icons.light_mode : Icons.dark_mode,
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
            ),
          ),
        ),
        // Mode selector: Cleanup / Report (below map type dropdown, icon row, and filter rows)
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: _modeSelectorTopPadding(context),
                left: 12,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isPlantingCampaign)
                        _MapModeButton(
                          imageAsset: _kAssetPlanting,
                          label: 'Planting',
                          tooltip: 'Add a tree or wildflower planting',
                          isActive: _mode == 'planting',
                          onTap: () => _setMode('planting'),
                        )
                      else ...[
                        _MapModeButton(
                          imageAsset: _kAssetClean,
                          label: 'Cleanup',
                          tooltip: 'Add a cleanup',
                          isActive: _mode == 'cleanup',
                          onTap: () => _setMode('cleanup'),
                        ),
                        const SizedBox(height: 14),
                        _MapModeButton(
                          imageAsset: _kAssetTrash,
                          label: 'Report',
                          tooltip: 'Report trash',
                          isActive: _mode == 'trash_report',
                          onTap: () => _setMode('trash_report'),
                        ),
                        if (canManageHotspots) ...[
                          const SizedBox(height: 14),
                          _MapModeButton(
                            label: 'Hotspot',
                            tooltip: 'Add a targeted cleanup hotspot',
                            isActive: _mode == 'hotspot',
                            onTap: () => _setMode('hotspot'),
                            icon: Icons.local_fire_department,
                            iconColor: const Color(0xFFFF6D00),
                          ),
                        ],
                      ],
                      // _MapModeButton(
                      //   imageAsset: _kAssetDraw,
                      //   label: 'Route',
                      //   tooltip: 'Draw Cleanup Route',
                      //   isActive: _mode == 'route',
                      //   onTap: () => _setMode('route'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Hint text (when a mode is selected)
        if (_mode != null && !_pinDropped && !_confirmingRoute)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Material(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      _mode == 'route'
                          ? 'Tap map to add route points. Add at least 2, then submit.'
                          : _mode == 'planting'
                          ? 'Tap map to add a tree or wildflower planting'
                          : _mode == 'cleanup'
                          ? 'Tap map to add a cleanup location'
                          : _mode == 'hotspot'
                          ? 'Tap map to mark a hotspot ($hotspotRadiusDescription target area)'
                          : 'Tap map to report trash',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Idle instruction (after a few seconds, when no mode selected)
        if (currentUser != null &&
            _showInstruction &&
            _mode == null &&
            !_pinDropped &&
            !_confirmingRoute)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: PointerInterceptor(
                  child: Material(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        'Click a button on the left to get started',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Route: remove last point (when drawing)
        if (_mode == 'route' && _routePoints.isNotEmpty && !_confirmingRoute)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 100),
                child: IconButton.filled(
                  onPressed: _removeLastRoutePoint,
                  icon: const Icon(Icons.remove),
                  tooltip: 'Remove last point',
                ),
              ),
            ),
          ),
        // Zoom buttons (bottom right, above Google Maps controls)
        Positioned(
          bottom: 75,
          right: 10,
          child: PointerInterceptor(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Zoom to my location
                Tooltip(
                  message: 'Zoom to Location',
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: IconButton(
                      icon: const Icon(Icons.location_searching),
                      onPressed: _userLocation != null
                          ? _goToUserLocation
                          : _loadUserLocation,
                    ),
                  ),
                ),
                // Zoom to full extent
                Tooltip(
                  message: 'Zoom to Full Extent',
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: IconButton(
                      icon: const Icon(Icons.fit_screen),
                      onPressed: _zoomToFullExtent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Add-details bar: on mobile anchor at bottom (doesn't cover map or pin);
        // on desktop keep at top.
        if (_pinDropped)
          Align(
            alignment: MediaQuery.sizeOf(context).width < 600
                ? Alignment.bottomCenter
                : Alignment.topCenter,
            child: Padding(
              padding: MediaQuery.sizeOf(context).width < 600
                  ? const EdgeInsets.only(bottom: 72)
                  : const EdgeInsets.only(top: 60),
              child: PinConfirmationBar(
                onSubmit: _onSubmitPin,
                onCancel: _cancel,
              ),
            ),
          ),
        // if (_confirmingRoute && _routePoints.length >= 2)
        //   Padding(
        //     padding: EdgeInsets.only(
        //       top: MediaQuery.of(context).size.width < 600 ? 72 : 0,
        //     ),
        //     child: PinConfirmationBar(
        //       onSubmit: _onSubmitRoute,
        //       onCancel: _cancel,
        //     ),
        //   ),
      ],
    );
  }

  void _setMode(String mode) {
    _resetInactivityTimer();
    // Tapping the same mode again deselects it and removes the hint
    if (_mode == mode) {
      if (mode == 'route' && _routePoints.length >= 2) {
        setState(() => _confirmingRoute = true);
        return;
      }
      setState(() {
        _mode = null;
        _routePoints = [];
        _confirmingRoute = false;
        _updateTempPolyline();
      });
      return;
    }
    setState(() {
      _mode = mode;
      if (mode != 'route') {
        _routePoints = [];
        _confirmingRoute = false;
        _updateTempPolyline();
      }
    });
  }

  Set<Marker> _buildMarkers(
    List<ActionSchema>? events,
    UserSchema? currentUser, {
    bool hideEventPins = false,
  }) {
    final Set<Marker> out = {};
    if (!hideEventPins && events != null) {
      for (final a in events) {
        if (a.latitude == null || a.longitude == null) continue;
        // Filter by actionType first, then check event_data.type
        if (a.actionType != ActionTypeValuesEnum.mapSubmission.value ||
            a.eventData == null) {
          continue;
        }
        final eventType = a.eventData!['type'] as String?;
        final isCleanup = eventType == _kActionTypeCleanup.value;
        final isTrash = eventType == _kActionTypeTrashReport.value;
        if (isTrash && a.resolvedAt != null) continue;
        final isPlanting =
            eventType == _kActionTypeTreePlanting.value ||
            eventType == _kActionTypeWildflowerPlanting.value;
        if (!isCleanup && !isTrash && !isPlanting) continue;
        final isScheduledCleanup = isCleanup && _isScheduledCleanup(a);
        final position =
            _createdActionPositionOverride[a.id] ??
            LatLng(a.latitude!.toDouble(), a.longitude!.toDouble());
        out.add(
          Marker(
            markerId: MarkerId(a.id),
            position: position,
            icon: isPlanting
                ? _iconForPlanting()
                : isCleanup
                ? _iconForCleanup(scheduled: isScheduledCleanup)
                : _iconForTrash(),
            onTap: () => isPlanting
                ? _showPlantingInfoDialog(context, a)
                : _showEventInfoDialog(context, a, isCleanup),
          ),
        );
      }
    }
    if (_userLocation != null &&
        (_currentZoom == null ||
            _currentZoom! >= _kMinZoomToShowUserLocation)) {
      out.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _userLocation!,
          icon: _iconForCurrentLocation(),
          infoWindow: const InfoWindow(title: 'Your location'),
        ),
      );
    }
    out.addAll(_tempMarkers);
    return out;
  }

  Set<Marker> _buildHotspotMarkers(
    List<MapHotspotSchema> hotspots,
    List<AreaCaptainSchema> captains, {
    bool hideWhenHeatmap = false,
  }) {
    if (hideWhenHeatmap) return {};
    final Set<Marker> out = {};
    for (final h in hotspots) {
      if (!h.active) continue;
      out.add(
        Marker(
          markerId: MarkerId('hotspot_${h.id}'),
          position: LatLng(h.latitude.toDouble(), h.longitude.toDouble()),
          icon: _iconForHotspot(),
          zIndexInt: 1000,
          onTap: () => _showHotspotInfoDialog(h, captains),
        ),
      );
    }
    return out;
  }

  Set<Circle> _buildHotspotCircles(
    List<MapHotspotSchema> hotspots, {
    bool hideWhenHeatmap = false,
  }) {
    if (hideWhenHeatmap) return {};
    return hotspots.where((h) => h.active).map((h) {
      return buildHotspotRadiusCircle(
        circleId: CircleId('hotspot_circle_${h.id}'),
        center: LatLng(h.latitude.toDouble(), h.longitude.toDouble()),
      );
    }).toSet();
  }

  Set<Circle> _buildHotspotPreviewCircles() {
    if (_mode != 'hotspot' || _droppedPosition == null) return {};
    return {
      buildHotspotRadiusCircle(
        circleId: const CircleId('hotspot_preview'),
        center: _droppedPosition!,
        fillAlpha: 0.22,
      ),
    };
  }

  List<MapAreaSchema> _captainAllowedAreas() {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser?.id == null) return [];

    var areas = ref.read(userCaptainAreasProvider(widget.campaign.id));
    if (areas.isNotEmpty) return areas;

    return captainAreasForUser(
      userId: currentUser!.id,
      captains:
          ref.read(areaCaptainsForCampaignProvider(widget.campaign.id)).value ??
          const [],
      areas:
          ref.read(mapAreasForCampaignProvider(widget.campaign.id)).value ??
          const [],
    );
  }

  MapAreaSchema? _captainAreaAtPosition(LatLng position) {
    final allowedAreas = _captainAllowedAreas();
    if (allowedAreas.isEmpty) return null;

    final regions = ref.read(mapAreaGeometryProvider).value;
    final features = regions == null
        ? const <MapAreaPolygonFeature>[]
        : _boroughGeometryFeatures(AsyncValue.data(regions));

    return detectCaptainAreaForPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      captainAreas: allowedAreas,
      geometryFeatures: features,
    );
  }

  Set<Polygon> _buildAreaBoundaryPolygons({
    required AsyncValue<List<MapAreaGeometryRegion>>? geometryAsync,
    required List<MapAreaSchema> backendAreas,
    required List<AreaCaptainSchema> captains,
    required String? currentUserId,
    required bool showAreas,
    required bool showNeighborhoods,
    required bool enableAreaTap,
  }) {
    if (!showAreas) return {};
    final regions = geometryAsync?.value;
    if (regions == null || regions.isEmpty) return {};

    final features = <MapAreaPolygonFeature>[];
    for (final region in regions) {
      for (final layer in region.layers) {
        if (layer.id == 'neighborhoods') {
          if (showNeighborhoods) features.addAll(layer.features);
        } else if (!showNeighborhoods) {
          features.addAll(layer.features);
        }
      }
    }
    if (features.isEmpty) return {};

    return buildAreaPolygons(
      features: features,
      backendAreas: backendAreas,
      captains: captains,
      currentUserId: currentUserId,
      onFeatureTap: enableAreaTap
          ? (feature) => _showAreaFeatureTooltip(feature)
          : null,
    );
  }

  void _clearAreaTooltip() {
    _areaTooltipTimer?.cancel();
    if (_areaTooltipName == null && _areaTooltipOffset == null) return;
    if (!mounted) return;
    setState(() {
      _areaTooltipName = null;
      _areaTooltipOffset = null;
    });
  }

  Future<void> _showAreaFeatureTooltip(MapAreaPolygonFeature feature) async {
    if (!mounted) return;
    _resetInactivityTimer();

    final centroid = featureCentroid(feature);
    final controller = _mapController;
    if (centroid == null || controller == null) return;

    _areaTooltipTimer?.cancel();
    final screenPoint = await controller.getScreenCoordinate(centroid);
    if (!mounted) return;

    setState(() {
      _areaTooltipName = feature.name;
      _areaTooltipOffset = computeAreaTooltipTopLeft(
        centroidScreen: Offset(
          screenPoint.x.toDouble(),
          screenPoint.y.toDouble(),
        ),
        name: feature.name,
        featureSlug: feature.slug,
        captainBadges: _captainBadgeLayouts,
      );
    });

    _areaTooltipTimer = Timer(const Duration(seconds: 3), _clearAreaTooltip);
  }

  Future<void> _showHotspotInfoDialog(
    MapHotspotSchema hotspot,
    List<AreaCaptainSchema> captains,
  ) async {
    if (mounted) setState(() => _isInfoDialogOpen = true);
    await showDialog<bool>(
      context: context,
      builder: (c) => HotspotInfoDialog(
        hotspot: hotspot,
        campaignId: widget.campaign.id,
        captains: captains,
      ),
    );
    if (mounted) setState(() => _isInfoDialogOpen = false);
  }

  Future<void> _showEventInfoDialog(
    BuildContext context,
    ActionSchema action,
    bool isCleanup,
  ) async {
    if (action.eventData == null) return;
    if (mounted) setState(() => _isInfoDialogOpen = true);
    final rawEventData = (action as dynamic).eventData;
    dynamic readValue(String key) {
      if (rawEventData is! Map) return null;
      try {
        return rawEventData[key];
      } catch (_) {
        return null;
      }
    }

    try {
      if (isCleanup) {
        await showDialog(
          context: context,
          builder: (c) => CleanupEventInfoDialog(
            action: action,
            eventData: CleanupEventInfoDialog.eventDataFromAction(action),
            campaignId: widget.campaign.id,
          ),
        );
      } else {
        final eventData = TrashReportEventData(
          type:
              EventDataType.fromJson(readValue('type')) ??
              EventDataType.trashReport,
          location: readValue('location')?.toString() ?? '',
          imageUrl: readValue('image_url')?.toString(),
        );
        await showDialog(
          context: context,
          builder: (c) => TrashReportEventInfoDialog(
            action: action,
            eventData: eventData,
            campaignId: widget.campaign.id,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isInfoDialogOpen = false);
    }
  }

  Future<void> _showPlantingInfoDialog(
    BuildContext context,
    ActionSchema action,
  ) async {
    if (action.eventData == null) return;
    if (mounted) setState(() => _isInfoDialogOpen = true);
    await showDialog<void>(
      context: context,
      builder: (_) => PlantingEventInfoDialog(action: action),
    );
    if (mounted) setState(() => _isInfoDialogOpen = false);
  }

  Set<Polyline> _buildPolylines(List<ActionSchema>? events) {
    final Set<Polyline> out = {};
    if (events != null) {
      for (final a in events) {
        // Filter by actionType first, then check event_data.type
        if (a.actionType != ActionTypeValuesEnum.mapSubmission.value ||
            a.eventData == null) {
          continue;
        }
        final eventType = a.eventData!['type'] as String?;
        if (eventType != _kActionTypeCleanupRoute.value) continue;
        final waypoints = _parseWaypoints(a.eventData!);
        if (waypoints.length < 2) continue;
        out.add(
          Polyline(
            polylineId: PolylineId(a.id),
            points: waypoints,
            color: AppColors.lightBlue,
            width: 5,
          ),
        );
      }
    }
    out.addAll(_tempPolylines);
    return out;
  }

  List<LatLng> _parseWaypoints(Map<String, Object> eventData) {
    final raw = eventData['waypoints'];
    if (raw is! List) return [];
    final list = raw
        .map((e) => CleanupWaypoint.fromJson(e))
        .whereType<CleanupWaypoint>()
        .toList();
    return list.map((w) => LatLng(w.lat.toDouble(), w.lng.toDouble())).toList();
  }

  void _handleMapTap(LatLng position) {
    _resetInactivityTimer();
    _clearAreaTooltip();
    if (ref.read(campaignDrawerOpenProvider)) {
      // Don't close the drawer if a full-screen overlay (e.g. photo viewer) was
      // just closed—the same tap can hit the map and would wrongly close the sheet.
      final closedAt = ref.read(photoViewerClosedAtProvider);
      if (closedAt != null &&
          DateTime.now().difference(closedAt) <
              const Duration(milliseconds: 400)) {
        return;
      }
      ref.read(campaignDrawerOpenProvider.notifier).setOpen(false);
      return;
    }
    if (_mode == null) return;
    if (_confirmingRoute) return;
    if (_isAddEventDialogOpen || _isInfoDialogOpen) return;

    if (_mode == 'route') {
      setState(() {
        _routePoints.add(position);
        _updateTempPolyline();
      });
    } else {
      if (_mode == 'hotspot') {
        if (_captainAreaAtPosition(position) == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.warning(
                'Place the hotspot inside a borough you captain',
              ),
            );
          }
          return;
        }
      }
      setState(() {
        _tempMarkers.clear();
        _tempMarkers.add(
          Marker(
            markerId: MarkerId('new_${_mode}_pin'),
            position: position,
            icon: _mode == 'cleanup'
                ? _iconForCleanup()
                : _mode == 'planting'
                ? _iconForPlanting()
                : _mode == 'hotspot'
                ? _iconForHotspot()
                : _iconForTrash(),
          ),
        );
        _pinDropped = true;
        _droppedPosition = position;
        _droppedType = _mode;
      });
    }
  }

  void _updateTempPolyline() {
    if (_routePoints.length < 2) {
      setState(() => _tempPolylines = {});
      return;
    }
    setState(() {
      _tempPolylines = {
        Polyline(
          polylineId: const PolylineId('temp_route'),
          points: _routePoints,
          color: AppColors.lightBlue,
          width: 5,
        ),
      };
    });
  }

  void _removeLastRoutePoint() {
    if (_routePoints.isEmpty) return;
    setState(() {
      _routePoints.removeLast();
      _updateTempPolyline();
    });
  }

  void _cancel() {
    _resetInactivityTimer();
    setState(() {
      _mode = null;
      _pinDropped = false;
      _droppedPosition = null;
      _droppedType = null;
      _confirmingRoute = false;
      _tempMarkers = {};
      _tempPolylines = {};
      _routePoints = [];
    });
  }

  Future<void> _onSubmitPin() async {
    if (_droppedPosition == null || _droppedType == null) return;
    // Capture position once so a tap on the dialog (e.g. Submit) cannot overwrite it.
    final LatLng droppedPosition = _droppedPosition!;

    if (_droppedType == 'cleanup') {
      final currentUser = ref.read(currentUserProvider).value;
      final userName = currentUser?.name;
      if (mounted) setState(() => _isAddEventDialogOpen = true);
      final result = await showDialog<CleanupEventDialogResult>(
        context: context,
        builder: (dialogContext) => CleanupEventDialog(
          routeContext: dialogContext,
          position: droppedPosition,
          initialName: userName,
          organizerUserId: currentUser?.id,
          enableScheduling: currentUser != null,
        ),
      );
      if (mounted) setState(() => _isAddEventDialogOpen = false);
      if (result == null || !mounted) return;
      final created = await _createAction(
        actionType: ActionTypeValuesEnum.mapSubmission.value,
        lat: droppedPosition.latitude,
        lng: droppedPosition.longitude,
        eventData: ActionsService.cleanupEventDataToJson(result.eventData),
        date: DateTime.now(),
      );
      if (created != null && result.photos.isNotEmpty && mounted) {
        try {
          final photosService = PhotosService();
          final actionsService = ActionsService();
          final uploaded = await photosService.uploadSubmissionPhotosBatch(
            created.id,
            result.photos,
          );
          if (uploaded != null && uploaded.isNotEmpty) {
            await actionsService.updateActionPhotos(created.id, uploaded);
          }
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(CustomSnackBar.error('Photo upload failed'));
          }
        }
      }
      if (created != null) {
        _createdActionPositionOverride[created.id] = droppedPosition;
      }
    } else if (_droppedType == 'planting') {
      final userName = ref.read(currentUserProvider).value?.name;
      if (mounted) setState(() => _isAddEventDialogOpen = true);
      final result = await showDialog<PlantingEventDialogResult>(
        context: context,
        builder: (c) => PlantingEventDialog(
          position: droppedPosition,
          initialName: userName,
        ),
      );
      if (mounted) setState(() => _isAddEventDialogOpen = false);
      if (result == null || !mounted) return;
      final created = await _createAction(
        actionType: ActionTypeValuesEnum.mapSubmission.value,
        lat: droppedPosition.latitude,
        lng: droppedPosition.longitude,
        eventData: result.eventData,
        date: DateTime.now(),
      );
      if (created != null && result.photos.isNotEmpty && mounted) {
        try {
          final photosService = PhotosService();
          final actionsService = ActionsService();
          final uploaded = await photosService.uploadSubmissionPhotosBatch(
            created.id,
            result.photos,
          );
          if (uploaded != null && uploaded.isNotEmpty) {
            await actionsService.updateActionPhotos(created.id, uploaded);
          }
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(CustomSnackBar.error('Photo upload failed'));
          }
        }
      }
      if (created != null) {
        _createdActionPositionOverride[created.id] = droppedPosition;
      }
    } else if (_droppedType == 'hotspot') {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser?.id == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.info('Sign in to add hotspots'),
          );
        }
        return;
      }
      final captainsAsync =
          ref.read(areaCaptainsForCampaignProvider(widget.campaign.id));
      if (!canUserManageHotspots(
        userId: currentUser!.id,
        captainsAsync: captainsAsync,
      )) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.warning('You must be an area captain to add hotspots'),
          );
        }
        return;
      }
      var allowedAreas = _captainAllowedAreas();
      if (allowedAreas.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.warning('You must be an area captain to add hotspots'),
          );
        }
        return;
      }
      final detectedArea = _captainAreaAtPosition(droppedPosition);
      if (detectedArea == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.warning(
              'Hotspot must be inside a borough you captain',
            ),
          );
        }
        return;
      }
      final existingHotspots =
          ref.read(mapHotspotsForCampaignProvider(widget.campaign.id)).value ??
          const [];
      final existingHotspot = activeHotspotForArea(
        existingHotspots,
        detectedArea.id,
      );
      if (existingHotspot != null) {
        final boroughName = areaDisplayName(detectedArea);
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => ConfirmationDialog(
            title: 'Replace hotspot?',
            content:
                '$boroughName already has a hotspot (“${existingHotspot.title}”). '
                'Adding this one will replace it on the map.',
            confirmText: 'Replace',
            confirmColor: const Color(0xFFFF6D00),
          ),
        );
        if (confirmed != true || !mounted) return;
      }
      if (mounted) setState(() => _isAddEventDialogOpen = true);
      final result = await showDialog<HotspotEventDialogResult>(
        context: context,
        builder: (c) => HotspotEventDialog(
          position: droppedPosition,
          allowedAreas: [detectedArea],
          suggestedArea: detectedArea,
        ),
      );
      if (mounted) setState(() => _isAddEventDialogOpen = false);
      if (result == null || !mounted) return;
      if (_captainAreaAtPosition(droppedPosition)?.id != result.area.id) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.warning(
              'Hotspot must be inside ${areaDisplayName(result.area)}',
            ),
          );
        }
        return;
      }
      try {
        await ref.read(hotspotServiceProvider).createHotspot(
              campaignId: widget.campaign.id,
              mapAreaId: result.area.id,
              title: result.title,
              description: result.description.isEmpty ? null : result.description,
              latitude: droppedPosition.latitude,
              longitude: droppedPosition.longitude,
              createdBy: currentUser.id!,
            );
        if (mounted) {
          AppConstants.playSuccessCelebration(context);
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.success(
              existingHotspot != null ? 'Hotspot replaced' : 'Hotspot added',
            ),
          );
        }
        ref.invalidate(mapHotspotsForCampaignProvider(widget.campaign.id));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.error('Failed to add hotspot: $e'),
          );
        }
      }
    } else {
      if (mounted) setState(() => _isAddEventDialogOpen = true);
      final result = await showDialog<TrashReportEventDialogResult>(
        context: context,
        builder: (c) => TrashReportEventDialog(position: droppedPosition),
      );
      if (mounted) setState(() => _isAddEventDialogOpen = false);
      if (result == null || !mounted) return;
      final created = await _createAction(
        actionType: ActionTypeValuesEnum.mapSubmission.value,
        lat: droppedPosition.latitude,
        lng: droppedPosition.longitude,
        eventData: ActionsService.trashReportEventDataToJson(result.eventData),
        date: DateTime.now(),
      );
      if (created != null && result.photos.isNotEmpty && mounted) {
        try {
          final photosService = PhotosService();
          final actionsService = ActionsService();
          final uploaded = await photosService.uploadSubmissionPhotosBatch(
            created.id,
            result.photos,
          );
          if (uploaded != null && uploaded.isNotEmpty) {
            await actionsService.updateActionPhotos(created.id, uploaded);
          }
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(CustomSnackBar.error('Photo upload failed'));
          }
        }
      }
      if (created != null) {
        _createdActionPositionOverride[created.id] = droppedPosition;
      }
    }
    _cancel();
    ref.invalidate(mapEventsForCampaignProvider(widget.campaign.id));
    ref.read(activeActionProvider.notifier).refresh();
    ref.invalidate(actionsByLinkedProvider((widget.campaign.id, null)));
    ref.invalidate(actionsByLinkedProvider((widget.campaign.id, 7)));
  }

  // Future<void> _onSubmitRoute() async {
  //   if (_routePoints.length < 2) return;
  //   final userId = ref.read(currentUserProvider).value?.id;
  //   if (userId == null) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(CustomSnackBar.info('Sign in to save routes'));
  //     }
  //     return;
  //   }

  //   final eventData = await showDialog<CleanupRouteEventData>(
  //     context: context,
  //     builder: (c) => RouteEventDialog(waypoints: List.from(_routePoints)),
  //   );
  //   if (eventData == null || !mounted) return;

  //   final first = _routePoints.first;
  //   final eventJson = eventData.toJson();
  //   eventJson['waypoints'] = eventData.waypoints
  //       .map((w) => w.toJson())
  //       .toList();

  //   await _createAction(
  //     actionType: ActionTypeValuesEnum.mapSubmission.value,
  //     lat: first.latitude,
  //     lng: first.longitude,
  //     eventData: eventJson,
  //     date: DateTime.now(),
  //   );
  //   _cancel();
  //   ref.invalidate(mapEventsForCampaignProvider(widget.campaign.id));
  //   ref.read(activeActionProvider.notifier).refresh();
  //   ref.invalidate(actionsByLinkedProvider((widget.campaign.id, null)));
  //   ref.invalidate(actionsByLinkedProvider((widget.campaign.id, 7)));
  // }

  Future<ActionSchema?> _createAction({
    required String actionType,
    required double lat,
    required double lng,
    required Map<String, dynamic> eventData,
    required DateTime date,
  }) async {
    final userId = ref.read(currentUserProvider).value?.id;
    try {
      final created = await ActionsService().createAction(
        ActionCreateSchema(
          actionType: actionType,
          amount: 1,
          linkedId: widget.campaign.id,
          userId: userId,
          date: date,
          latitude: lat,
          longitude: lng,
          eventData: ActionsService.encodeEventDataForApi(eventData),
        ),
      );
      if (mounted) {
        AppConstants.playSuccessCelebration(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.success('Saved'));
      }
      return created;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Failed to save: $e'));
      }
      return null;
    }
  }
}

/// Mode button using Container + DecorationImage so asset images show on web.
class _MapModeButton extends StatelessWidget {
  const _MapModeButton({
    this.imageAsset,
    this.icon,
    this.iconColor,
    required this.label,
    required this.tooltip,
    required this.isActive,
    required this.onTap,
  });

  final String? imageAsset;
  final IconData? icon;
  final Color? iconColor;

  final String label;
  final String tooltip;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return PointerInterceptor(
      child: GestureDetector(
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: imageAsset == null
                      ? theme.colorScheme.surfaceContainerHighest
                      : null,
                  image: imageAsset == null
                      ? null
                      : DecorationImage(
                          image: AssetImage(imageAsset!),
                          fit: BoxFit.cover,
                        ),
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  border: isLight
                      ? (isActive
                            ? Border.all(
                                color: theme.colorScheme.primary,
                                width: 4,
                              )
                            : null)
                      : isActive
                      ? Border.all(color: theme.colorScheme.primary, width: 4)
                      : Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: imageAsset == null
                    ? Icon(
                        icon ?? Icons.add_location_alt,
                        color: iconColor ??
                            (isActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant),
                      )
                    : null,
              ),
              const SizedBox(height: 6),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(6),
                color: isActive
                    ? theme.colorScheme.primaryContainer.withValues(
                        alpha: isLight ? 0.95 : 0.9,
                      )
                    : theme.colorScheme.surface.withValues(
                        alpha: isLight ? 0.92 : 0.88,
                      ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: isActive
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
