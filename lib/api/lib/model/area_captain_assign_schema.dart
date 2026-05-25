//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class AreaCaptainAssignSchema {
  /// Returns a new [AreaCaptainAssignSchema] instance.
  AreaCaptainAssignSchema({
    required this.mapAreaId,
    required this.captainUserId,
    required this.actingUserId,
  });

  String mapAreaId;

  String captainUserId;

  String actingUserId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AreaCaptainAssignSchema &&
    other.mapAreaId == mapAreaId &&
    other.captainUserId == captainUserId &&
    other.actingUserId == actingUserId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (mapAreaId.hashCode) +
    (captainUserId.hashCode) +
    (actingUserId.hashCode);

  @override
  String toString() => 'AreaCaptainAssignSchema[mapAreaId=$mapAreaId, captainUserId=$captainUserId, actingUserId=$actingUserId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'map_area_id'] = this.mapAreaId;
      json[r'captain_user_id'] = this.captainUserId;
      json[r'acting_user_id'] = this.actingUserId;
    return json;
  }

  /// Returns a new [AreaCaptainAssignSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AreaCaptainAssignSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AreaCaptainAssignSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AreaCaptainAssignSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AreaCaptainAssignSchema(
        mapAreaId: mapValueOfType<String>(json, r'map_area_id')!,
        captainUserId: mapValueOfType<String>(json, r'captain_user_id')!,
        actingUserId: mapValueOfType<String>(json, r'acting_user_id')!,
      );
    }
    return null;
  }

  static List<AreaCaptainAssignSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AreaCaptainAssignSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AreaCaptainAssignSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AreaCaptainAssignSchema> mapFromJson(dynamic json) {
    final map = <String, AreaCaptainAssignSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AreaCaptainAssignSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AreaCaptainAssignSchema-objects as value to a dart map
  static Map<String, List<AreaCaptainAssignSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AreaCaptainAssignSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AreaCaptainAssignSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'map_area_id',
    'captain_user_id',
    'acting_user_id',
  };
}

