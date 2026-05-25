//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapHotspotUpdateSchema {
  /// Returns a new [MapHotspotUpdateSchema] instance.
  MapHotspotUpdateSchema({
    this.title,
    this.description,
    this.active,
    required this.actingUserId,
  });

  String? title;

  String? description;

  bool? active;

  String actingUserId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapHotspotUpdateSchema &&
    other.title == title &&
    other.description == description &&
    other.active == active &&
    other.actingUserId == actingUserId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title == null ? 0 : title!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (active == null ? 0 : active!.hashCode) +
    (actingUserId.hashCode);

  @override
  String toString() => 'MapHotspotUpdateSchema[title=$title, description=$description, active=$active, actingUserId=$actingUserId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.active != null) {
      json[r'active'] = this.active;
    } else {
      json[r'active'] = null;
    }
      json[r'acting_user_id'] = this.actingUserId;
    return json;
  }

  /// Returns a new [MapHotspotUpdateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapHotspotUpdateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapHotspotUpdateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapHotspotUpdateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapHotspotUpdateSchema(
        title: mapValueOfType<String>(json, r'title'),
        description: mapValueOfType<String>(json, r'description'),
        active: mapValueOfType<bool>(json, r'active'),
        actingUserId: mapValueOfType<String>(json, r'acting_user_id')!,
      );
    }
    return null;
  }

  static List<MapHotspotUpdateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapHotspotUpdateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapHotspotUpdateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapHotspotUpdateSchema> mapFromJson(dynamic json) {
    final map = <String, MapHotspotUpdateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapHotspotUpdateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapHotspotUpdateSchema-objects as value to a dart map
  static Map<String, List<MapHotspotUpdateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapHotspotUpdateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapHotspotUpdateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'acting_user_id',
  };
}

