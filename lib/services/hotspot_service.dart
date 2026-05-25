import 'dart:ui' as ui;

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Visual target radius for cleanup hotspots on the map.
const kHotspotRadiusFeet = 500;

/// Google Maps circles use meters; derived from [kHotspotRadiusFeet].
const kHotspotRadiusMeters = kHotspotRadiusFeet * 0.3048;

/// About 500 ft — roughly 1–2 city blocks.
String get hotspotRadiusDescription =>
    '$kHotspotRadiusFeet ft (~${kHotspotRadiusMeters.round()} m)';

Circle buildHotspotRadiusCircle({
  required CircleId circleId,
  required LatLng center,
  double radiusMeters = kHotspotRadiusMeters,
  double fillAlpha = 0.18,
  int zIndex = 999,
}) {
  return Circle(
    circleId: circleId,
    center: center,
    radius: radiusMeters,
    fillColor: Color(0xFFFF6D00).withValues(alpha: fillAlpha),
    strokeColor: const Color(0xFFFF6D00),
    strokeWidth: 3,
    zIndex: zIndex,
  );
}

class HotspotService {
  late final MapHotspotsApi _api;

  HotspotService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = MapHotspotsApi(client);
  }

  Future<List<MapAreaSchema>> fetchAreas(String campaignId) async {
    try {
      return await _api
              .listAreasMapHotspotsCampaignCampaignIdAreasGet(campaignId) ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch map areas: $e');
    }
  }

  Future<List<MapHotspotSchema>> fetchHotspots(
    String campaignId, {
    bool includeInactive = false,
  }) async {
    try {
      return await _api.listHotspotsMapHotspotsCampaignCampaignIdGet(
            campaignId,
            includeInactive: includeInactive,
          ) ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch hotspots: $e');
    }
  }

  Future<List<AreaCaptainSchema>> fetchAreaCaptains(String campaignId) async {
    try {
      return await _api
              .listAreaCaptainsMapHotspotsCampaignCampaignIdAreaCaptainsGet(
                campaignId,
              ) ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch area captains: $e');
    }
  }

  Future<MapHotspotSchema> createHotspot({
    required String campaignId,
    required String mapAreaId,
    required String title,
    String? description,
    required double latitude,
    required double longitude,
    required String createdBy,
  }) async {
    try {
      final result = await _api.createHotspotMapHotspotsPost(
        MapHotspotCreateSchema(
          mapCampaignId: campaignId,
          mapAreaId: mapAreaId,
          title: title,
          description: description,
          latitude: latitude,
          longitude: longitude,
          createdBy: createdBy,
        ),
      );
      if (result == null) {
        throw Exception('Create hotspot returned no data');
      }
      return result;
    } catch (e) {
      throw Exception('Failed to create hotspot: $e');
    }
  }

  Future<MapHotspotSchema> updateHotspot({
    required String hotspotId,
    required String actingUserId,
    String? title,
    String? description,
    bool? active,
  }) async {
    try {
      final result = await _api.updateHotspotMapHotspotsHotspotIdPatch(
        hotspotId,
        MapHotspotUpdateSchema(
          actingUserId: actingUserId,
          title: title,
          description: description,
          active: active,
        ),
      );
      if (result == null) {
        throw Exception('Update hotspot returned no data');
      }
      return result;
    } catch (e) {
      throw Exception('Failed to update hotspot: $e');
    }
  }

  Future<void> deleteHotspot({
    required String hotspotId,
    required String actingUserId,
  }) async {
    try {
      await _api.deleteHotspotMapHotspotsHotspotIdDelete(
        hotspotId,
        actingUserId,
      );
    } catch (e) {
      throw Exception('Failed to delete hotspot: $e');
    }
  }

  Future<AreaCaptainSchema> assignCaptain({
    required String mapAreaId,
    required String captainUserId,
    required String actingUserId,
  }) async {
    try {
      final result =
          await _api.assignAreaCaptainMapHotspotsAreaCaptainsAssignPost(
        AreaCaptainAssignSchema(
          mapAreaId: mapAreaId,
          captainUserId: captainUserId,
          actingUserId: actingUserId,
        ),
      );
      if (result == null) {
        throw Exception('Assign captain returned no data');
      }
      return result;
    } catch (e) {
      throw Exception('Failed to assign captain: $e');
    }
  }

  Future<void> removeCaptain({
    required String assignmentId,
    required String actingUserId,
  }) async {
    try {
      await _api.removeAreaCaptainMapHotspotsAreaCaptainsAssignmentIdDelete(
        assignmentId,
        actingUserId,
      );
    } catch (e) {
      throw Exception('Failed to remove captain: $e');
    }
  }
}

/// Builds a large, high-visibility hotspot marker (orange burst with white target).
Future<BitmapDescriptor> createHotspotMarkerIcon() async {
  const size = 72.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final center = Offset(size / 2, size / 2);

  final glowPaint = Paint()
    ..color = const Color(0xFFFF6D00).withValues(alpha: 0.35)
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, size / 2 - 2, glowPaint);

  final mainPaint = Paint()
    ..color = const Color(0xFFFF6D00)
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, size / 2 - 10, mainPaint);

  final borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  canvas.drawCircle(center, size / 2 - 10, borderPaint);

  final crossPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(
    Offset(center.dx, center.dy - 14),
    Offset(center.dx, center.dy + 14),
    crossPaint,
  );
  canvas.drawLine(
    Offset(center.dx - 14, center.dy),
    Offset(center.dx + 14, center.dy),
    crossPaint,
  );
  canvas.drawCircle(center, 6, crossPaint);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
}
