import 'dart:convert';
import 'dart:ui' as ui;

import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/models/map_area.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

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
  HotspotService({String? baseUrl}) : _baseUrl = baseUrl ?? AppConstants.backendBaseUrl;

  final String _baseUrl;

  Future<List<MapAreaModel>> fetchAreas(String campaignId) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/campaign/$campaignId/areas');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch map areas: ${response.body}');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => MapAreaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MapHotspotModel>> fetchHotspots(
    String campaignId, {
    bool includeInactive = false,
  }) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/campaign/$campaignId').replace(
      queryParameters: {
        if (includeInactive) 'include_inactive': 'true',
      },
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch hotspots: ${response.body}');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => MapHotspotModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AreaCaptainModel>> fetchAreaCaptains(String campaignId) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/campaign/$campaignId/area-captains');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch area captains: ${response.body}');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => AreaCaptainModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MapHotspotModel> createHotspot({
    required String campaignId,
    required String mapAreaId,
    required String title,
    String? description,
    required double latitude,
    required double longitude,
    required String createdBy,
  }) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/');
    final body = jsonEncode({
      'map_campaign_id': campaignId,
      'map_area_id': mapAreaId,
      'title': title,
      if (description != null && description.isNotEmpty) 'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'created_by': createdBy,
    });
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create hotspot: ${response.body}');
    }
    return MapHotspotModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<MapHotspotModel> updateHotspot({
    required String hotspotId,
    required String actingUserId,
    String? title,
    String? description,
    bool? active,
  }) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/$hotspotId');
    final body = <String, dynamic>{
      'acting_user_id': actingUserId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (active != null) 'active': active,
    };
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update hotspot: ${response.body}');
    }
    return MapHotspotModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> deleteHotspot({
    required String hotspotId,
    required String actingUserId,
  }) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/$hotspotId').replace(
      queryParameters: {'acting_user_id': actingUserId},
    );
    final response = await http.delete(uri);
    if (response.statusCode != 204) {
      throw Exception('Failed to delete hotspot: ${response.body}');
    }
  }

  Future<AreaCaptainModel> assignCaptain({
    required String mapAreaId,
    required String captainUserId,
    required String actingUserId,
  }) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/area-captains/assign');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'map_area_id': mapAreaId,
        'captain_user_id': captainUserId,
        'acting_user_id': actingUserId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to assign captain: ${response.body}');
    }
    return AreaCaptainModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> removeCaptain({
    required String assignmentId,
    required String actingUserId,
  }) async {
    final uri = Uri.parse('$_baseUrl/map-hotspots/area-captains/$assignmentId').replace(
      queryParameters: {'acting_user_id': actingUserId},
    );
    final response = await http.delete(uri);
    if (response.statusCode != 204) {
      throw Exception('Failed to remove captain: ${response.body}');
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
