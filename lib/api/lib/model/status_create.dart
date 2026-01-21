//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class StatusCreate {
  /// Returns a new [StatusCreate] instance.
  StatusCreate({
    required this.name,
    required this.statusType,
  });

  StatusValuesEnum name;

  StatusTypeEnum statusType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StatusCreate &&
    other.name == name &&
    other.statusType == statusType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (statusType.hashCode);

  @override
  String toString() => 'StatusCreate[name=$name, statusType=$statusType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'status_type'] = this.statusType;
    return json;
  }

  /// Returns a new [StatusCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StatusCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StatusCreate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StatusCreate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StatusCreate(
        name: StatusValuesEnum.fromJson(json[r'name'])!,
        statusType: StatusTypeEnum.fromJson(json[r'status_type'])!,
      );
    }
    return null;
  }

  static List<StatusCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StatusCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StatusCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StatusCreate> mapFromJson(dynamic json) {
    final map = <String, StatusCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StatusCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StatusCreate-objects as value to a dart map
  static Map<String, List<StatusCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StatusCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StatusCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'status_type',
  };
}

