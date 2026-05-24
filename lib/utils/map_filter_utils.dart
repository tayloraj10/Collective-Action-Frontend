import 'dart:math' as math;

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Default radius when filtering map pins to the user's vicinity.
const double kMapNearbyFilterDefaultRadiusMiles = 0.5;

/// Preset radius options (miles) for the nearby map filter.
const List<double> kMapNearbyFilterRadiusOptions = [0.5, 1, 2, 5, 10];

const double _metersPerMile = 1609.344;

/// Dropdown label for a nearby-filter radius in miles.
String formatMapNearbyRadiusLabel(double miles) {
  if (miles == 0.5) return 'Within .5 mile';
  if (miles == 1) return 'Within 1 mile';
  final value = miles == miles.roundToDouble()
      ? miles.toInt().toString()
      : miles.toString();
  return 'Within $value miles';
}

/// Tooltip when the nearby filter is off.
String mapNearbyFilterOffTooltip(double radiusMiles) {
  return 'Show pins within ${_radiusPhrase(radiusMiles)} of your location';
}

String _radiusPhrase(double miles) {
  if (miles == 0.5) return '.5 mile';
  if (miles == 1) return '1 mile';
  final value = miles == miles.roundToDouble()
      ? miles.toInt().toString()
      : miles.toString();
  return '$value miles';
}

/// Polygon points approximating a circle (for mask holes and borders).
List<LatLng> circlePolygonPoints(
  LatLng center,
  double radiusMeters, {
  int segments = 64,
}) {
  final points = <LatLng>[];
  for (var i = 0; i < segments; i++) {
    final bearing = (360.0 / segments) * i;
    points.add(offsetLatLngMeters(center, radiusMeters, bearing));
  }
  return points;
}

/// Moves [origin] by [distanceMeters] along [bearingDegrees] (0 = north).
LatLng offsetLatLngMeters(
  LatLng origin,
  double distanceMeters,
  double bearingDegrees,
) {
  return _offsetLatLng(origin, distanceMeters, bearingDegrees);
}

LatLng _offsetLatLng(LatLng origin, double distanceMeters, double bearingDegrees) {
  const earthRadiusMeters = 6371000.0;
  final bearing = bearingDegrees * math.pi / 180;
  final lat1 = origin.latitude * math.pi / 180;
  final lng1 = origin.longitude * math.pi / 180;
  final angularDistance = distanceMeters / earthRadiusMeters;

  final lat2 = math.asin(
    math.sin(lat1) * math.cos(angularDistance) +
        math.cos(lat1) * math.sin(angularDistance) * math.cos(bearing),
  );
  final lng2 =
      lng1 +
      math.atan2(
        math.sin(bearing) * math.sin(angularDistance) * math.cos(lat1),
        math.cos(angularDistance) - math.sin(lat1) * math.sin(lat2),
      );

  return LatLng(lat2 * 180 / math.pi, lng2 * 180 / math.pi);
}

/// Bounds that fit a nearby-filter circle with a little padding for [LatLngBounds].
LatLngBounds nearbyRadiusBounds(LatLng center, double radiusMiles) {
  final points = circlePolygonPoints(center, radiusMiles * _metersPerMile);
  var minLat = points.first.latitude;
  var maxLat = points.first.latitude;
  var minLng = points.first.longitude;
  var maxLng = points.first.longitude;
  for (final point in points) {
    if (point.latitude < minLat) minLat = point.latitude;
    if (point.latitude > maxLat) maxLat = point.latitude;
    if (point.longitude < minLng) minLng = point.longitude;
    if (point.longitude > maxLng) maxLng = point.longitude;
  }
  return LatLngBounds(
    southwest: LatLng(minLat, minLng),
    northeast: LatLng(maxLat, maxLng),
  );
}

/// Returns actions with coordinates within [radiusMiles] of [center].
List<ActionSchema> filterActionsByNearbyRadius(
  List<ActionSchema> actions,
  LatLng center,
  double radiusMiles,
) {
  final radiusMeters = radiusMiles * _metersPerMile;
  return actions.where((action) {
    if (_isWithinRadius(
      center,
      action.latitude?.toDouble(),
      action.longitude?.toDouble(),
      radiusMeters,
    )) {
      return true;
    }
    return _routeHasWaypointWithinRadius(
      action.eventData,
      center,
      radiusMeters,
    );
  }).toList();
}

bool _isWithinRadius(
  LatLng center,
  double? lat,
  double? lng,
  double radiusMeters,
) {
  if (lat == null || lng == null) return false;
  return Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        lat,
        lng,
      ) <=
      radiusMeters;
}

bool _routeHasWaypointWithinRadius(
  Object? eventData,
  LatLng center,
  double radiusMeters,
) {
  if (eventData is! Map) return false;
  final waypoints = eventData['waypoints'];
  if (waypoints is! List) return false;
  for (final wp in waypoints) {
    if (wp is! Map) continue;
    final lat = wp['lat'];
    final lng = wp['lng'];
    if (lat is num && lng is num) {
      if (Geolocator.distanceBetween(
            center.latitude,
            center.longitude,
            lat.toDouble(),
            lng.toDouble(),
          ) <=
          radiusMeters) {
        return true;
      }
    }
  }
  return false;
}
