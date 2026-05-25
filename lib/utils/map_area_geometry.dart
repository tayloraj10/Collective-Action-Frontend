import 'dart:convert';

import 'package:collective_action_frontend/models/map_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// One polygon ring group from a GeoJSON feature, ready for Google Maps.
class MapAreaPolygonFeature {
  MapAreaPolygonFeature({
    required this.name,
    required this.slug,
    required this.areaType,
    required this.rings,
    this.featureId,
  });

  final String name;
  final String slug;
  final String areaType;
  final String? featureId;

  /// Each inner list is one closed ring of [LatLng] (exterior or hole).
  final List<List<LatLng>> rings;
}

class MapAreaGeometryLayer {
  MapAreaGeometryLayer({
    required this.id,
    required this.label,
    required this.areaType,
    required this.features,
    required this.defaultVisible,
  });

  final String id;
  final String label;
  final String areaType;
  final List<MapAreaPolygonFeature> features;
  final bool defaultVisible;
}

class MapAreaGeometryRegion {
  MapAreaGeometryRegion({
    required this.id,
    required this.label,
    required this.layers,
    this.defaultCenterLat,
    this.defaultCenterLng,
  });

  final String id;
  final String label;
  final List<MapAreaGeometryLayer> layers;
  final double? defaultCenterLat;
  final double? defaultCenterLng;
}

