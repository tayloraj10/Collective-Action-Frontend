//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapAreaBoundsSchema {
  /// Returns a new [MapAreaBoundsSchema] instance.
  MapAreaBoundsSchema({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
  });

  num minLat;

  num maxLat;

  num minLng;

  num maxLng;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapAreaBoundsSchema &&
    other.minLat == minLat &&
    other.maxLat == maxLat &&
    other.minLng == minLng &&
    other.maxLng == maxLng;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (minLat.hashCode) +
    (maxLat.hashCode) +
    (minLng.hashCode) +
    (maxLng.hashCode);

  @override
  String toString() => 'MapAreaBoundsSchema[minLat=$minLat, maxLat=$maxLat, minLng=$minLng, maxLng=$maxLng]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'min_lat'] = this.minLat;
      json[r'max_lat'] = this.maxLat;
      json[r'min_lng'] = this.minLng;
      json[r'max_lng'] = this.maxLng;
    return json;
  }

  /// Returns a new [MapAreaBoundsSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapAreaBoundsSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapAreaBoundsSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapAreaBoundsSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapAreaBoundsSchema(
        minLat: num.parse('${json[r'min_lat']}'),
        maxLat: num.parse('${json[r'max_lat']}'),
        minLng: num.parse('${json[r'min_lng']}'),
        maxLng: num.parse('${json[r'max_lng']}'),
      );
    }
    return null;
  }

  static List<MapAreaBoundsSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapAreaBoundsSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapAreaBoundsSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapAreaBoundsSchema> mapFromJson(dynamic json) {
    final map = <String, MapAreaBoundsSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapAreaBoundsSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapAreaBoundsSchema-objects as value to a dart map
  static Map<String, List<MapAreaBoundsSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapAreaBoundsSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapAreaBoundsSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'min_lat',
    'max_lat',
    'min_lng',
    'max_lng',
  };
}

