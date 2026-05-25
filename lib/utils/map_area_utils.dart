import 'dart:math' as math;

import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/utils/map_area_geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Default map center when focusing on NYC (initial seed region).
const nycMapCenter = (40.7128, -73.9500);

const _areaTypeLabels = <String, String>{
  'borough': 'Borough',
  'neighborhood': 'Neighborhood',
  'city': 'City',
  'town': 'Town',
  'region': 'Region',
  'custom': 'Custom',
};

const _areaNameOverrides = <String, String>{
  'nyc-bronx': 'The Bronx',
};

bool mapAreaBoundsContains(
  MapAreaBoundsSchema bounds,
  double latitude,
  double longitude,
) {
  return latitude >= bounds.minLat &&
      latitude <= bounds.maxLat &&
      longitude >= bounds.minLng &&
      longitude <= bounds.maxLng;
}

/// Return the first [areas] whose bounds contain the point, or null.
MapAreaSchema? detectAreaForPoint(
  double latitude,
  double longitude,
  List<MapAreaSchema> areas,
) {
  for (final area in areas) {
    if (!area.active) continue;
    final bounds = area.bounds;
    if (bounds != null &&
        mapAreaBoundsContains(bounds, latitude, longitude)) {
      return area;
    }
  }
  return null;
}

/// Like [detectAreaForPoint] but uses map geometry when available (stricter).
MapAreaSchema? detectCaptainAreaForPoint({
  required double latitude,
  required double longitude,
  required List<MapAreaSchema> captainAreas,
  required List<MapAreaPolygonFeature> geometryFeatures,
}) {
  if (captainAreas.isEmpty) return null;

  final point = LatLng(latitude, longitude);
  final slugToArea = {
    for (final area in captainAreas)
      if (area.slug != null) area.slug!: area,
  };
  if (slugToArea.isEmpty) {
    return detectAreaForPoint(latitude, longitude, captainAreas);
  }

  if (geometryFeatures.isNotEmpty) {
    for (final feature in geometryFeatures) {
      if (!slugToArea.containsKey(feature.slug)) continue;
      if (pointInFeature(point, feature)) {
        return slugToArea[feature.slug];
      }
    }
    return null;
  }

  return detectAreaForPoint(latitude, longitude, captainAreas);
}

String areaTypeLabel(MapAreaSchema area) {
  return _areaTypeLabels[area.areaType] ?? area.areaType;
}

/// Preferred display name for a backend map area (handles legacy seed names).
String areaDisplayName(MapAreaSchema area) {
  final slug = area.slug;
  if (slug != null && _areaNameOverrides.containsKey(slug)) {
    return _areaNameOverrides[slug]!;
  }
  return area.name;
}

String hotspotAreaName(MapHotspotSchema hotspot) {
  final area = hotspot.area;
  if (area != null) return areaDisplayName(area);
  return 'Unknown area';
}

/// Map anchor at the middle-left of a borough (badge renders just inside the west edge).
LatLng? areaBadgeAnchor(
  MapAreaSchema area,
  List<MapAreaPolygonFeature> geometryFeatures,
) {
  final slug = area.slug;
  if (slug != null) {
    MapAreaPolygonFeature? mainFeature;
    var mainArea = 0.0;
    for (final feature in geometryFeatures) {
      if (feature.slug != slug) continue;
      final featureArea = ringAreaAbs(largestAreaRing(feature));
      if (featureArea > mainArea) {
        mainArea = featureArea;
        mainFeature = feature;
      }
    }
    if (mainFeature != null) {
      return middleLeftAnchorForFeature(mainFeature);
    }
  }

  final bounds = area.bounds;
  if (bounds == null) return null;
  return LatLng(
    (bounds.minLat + bounds.maxLat) / 2,
    bounds.minLng.toDouble(),
  );
}