/// Loads [manifest.json] and GeoJSON assets declared there.
class MapAreaGeometryService {
  MapAreaGeometryService({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<List<MapAreaGeometryRegion>> loadManifest() async {
    final raw = await _bundle.loadString('assets/data/map_areas/manifest.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final regions = json['regions'] as List<dynamic>? ?? [];
    final out = <MapAreaGeometryRegion>[];
    for (final regionJson in regions) {
      if (regionJson is! Map<String, dynamic>) continue;
      out.add(await _parseRegion(regionJson));
    }
    return out;
  }

  Future<MapAreaGeometryRegion> _parseRegion(Map<String, dynamic> json) async {
    final center = json['defaultCenter'] as Map<String, dynamic>?;
    final layersJson = json['layers'] as List<dynamic>? ?? [];
    final layers = <MapAreaGeometryLayer>[];
    for (final layerJson in layersJson) {
      if (layerJson is! Map<String, dynamic>) continue;
      layers.add(await _parseLayer(layerJson));
    }
    return MapAreaGeometryRegion(
      id: json['id'] as String,
      label: json['label'] as String? ?? json['id'] as String,
      layers: layers,
      defaultCenterLat: (center?['lat'] as num?)?.toDouble(),
      defaultCenterLng: (center?['lng'] as num?)?.toDouble(),
    );
  }

  Future<MapAreaGeometryLayer> _parseLayer(Map<String, dynamic> json) async {
    final assetPath = json['assetPath'] as String;
    final geoRaw = await _bundle.loadString(assetPath);
    final geo = jsonDecode(geoRaw) as Map<String, dynamic>;
    final nameProp = json['featureNameProperty'] as String? ?? 'name';
    final slugMap = (json['slugMap'] as Map<String, dynamic>?) ?? {};
    final displayNameMap =
        (json['displayNameMap'] as Map<String, dynamic>?) ?? {};
    final slugFromName = json['slugFromName'] as Map<String, dynamic>?;

    final features = <MapAreaPolygonFeature>[];
    for (final feature in geo['features'] as List<dynamic>? ?? []) {
      if (feature is! Map<String, dynamic>) continue;
      final props = feature['properties'] as Map<String, dynamic>? ?? {};
      final rawName =
          props[nameProp]?.toString() ?? feature['id']?.toString() ?? 'Area';
      final slugProperty = json['slugProperty'] as String?;
      final slugSource = slugProperty != null
          ? (props[slugProperty]?.toString() ?? rawName)
          : rawName;
      final slug = _slugForFeature(slugSource, slugMap, slugFromName);
      final name = displayNameMap[rawName]?.toString() ?? rawName;
      final rings = _ringsFromGeometry(feature['geometry']);
      if (rings.isEmpty) continue;
      features.add(
        MapAreaPolygonFeature(
          name: name,
          slug: slug,
          areaType: json['areaType'] as String? ?? 'custom',
          featureId: feature['id']?.toString(),
          rings: rings,
        ),
      );
    }

    return MapAreaGeometryLayer(
      id: json['id'] as String,
      label: json['label'] as String? ?? json['id'] as String,
      areaType: json['areaType'] as String? ?? 'custom',
      features: features,
      defaultVisible: json['defaultVisible'] as bool? ?? false,
    );
  }

  String _slugForFeature(
    String name,
    Map<String, dynamic> slugMap,
    Map<String, dynamic>? slugFromName,
  ) {
    if (slugMap.containsKey(name)) return slugMap[name] as String;
    if (slugFromName == null) return name;

    final prefix = slugFromName['prefix'] as String? ?? '';
    var slug = name;
    if (slugFromName['lowerCase'] == true) slug = slug.toLowerCase();
    final replace = slugFromName['replaceSpacesWith'] as String? ?? '-';
    slug = slug.replaceAll(' ', replace);
    final pattern = slugFromName['removeCharsPattern'] as String?;
    if (pattern != null) {
      slug = slug.replaceAll(RegExp(pattern), '');
    }
    slug = slug.replaceAll(RegExp('-+'), '-').replaceAll(RegExp(r'^-|-$'), '');
    return '$prefix$slug';
  }

  List<List<LatLng>> _ringsFromGeometry(dynamic geometry) {
    if (geometry is! Map<String, dynamic>) return [];
    final type = geometry['type'] as String?;
    final coords = geometry['coordinates'];
    if (type == 'Polygon' && coords is List) {
      return _parsePolygonCoords(coords);
    }
    if (type == 'MultiPolygon' && coords is List) {
      final rings = <List<LatLng>>[];
      for (final poly in coords) {
        rings.addAll(_parsePolygonCoords(poly));
      }
      return rings;
    }
    return [];
  }

  List<List<LatLng>> _parsePolygonCoords(List<dynamic> polygonCoords) {
    final rings = <List<LatLng>>[];
    for (final ring in polygonCoords) {
      if (ring is! List) continue;
      final points = <LatLng>[];
      for (final pair in ring) {
        if (pair is! List || pair.length < 2) continue;
        points.add(
          LatLng((pair[1] as num).toDouble(), (pair[0] as num).toDouble()),
        );
      }
      if (points.length >= 3) rings.add(points);
    }
    return rings;
  }
}

/// Centroid of the first ring (for map labels/tooltips).
LatLng? featureCentroid(MapAreaPolygonFeature feature) {
  if (feature.rings.isEmpty || feature.rings.first.isEmpty) return null;
  final ring = feature.rings.first;
  var lat = 0.0;
  var lng = 0.0;
  for (final point in ring) {
    lat += point.latitude;
    lng += point.longitude;
  }
  return LatLng(lat / ring.length, lng / ring.length);
}

int _stableColorHash(String key) {
  var hash = 0;
  for (final unit in key.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return hash;
}

/// Visually distinct palette for neighborhood polygons.
const _neighborhoodPalette = <Color>[
  Color(0xFFE53935), // red
  Color(0xFF1E88E5), // blue
  Color(0xFF43A047), // green
  Color(0xFFFB8C00), // orange
  Color(0xFF8E24AA), // purple
  Color(0xFF00ACC1), // cyan
  Color(0xFFFDD835), // yellow
  Color(0xFF6D4C41), // brown
  Color(0xFF546E7A), // blue grey
  Color(0xFFEC407A), // pink
  Color(0xFF7CB342), // lime green
  Color(0xFF5E35B1), // indigo
  Color(0xFF26A69A), // teal
  Color(0xFFFF7043), // deep orange
  Color(0xFF29B6F6), // sky blue
  Color(0xFF9CCC65), // yellow green
];

int _pickNeighborhoodColorIndex({
  required Set<int> usedByNeighbors,
  required MapAreaPolygonFeature feature,
  required List<int> usageCounts,
}) {
  final available = <int>[
    for (var c = 0; c < _neighborhoodPalette.length; c++)
      if (!usedByNeighbors.contains(c)) c,
  ];
  if (available.isEmpty) {
    return _stableColorHash(feature.slug) % _neighborhoodPalette.length;
  }

  // Spread colors: pick the least-used valid index, hash breaks ties stably.
  final minUsage = available
      .map((c) => usageCounts[c])
      .reduce((a, b) => a < b ? a : b);
  final leastUsed = available.where((c) => usageCounts[c] == minUsage).toList()
    ..sort();
  return leastUsed[_stableColorHash(feature.slug) % leastUsed.length];
}

/// Round lat/lng for edge matching against simplified GeoJSON coordinates.
String _pointKey(LatLng point) {
  final lat = (point.latitude * 100000).round() / 100000;
  final lng = (point.longitude * 100000).round() / 100000;
  return '$lat,$lng';
}

String _edgeKey(LatLng a, LatLng b) {
  final aKey = _pointKey(a);
  final bKey = _pointKey(b);
  return aKey.compareTo(bKey) <= 0 ? '$aKey|$bKey' : '$bKey|$aKey';
}

Set<String> _edgeKeysForFeature(MapAreaPolygonFeature feature) {
  final edges = <String>{};
  for (final ring in feature.rings) {
    if (ring.length < 2) continue;
    for (var i = 0; i < ring.length - 1; i++) {
      edges.add(_edgeKey(ring[i], ring[i + 1]));
    }
    if (ring.length > 2 && _pointKey(ring.first) != _pointKey(ring.last)) {
      edges.add(_edgeKey(ring.last, ring.first));
    }
  }
  return edges;
}

/// Adjacency lists keyed by feature index (shared boundary segment).
Map<int, Set<int>> buildNeighborhoodAdjacency(
  List<MapAreaPolygonFeature> features,
) {
  final edgeOwners = <String, List<int>>{};
  for (var i = 0; i < features.length; i++) {
    for (final edge in _edgeKeysForFeature(features[i])) {
      edgeOwners.putIfAbsent(edge, () => []).add(i);
    }
  }

  final adjacency = {for (var i = 0; i < features.length; i++) i: <int>{}};
  for (final owners in edgeOwners.values) {
    if (owners.length < 2) continue;
    for (var a = 0; a < owners.length; a++) {
      for (var b = a + 1; b < owners.length; b++) {
        adjacency[owners[a]]!.add(owners[b]);
        adjacency[owners[b]]!.add(owners[a]);
      }
    }
  }
  return adjacency;
}

/// Greedy graph coloring so adjacent neighborhoods get different palette colors.
Map<String, Color> assignNeighborhoodColors(
  List<MapAreaPolygonFeature> features,
) {
  if (features.isEmpty) return {};

  final adjacency = buildNeighborhoodAdjacency(features);
  final order = List.generate(features.length, (i) => i)
    ..sort((a, b) {
      final degreeDiff = adjacency[b]!.length.compareTo(adjacency[a]!.length);
      if (degreeDiff != 0) return degreeDiff;
      return features[a].slug.compareTo(features[b].slug);
    });

  final colorIndexByFeature = <int, int>{};
  final usageCounts = List.filled(_neighborhoodPalette.length, 0);
  for (final i in order) {
    final used = {
      for (final neighbor in adjacency[i]!)
        if (colorIndexByFeature.containsKey(neighbor))
          colorIndexByFeature[neighbor]!,
    };

    final pick = _pickNeighborhoodColorIndex(
      usedByNeighbors: used,
      feature: features[i],
      usageCounts: usageCounts,
    );
    colorIndexByFeature[i] = pick;
    usageCounts[pick]++;
  }

  return {
    for (var i = 0; i < features.length; i++)
      features[i].slug: _neighborhoodPalette[colorIndexByFeature[i]!],
  };
}

/// Explicit NYC borough colors; neighborhoods use adjacency-aware palette assignment.
Color areaPolygonColor(String key, {String? areaType}) {
  const boroughOverrides = <String, Color>{
    'nyc-manhattan': Color(0xFFE53935),
    'nyc-bronx': Color(0xFF7B1FA2),
    'nyc-staten-island': Color(0xFF757575),
  };
  final boroughOverride = boroughOverrides[key];
  if (boroughOverride != null) return boroughOverride;

  if (areaType == 'neighborhood') {
    final index = _stableColorHash(key) % _neighborhoodPalette.length;
    return _neighborhoodPalette[index];
  }

  final hue = _stableColorHash(key) % 360;
  return HSLColor.fromAHSL(1, hue.toDouble(), 0.58, 0.42).toColor();
}

typedef MapAreaPolygonTapCallback =
    void Function(MapAreaPolygonFeature feature);

/// Build Google Maps [Polygon]s from loaded geometry features.
Set<Polygon> buildAreaPolygons({
  required List<MapAreaPolygonFeature> features,
  required List<MapAreaModel> backendAreas,
  required List<AreaCaptainModel> captains,
  required String? currentUserId,
  MapAreaPolygonTapCallback? onFeatureTap,
  double fillAlpha = 0.18,
  double strokeWidth = 2,
}) {
  final slugToAreaId = {
    for (final a in backendAreas)
      if (a.slug != null) a.slug!: a.id,
  };
  final captainAreaIds = {
    for (final c in captains)
      if (c.captainUserId == currentUserId) c.mapAreaId,
  };

  final neighborhoodFeatures = features
      .where((f) => f.areaType == 'neighborhood')
      .toList();
  final neighborhoodColors = assignNeighborhoodColors(neighborhoodFeatures);

  final polygons = <Polygon>{};
  var index = 0;
  for (final feature in features) {
    final backendAreaId = slugToAreaId[feature.slug];
    final isUserCaptain =
        backendAreaId != null && captainAreaIds.contains(backendAreaId);
    final hasCaptain =
        backendAreaId != null &&
        captains.any((c) => c.mapAreaId == backendAreaId);

    final baseColor = feature.areaType == 'neighborhood'
        ? neighborhoodColors[feature.slug]!
        : areaPolygonColor(feature.slug, areaType: feature.areaType);
    final fill = baseColor.withValues(
      alpha: isUserCaptain ? fillAlpha * 1.6 : fillAlpha,
    );
    final stroke = baseColor;
    final width = strokeWidth + (hasCaptain ? 1 : 0) + (isUserCaptain ? 1 : 0);

    for (var ringIndex = 0; ringIndex < feature.rings.length; ringIndex++) {
      final ring = feature.rings[ringIndex];
      if (ring.length < 3) continue;
      polygons.add(
        Polygon(
          polygonId: PolygonId('area_${feature.slug}_${index}_$ringIndex'),
          points: ring,
          fillColor: fill,
          strokeColor: stroke,
          strokeWidth: width.toInt(),
          zIndex: isUserCaptain ? 2 : 1,
          consumeTapEvents: onFeatureTap != null,
          onTap: onFeatureTap == null ? null : () => onFeatureTap(feature),
        ),
      );
    }
    index++;
  }
  return polygons;
}

/// Ray-casting point-in-ring test (uses lng as x, lat as y).
bool pointInRing(LatLng point, List<LatLng> ring) {
  if (ring.length < 3) return false;

  var inside = false;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final xi = ring[i].longitude;
    final yi = ring[i].latitude;
    final xj = ring[j].longitude;
    final yj = ring[j].latitude;
    final intersects =
        ((yi > point.latitude) != (yj > point.latitude)) &&
        (point.longitude < (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);
    if (intersects) inside = !inside;
  }
  return inside;
}

/// True when [point] lies inside a GeoJSON polygon feature (exterior minus holes).
bool pointInFeature(LatLng point, MapAreaPolygonFeature feature) {
  if (feature.rings.isEmpty) return false;

  if (!pointInRing(point, feature.rings.first)) return false;
  for (var i = 1; i < feature.rings.length; i++) {
    if (pointInRing(point, feature.rings[i])) return false;
  }
  return true;
}
