import 'dart:async';

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/map_events_provider.dart';
import 'package:collective_action_frontend/providers/map_provider.dart';
import 'package:collective_action_frontend/providers/map_zoom_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_event_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_event_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/pin_confirmation_bar.dart';
import 'package:collective_action_frontend/screens/maps/components/planting_event_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/planting_event_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/trash_report_event_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/trash_report_event_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/map_styles.dart';
import 'package:collective_action_frontend/services/actions_service.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
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
  BitmapDescriptor? _trashMarkerIcon;
  BitmapDescriptor? _plantingMarkerIcon;
  BitmapDescriptor? _currentLocationMarkerIcon;

  GoogleMapController? _mapController;
  LatLng? _userLocation;
  double? _currentZoom;
  bool _didAutoZoomToData = false;

  /// User preference for map style only (independent of app theme).
  bool _mapDarkMode = false;

  Timer? _inactivityTimer;
  bool _showInstruction = false;
  final bool _isDisposed = false;

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
    _mapController = null;
    super.dispose();
  }

  Future<void> _loadMarkerIcons() async {
    if (!mounted) return;
    const config = ImageConfiguration(size: Size(40, 40));
    final clean = await BitmapDescriptor.asset(config, _kAssetClean);
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
    if (mounted) {
      setState(() {
        _cleanupMarkerIcon = clean;
        _trashMarkerIcon = trash;
        _plantingMarkerIcon = planting;
        _currentLocationMarkerIcon = currentLocation;
      });
    }
  }

  BitmapDescriptor _iconForCleanup() =>
      _cleanupMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor _iconForTrash() =>
      _trashMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor _iconForPlanting() =>
      _plantingMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor _iconForCurrentLocation() =>
      _currentLocationMarkerIcon ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  bool get _isPlantingCampaign =>
      widget.campaign.mapCampaignType == MapCampaignTypeEnum.plantingMap.value;

  /// Fetches current position, updates state, shows on map, and zooms to it.
  Future<bool> _loadUserLocation() async {
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
        await _goToUserLocation();
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

  /// Zooms to show all markers and polylines on the map.
  Future<bool> _zoomToFullExtent() async {
    if (!mounted || _mapController == null) return false;

    final eventsAsync = ref.read(
      mapEventsForCampaignProvider(widget.campaign.id),
    );
    final currentUser = ref.read(currentUserProvider).value;
    final filterMySubmissionsOnly = ref.read(
      mapFilterMySubmissionsOnlyProvider,
    );
    final rawEvents = eventsAsync.value;
    final eventsToShow = rawEvents == null
        ? null
        : (filterMySubmissionsOnly && currentUser != null)
        ? rawEvents.where((a) => a.userId == currentUser.id).toList()
        : rawEvents;
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
    final eventsAsync = ref.watch(
      mapEventsForCampaignProvider(widget.campaign.id),
    );
    final currentUser = ref.watch(currentUserProvider).value;
    final filterMySubmissionsOnly = ref.watch(
      mapFilterMySubmissionsOnlyProvider,
    );
    final rawEvents = eventsAsync.value;
    final eventsToShow = rawEvents == null
        ? null
        : (filterMySubmissionsOnly && currentUser != null)
        ? rawEvents.where((a) => a.userId == currentUser.id).toList()
        : rawEvents;
    final campaignDrawerOpen = ref.watch(campaignDrawerOpenProvider);
    final gesturesEnabled =
        !_isAddEventDialogOpen && !_isInfoDialogOpen && !campaignDrawerOpen;

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
          },
          onCameraMove: (CameraPosition position) {
            if (mounted && !_isDisposed) {
              setState(() => _currentZoom = position.zoom);
            }
          },
          markers: _buildMarkers(eventsToShow, currentUser),
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
        ),
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
        // Mode selector: Cleanup / Report (below map type dropdown, icon row, and My pins only row)
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 150, left: 12),
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
    UserSchema? currentUser,
  ) {
    final Set<Marker> out = {};
    if (events != null) {
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
        final isPlanting =
            eventType == _kActionTypeTreePlanting.value ||
            eventType == _kActionTypeWildflowerPlanting.value;
        if (!isCleanup && !isTrash && !isPlanting) continue;
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
                ? _iconForCleanup()
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
        final eventData = CleanupEventData(
          type: EventDataType.fromJson(readValue('type')) ?? EventDataType.cleanup,
          name: readValue('name')?.toString() ?? '',
          location: readValue('location')?.toString() ?? '',
          smallBags: readValue('small_bags') is int
              ? readValue('small_bags') as int
              : int.tryParse('${readValue('small_bags') ?? ''}'),
          largeBags: readValue('large_bags') is int
              ? readValue('large_bags') as int
              : int.tryParse('${readValue('large_bags') ?? ''}'),
          pounds: readValue('pounds') != null
              ? num.tryParse('${readValue('pounds')}')
              : null,
          imageUrl: readValue('image_url')?.toString(),
        );
        await showDialog(
          context: context,
          builder: (c) => CleanupEventInfoDialog(
            action: action,
            eventData: eventData,
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
      final userName = ref.read(currentUserProvider).value?.name;
      if (mounted) setState(() => _isAddEventDialogOpen = true);
      final result = await showDialog<CleanupEventDialogResult>(
        context: context,
        builder: (c) => CleanupEventDialog(
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
        eventData: result.eventData.toJson(),
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
        eventData: result.eventData.toJson(),
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

  /// Removes null values from event_data. Date is only at action level, not in event_data.
  static Map<String, Object> _eventDataWithoutNulls(Map<String, dynamic> data) {
    final result = <String, Object>{};
    for (final e in data.entries) {
      if (e.value != null) result[e.key] = e.value as Object;
    }
    return result;
  }

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
          eventData: _eventDataWithoutNulls(eventData),
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
    required this.label,
    required this.tooltip,
    required this.isActive,
    required this.onTap,
  });

  final String? imageAsset;

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
                        Icons.add_location_alt,
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      )
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : null,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
