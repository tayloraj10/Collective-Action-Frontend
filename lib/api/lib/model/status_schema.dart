//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class StatusSchema {
  /// Returns a new [StatusSchema] instance.
  StatusSchema({
    this.id,
    required this.name,
  });

  String? id;

  StatusValuesEnum name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StatusSchema &&
    other.id == id &&
    other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'StatusSchema[id=$id, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
      json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [StatusSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StatusSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StatusSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StatusSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StatusSchema(
        id: mapValueOfType<String>(json, r'id'),
        name: StatusValuesEnum.fromJson(json[r'name'])!,
      );
    }
    return null;
  }

  static List<StatusSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StatusSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StatusSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StatusSchema> mapFromJson(dynamic json) {
    final map = <String, StatusSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StatusSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StatusSchema-objects as value to a dart map
  static Map<String, List<StatusSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StatusSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StatusSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

