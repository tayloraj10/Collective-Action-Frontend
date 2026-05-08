//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class CleanupWaypoint {
  /// Returns a new [CleanupWaypoint] instance.
  CleanupWaypoint({
    this.lat = 0,
    this.lng = 0,
    this.number = 0,
  });

  num lat;

  num lng;

  int number;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CleanupWaypoint &&
    other.lat == lat &&
    other.lng == lng &&
    other.number == number;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (lat.hashCode) +
    (lng.hashCode) +
    (number.hashCode);

  @override
  String toString() => 'CleanupWaypoint[lat=$lat, lng=$lng, number=$number]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'lat'] = this.lat;
      json[r'lng'] = this.lng;
      json[r'number'] = this.number;
    return json;
  }

  /// Returns a new [CleanupWaypoint] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CleanupWaypoint? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CleanupWaypoint[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CleanupWaypoint[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CleanupWaypoint(
        lat: num.parse('${json[r'lat']}'),
        lng: num.parse('${json[r'lng']}'),
        number: mapValueOfType<int>(json, r'number') ?? 0,
      );
    }
    return null;
  }

  static List<CleanupWaypoint> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CleanupWaypoint>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CleanupWaypoint.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CleanupWaypoint> mapFromJson(dynamic json) {
    final map = <String, CleanupWaypoint>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CleanupWaypoint.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CleanupWaypoint-objects as value to a dart map
  static Map<String, List<CleanupWaypoint>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CleanupWaypoint>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CleanupWaypoint.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