/// Middle-left point on the main polygon body for a map area feature.
LatLng? middleLeftAnchorForFeature(MapAreaPolygonFeature feature) {
  final ring = largestAreaRing(feature);
  if (ring.isEmpty) return null;

  final centroid = ringCentroid(ring);
  if (centroid == null) return null;

  var minLat = double.infinity;
  var maxLat = -double.infinity;
  for (final point in ring) {
    minLat = math.min(minLat, point.latitude);
    maxLat = math.max(maxLat, point.latitude);
  }

  final targetLat = centroid.latitude.clamp(minLat, maxLat);
  final westLng = westEdgeLongitudeAtLatitude(ring, targetLat);
  if (westLng == null) return null;

  var minLng = double.infinity;
  var maxLng = -double.infinity;
  for (final point in ring) {
    minLng = math.min(minLng, point.longitude);
    maxLng = math.max(maxLng, point.longitude);
  }
  final lngInset = math.min((maxLng - minLng) * 0.04, 0.004);

  return LatLng(targetLat, westLng + lngInset);
}

/// Picks the main landmass ring (largest absolute area) for multipolygon features.
List<LatLng> largestAreaRing(MapAreaPolygonFeature feature) {
  if (feature.rings.isEmpty) return const [];
  var best = feature.rings.first;
  var bestArea = ringAreaAbs(best);
  for (final ring in feature.rings.skip(1)) {
    final area = ringAreaAbs(ring);
    if (area > bestArea) {
      bestArea = area;
      best = ring;
    }
  }
  return best;
}

double ringAreaAbs(List<LatLng> ring) {
  if (ring.length < 3) return 0;
  var twiceArea = 0.0;
  for (var i = 0; i < ring.length; i++) {
    final j = (i + 1) % ring.length;
    twiceArea += ring[i].longitude * ring[j].latitude;
    twiceArea -= ring[j].longitude * ring[i].latitude;
  }
  return twiceArea.abs() * 0.5;
}

LatLng? ringCentroid(List<LatLng> ring) {
  if (ring.isEmpty) return null;
  if (ring.length < 3) {
    var lat = 0.0;
    var lng = 0.0;
    for (final point in ring) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / ring.length, lng / ring.length);
  }

  var twiceArea = 0.0;
  var cx = 0.0;
  var cy = 0.0;
  for (var i = 0; i < ring.length; i++) {
    final j = (i + 1) % ring.length;
    final cross =
        ring[i].longitude * ring[j].latitude -
        ring[j].longitude * ring[i].latitude;
    twiceArea += cross;
    cx += (ring[i].longitude + ring[j].longitude) * cross;
    cy += (ring[i].latitude + ring[j].latitude) * cross;
  }

  if (twiceArea.abs() < 1e-15) {
    var lat = 0.0;
    var lng = 0.0;
    for (final point in ring) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / ring.length, lng / ring.length);
  }

  return LatLng(cy / (3 * twiceArea), cx / (3 * twiceArea));
}

/// Westernmost boundary longitude where the polygon crosses [targetLat].
double? westEdgeLongitudeAtLatitude(List<LatLng> ring, double targetLat) {
  if (ring.isEmpty) return null;

  const eps = 1e-12;
  var minLng = double.infinity;
  var found = false;

  for (var i = 0; i < ring.length; i++) {
    final a = ring[i];
    final b = ring[(i + 1) % ring.length];

    final latLo = math.min(a.latitude, b.latitude);
    final latHi = math.max(a.latitude, b.latitude);
    if (targetLat < latLo - eps || targetLat > latHi + eps) continue;

    if ((a.latitude - b.latitude).abs() < eps) {
      if ((a.latitude - targetLat).abs() <= eps) {
        minLng = math.min(minLng, math.min(a.longitude, b.longitude));
        found = true;
      }
      continue;
    }

    final t = (targetLat - a.latitude) / (b.latitude - a.latitude);
    if (t < -eps || t > 1 + eps) continue;
    final lng = a.longitude + t * (b.longitude - a.longitude);
    if (lng < minLng) {
      minLng = lng;
      found = true;
    }
  }

  return found ? minLng : null;
}
