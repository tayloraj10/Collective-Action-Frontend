import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/screens/maps/map_styles.dart';
import 'package:collective_action_frontend/theme/category_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
  // true → plain red Google Maps pins (confirmed accurate, no custom drawing)
  static const bool _useDefaultPins = false;
  // true → colored circle + triangular stem (lollipop), anchor at stem tip
  // false → plain colored circle, anchor at circle center
  static const bool _useLollipopPins = false;

  final Completer<GoogleMapController> _ctrl = Completer();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _iconCache = {};
  final Map<String, BitmapDescriptor> _fallbackPinCache = {};
  int _markerBuildToken = 0;
  bool _mapDarkMode = false;
  bool _satelliteMode = false;
  double _currentZoom = 3.5;
  static const double _kAlwaysLabelZoomLevel = 7.0;
  static const double _kLabelAreaHeight = 16.0;
  bool _showLabels = false;
  Map<String, Offset> _labelOffsets = const {};
  static const CameraPosition _kUsaCamera = CameraPosition(
    target: LatLng(39.8283, -98.5795),
    zoom: 3.5,
  );

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Keep network map defaulting to light mode for now.
    _mapDarkMode = false;
  }

  @override
  void didUpdateWidget(NetworkMapView old) {
    super.didUpdateWidget(old);
    if (old.dogs != widget.dogs ||
        old.categories != widget.categories ||
        old.dogSummaries != widget.dogSummaries ||
        old.selectedId != widget.selectedId) {
      _buildMarkers();
    }
  }

  Future<void> _showSelectedInfoWindow() async {
    final selectedId = widget.selectedId;
    if (selectedId == null || selectedId.isEmpty) return;
    final c = _mapController;
    if (c == null) return;
    try {
      await c.showMarkerInfoWindow(MarkerId(selectedId));
    } catch (_) {}
  }

  Future<void> _recomputeOverlayLabels() async {
    if (!_showLabels) {
      if (_labelOffsets.isNotEmpty && mounted) {
        setState(() => _labelOffsets = const {});
      }
      return;
    }
    final c = _mapController;
    if (c == null || !mounted) return;
    final screenSize = MediaQuery.sizeOf(context);
    final next = <String, Offset>{};
    for (final d in widget.dogs) {
      final lat = d.latitude?.toDouble();
      final lng = d.longitude?.toDouble();
      if (lat == null || lng == null) continue;
      final id = d.id ?? d.name;
      try {
        final sc = await c.getScreenCoordinate(LatLng(lat, lng));
        // google_maps_flutter_web already returns logical pixels for overlay alignment.
        final dx = sc.x.toDouble() + 12;
        final dy = sc.y.toDouble() - 9;
        if (dx < -140 ||
            dy < -32 ||
            dx > screenSize.width + 140 ||
            dy > screenSize.height + 32) {
          continue;
        }
        next[id] = Offset(dx, dy);
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() => _labelOffsets = next);
  }

  List<Widget> _buildOverlayLabels() {
    if (!_showLabels || _labelOffsets.isEmpty) return const [];
    final byId = {for (final d in widget.dogs) (d.id ?? d.name): d};
    final textColor = (_satelliteMode || _mapDarkMode)
        ? Colors.white
        : const Color(0xFF0F172A);
    final bgColor = (_satelliteMode || _mapDarkMode)
        ? Colors.black.withAlpha(135)
        : Colors.white.withAlpha(215);

    return _labelOffsets.entries
        .map((entry) {
          final d = byId[entry.key];
          if (d == null) return const SizedBox.shrink();
          return Positioned(
            left: entry.value.dx,
            top: entry.value.dy,
            child: IgnorePointer(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 160),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  d.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        })
        .toList(growable: false);
  }

  Color _colorForCategoryId(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      return CategoryColors.resolve(categoryName: 'environment');
    }
    final idx = widget.categories.indexWhere((c) => c.id == categoryId);
    if (idx < 0) {
      return CategoryColors.resolve(
        stableKey: categoryId,
        categoryName: 'environment',
      );
    }
    final cat = widget.categories[idx];
    return CategoryColors.resolve(categoryName: cat.name, stableKey: cat.id);
  }

  static String _normalizeImageUrl(String? raw) {
    if (raw == null || raw.isEmpty || raw.startsWith('data:')) return '';
    var u = raw.trim().replaceAll('&amp;', '&');
    if (!u.startsWith('http://') && !u.startsWith('https://')) {
      u = u.startsWith('//') ? 'https:$u' : 'https://$u';
    }
    if (u.startsWith('http://')) u = u.replaceFirst('http://', 'https://');
    return u;
  }

  TextPainter _buildLabelPainter(String label) {
    final textColor = (_satelliteMode || _mapDarkMode)
        ? Colors.white
        : const Color(0xFF0F172A);
    return TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: textColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      maxLines: 1,
      ellipsis: '…',
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 140);
  }

  Future<ui.Image?> _decodeImage(
    Uint8List bytes, {
    required int targetWidth,
  }) async {
    try {
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: targetWidth,
      );
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (_) {
      return null;
    }
  }

  Future<BitmapDescriptor> _fallbackCategoryPin({
    required Color color,
    required bool selected,
    required bool showLabel,
    required String label,
  }) async {
    final cacheKey =
        '${_useLollipopPins ? 'lollipop' : 'circle'}|${selected ? 'sel' : 'norm'}|$showLabel|$label|${color.toARGB32()}|$_mapDarkMode|$_satelliteMode';
    final cached = _fallbackPinCache[cacheKey];
    if (cached != null) return cached;

    final pinColor = selected
        ? HSLColor.fromColor(color).withLightness(0.44).toColor()
        : color;

    final double canvasW, canvasH;
    final ui.PictureRecorder recorder;
    final Canvas canvas;

    if (_useLollipopPins) {
      final headRadius = selected ? 14.0 : 11.0;
      final stemH = selected ? 10.0 : 8.0;
      final stemBaseW = selected ? 8.0 : 6.0;
      const pad = 4.0;
      canvasW = headRadius * 2 + pad * 2;
      final headCY = pad + headRadius;
      canvasH = headCY + headRadius + stemH;
      final headCenter = Offset(canvasW / 2, headCY);
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);

      canvas.drawCircle(
        headCenter.translate(0, 2),
        headRadius + 1,
        Paint()
          ..color = pinColor.withAlpha(80)
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6),
      );
      final cx = canvasW / 2;
      final stemTopY = headCY + headRadius - 2;
      canvas.drawPath(
        Path()
          ..moveTo(cx - stemBaseW / 2, stemTopY)
          ..lineTo(cx + stemBaseW / 2, stemTopY)
          ..lineTo(cx, canvasH)
          ..close(),
        Paint()..color = pinColor,
      );
      canvas.drawCircle(headCenter, headRadius, Paint()..color = pinColor);
      canvas.drawCircle(
        headCenter,
        headRadius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 2.6 : 2.0,
      );
    } else {
      final size = selected ? 30.0 : 24.0;
      final radius = selected ? 13.0 : 10.0;
      final labelPainter = showLabel ? _buildLabelPainter(label) : null;
      canvasW = showLabel
          ? (size > labelPainter!.width + 10 ? size : labelPainter.width + 10)
          : size;
      canvasH = showLabel ? size + _kLabelAreaHeight : size;
      final center = Offset(canvasW / 2, size / 2);
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);

      canvas.drawCircle(center, radius, Paint()..color = pinColor);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 2.6 : 2.0,
      );

      if (showLabel && labelPainter != null) {
        final labelBg = (_satelliteMode || _mapDarkMode)
            ? Colors.black.withAlpha(130)
            : Colors.white.withAlpha(210);
        final bgRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            (canvasW - labelPainter.width) / 2 - 4,
            size + 1,
            labelPainter.width + 8,
            labelPainter.height + 2,
          ),
          const Radius.circular(5),
        );
        canvas.drawRRect(bgRect, Paint()..color = labelBg);
        labelPainter.paint(
          canvas,
          Offset((canvasW - labelPainter.width) / 2, size + 2),
        );
      }
    }

    final image = await recorder.endRecording().toImage(
      canvasW.round(),
      canvasH.round(),
    );
    final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = pngBytes?.buffer.asUint8List() ?? Uint8List(0);
    final descriptor = BitmapDescriptor.fromBytes(
      bytes,
      size: Size(canvasW, canvasH),
    );
    _fallbackPinCache[cacheKey] = descriptor;
    return descriptor;
  }

  Future<BitmapDescriptor?> _dogImageIcon(
    String? rawUrl, {
    required bool selected,
    required bool showLabel,
    required String label,
  }) async {
    final normalized = _normalizeImageUrl(rawUrl);
    if (normalized.isEmpty) return null;
    final proxiedUrl =
        '${AppConstants.backendBaseUrl}/image-proxy/?url=${Uri.encodeComponent(normalized)}';
    final cacheKey =
        '${selected ? 'selected' : 'normal'}|$showLabel|$label|$_mapDarkMode|$_satelliteMode|$proxiedUrl';
    final cached = _iconCache[cacheKey];
    if (cached != null) return cached;

    try {
      final byteData = await NetworkAssetBundle(
        Uri.parse(proxiedUrl),
      ).load(proxiedUrl);
      final srcImage = await _decodeImage(
        byteData.buffer.asUint8List(),
        targetWidth: selected ? 50 : 44,
      );
      if (srcImage == null) return null;

      final double canvasW, canvasH;
      final Offset headCenter;
      final double headRadius;

      if (_useLollipopPins) {
        headRadius = selected ? 14.0 : 11.0;
        final stemH = selected ? 10.0 : 8.0;
        final stemBaseW = selected ? 8.0 : 6.0;
        const pad = 4.0;
        canvasW = headRadius * 2 + pad * 2;
        final headCY = pad + headRadius;
        canvasH = headCY + headRadius + stemH;
        headCenter = Offset(canvasW / 2, headCY);

        final recorder2 = ui.PictureRecorder();
        final canvas2 = Canvas(recorder2);
        canvas2.drawCircle(
          headCenter.translate(0, 2),
          headRadius + 1,
          Paint()
            ..color = Colors.black.withAlpha(60)
            ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6),
        );
        final cx = canvasW / 2;
        final stemTopY = headCY + headRadius - 2;
        canvas2.drawPath(
          Path()
            ..moveTo(cx - stemBaseW / 2, stemTopY)
            ..lineTo(cx + stemBaseW / 2, stemTopY)
            ..lineTo(cx, canvasH)
            ..close(),
          Paint()..color = Colors.white.withAlpha(230),
        );
        final oval2 = Rect.fromCircle(center: headCenter, radius: headRadius);
        canvas2.save();
        canvas2.clipPath(Path()..addOval(oval2));
        paintImage(
          canvas: canvas2,
          rect: oval2,
          image: srcImage,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        );
        canvas2.restore();
        canvas2.drawCircle(
          headCenter,
          headRadius,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = selected ? 2.6 : 2.0,
        );
        final outImage2 = await recorder2.endRecording().toImage(
          canvasW.round(),
          canvasH.round(),
        );
        final outBytes2 = await outImage2.toByteData(
          format: ui.ImageByteFormat.png,
        );
        final png2 = outBytes2?.buffer.asUint8List();
        if (png2 == null || png2.isEmpty) return null;
        final descriptor2 = BitmapDescriptor.fromBytes(
          png2,
          size: Size(canvasW, canvasH),
        );
        _iconCache[cacheKey] = descriptor2;
        return descriptor2;
      } else {
        final size = selected ? 30.0 : 24.0;
        final labelPainter = showLabel ? _buildLabelPainter(label) : null;
        headRadius = selected ? 13.0 : 10.0;
        canvasW = showLabel
            ? (size > labelPainter!.width + 10 ? size : labelPainter.width + 10)
            : size;
        canvasH = showLabel ? size + _kLabelAreaHeight : size;
        headCenter = Offset(canvasW / 2, size / 2);
      }

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final oval = Rect.fromCircle(center: headCenter, radius: headRadius);
      canvas.save();
      canvas.clipPath(Path()..addOval(oval));
      paintImage(
        canvas: canvas,
        rect: oval,
        image: srcImage,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
      canvas.restore();

      canvas.drawCircle(
        headCenter,
        headRadius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 2.6 : 2.0,
      );

      if (!_useLollipopPins && showLabel) {
        final size = selected ? 30.0 : 24.0;
        final labelPainter = _buildLabelPainter(label);
        final labelBg = (_satelliteMode || _mapDarkMode)
            ? Colors.black.withAlpha(130)
            : Colors.white.withAlpha(210);
        final bgRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            (canvasW - labelPainter.width) / 2 - 4,
            size + 1,
            labelPainter.width + 8,
            labelPainter.height + 2,
          ),
          const Radius.circular(5),
        );
        canvas.drawRRect(bgRect, Paint()..color = labelBg);
        labelPainter.paint(
          canvas,
          Offset((canvasW - labelPainter.width) / 2, size + 2),
        );
      }

      final outImage = await recorder.endRecording().toImage(
        canvasW.round(),
        canvasH.round(),
      );
      final outBytes = await outImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final png = outBytes?.buffer.asUint8List();
      if (png == null || png.isEmpty) return null;

      final descriptor = BitmapDescriptor.fromBytes(
        png,
        size: Size(canvasW, canvasH),
      );
      _iconCache[cacheKey] = descriptor;
      return descriptor;
    } catch (_) {
      return null;
    }
  }

  Future<void> _buildMarkers() async {
    final buildToken = ++_markerBuildToken;
    final catById = {for (final c in widget.categories) c.id: c};
    final markers = <Marker>{};
    for (final d in widget.dogs) {
      final lat = d.latitude?.toDouble();
      final lng = d.longitude?.toDouble();
      if (lat == null || lng == null) continue;

      final id = d.id ?? d.name;
      final summary = widget.dogSummaries[id];
      final totalConns = summary?.totalCount ?? 0;
      final isSelected = widget.selectedId == id;
      final categoryName = d.categoryIds.isNotEmpty
          ? (catById[d.categoryIds.first]?.name ?? 'Uncategorized')
          : 'Uncategorized';

      // Match the same color logic used by category chips.
      final categoryColor = _colorForCategoryId(d.categoryIds.firstOrNull);

      BitmapDescriptor icon;
      Offset anchor;
      if (_useDefaultPins) {
        icon = BitmapDescriptor.defaultMarker;
        anchor = const Offset(0.5, 1.0);
      } else {
        final dogImageIcon = await _dogImageIcon(
          d.imageUrl,
          selected: isSelected,
          showLabel: false,
          label: d.name,
        );
        final fallbackPin = await _fallbackCategoryPin(
          color: categoryColor,
          selected: isSelected,
          showLabel: false,
          label: d.name,
        );
        icon = dogImageIcon ?? fallbackPin;
        if (_useLollipopPins) {
          anchor = const Offset(0.5, 1.0);
        } else {
          anchor = const Offset(0.5, 0.5);
        }
      }
      if (buildToken != _markerBuildToken) return;

      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: LatLng(lat, lng),
          icon: icon,
          anchor: anchor,
          infoWindow: InfoWindow(
            title: d.name,
            snippet: totalConns > 0
                ? '$categoryName • $totalConns connection${totalConns == 1 ? '' : 's'}'
                : '$categoryName • ${d.location?.city ?? ''}',
            onTap: () => widget.onSelect(id, 'directory_of_good'),
          ),
          onTap: () => widget.onSelect(id, 'directory_of_good'),
          zIndexInt: isSelected ? 2 : (1 + (totalConns * 0.1).round()),
        ),
      );
    }

    if (!mounted || buildToken != _markerBuildToken) return;
    setState(() => _markers = markers);
    await _showSelectedInfoWindow();
    await _recomputeOverlayLabels();
  }

  Future<void> _zoomToUSAExtent() async {
    final c = _mapController;
    if (c == null) return;
    await c.animateCamera(CameraUpdate.newCameraPosition(_kUsaCamera));
  }

  Future<void> _zoomToFullExtent() async {
    final c = _mapController;
    if (c == null) return;
    final geocoded = widget.dogs
        .where((d) => d.latitude != null && d.longitude != null)
        .toList();
    if (geocoded.isEmpty) {
      await _zoomToUSAExtent();
      return;
    }
    if (geocoded.length == 1) {
      final one = geocoded.first;
      await c.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(one.latitude!.toDouble(), one.longitude!.toDouble()),
          8,
        ),
      );
      return;
    }
    var minLat = geocoded.first.latitude!.toDouble();
    var maxLat = minLat;
    var minLng = geocoded.first.longitude!.toDouble();
    var maxLng = minLng;
    for (final d in geocoded.skip(1)) {
      final lat = d.latitude!.toDouble();
      final lng = d.longitude!.toDouble();
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }
    await c.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80,
      ),
    );
  }

  Future<void> _zoomToMyLocation() async {
    final c = _mapController;
    if (c == null) return;
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    await c.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    final geocodedCount = widget.dogs.where((d) => d.latitude != null).length;

    if (geocodedCount == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
            ),
            const SizedBox(height: 16),
            Text(
              'No geocoded entries yet.\nRun the sheet sync to populate coordinates.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kUsaCamera,
          style: _mapDarkMode ? kDarkMapStyle : null,
          mapType: _satelliteMode ? MapType.satellite : MapType.normal,
          markers: _markers,
          onMapCreated: (c) {
            _mapController = c;
            if (!_ctrl.isCompleted) _ctrl.complete(c);
            // ignore: deprecated_member_use
            c.setMapStyle(_mapDarkMode ? kDarkMapStyle : null);
            c.moveCamera(CameraUpdate.newCameraPosition(_kUsaCamera));
            _showSelectedInfoWindow();
            _recomputeOverlayLabels();
          },
          onCameraMove: (position) {
            final nextShowLabels = position.zoom >= _kAlwaysLabelZoomLevel;
            if (nextShowLabels != _showLabels) {
              setState(() {
                _currentZoom = position.zoom;
                _showLabels = nextShowLabels;
              });
              _recomputeOverlayLabels();
              return;
            }
            setState(() => _currentZoom = position.zoom);
          },
          onCameraIdle: _recomputeOverlayLabels,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: PointerInterceptor(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MapControlButton(
                      icon: Icons.fit_screen,
                      tooltip: 'Zoom to data extent',
                      onTap: () => _zoomToFullExtent(),
                    ),
                    const SizedBox(height: 8),
                    _MapControlButton(
                      icon: Icons.flag,
                      tooltip: 'Zoom to USA',
                      onTap: () => _zoomToUSAExtent(),
                    ),
                    const SizedBox(height: 8),
                    _MapControlButton(
                      icon: Icons.my_location,
                      tooltip: 'Zoom to your location',
                      onTap: () => _zoomToMyLocation(),
                    ),
                    const SizedBox(height: 8),
                    _MapControlButton(
                      icon: _mapDarkMode ? Icons.light_mode : Icons.dark_mode,
                      tooltip: _mapDarkMode
                          ? 'Map style: dark'
                          : 'Map style: light',
                      onTap: () {
                        setState(() => _mapDarkMode = !_mapDarkMode);
                        // ignore: deprecated_member_use
                        _mapController?.setMapStyle(
                          _mapDarkMode ? kDarkMapStyle : null,
                        );
                        _recomputeOverlayLabels();
                      },
                    ),
                    const SizedBox(height: 8),
                    _MapControlButton(
                      icon: _satelliteMode ? Icons.map : Icons.satellite_alt,
                      tooltip: _satelliteMode ? 'Satellite view' : 'Map view',
                      onTap: () {
                        setState(() => _satelliteMode = !_satelliteMode);
                        _recomputeOverlayLabels();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ..._buildOverlayLabels(),
        // Pin count overlay
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withAlpha(160)
                  : Colors.white.withAlpha(220),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withAlpha(120),
              ),
            ),
            child: Text(
              '$geocodedCount locations mapped · zoom ${_currentZoom.toStringAsFixed(1)}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withAlpha(150)
          : Colors.white.withAlpha(230),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(message: tooltip, child: Icon(icon, size: 18)),
        ),
      ),
    );
  }
}
