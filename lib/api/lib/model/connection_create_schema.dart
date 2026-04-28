//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ConnectionCreateSchema {
  /// Returns a new [ConnectionCreateSchema] instance.
  ConnectionCreateSchema({
    required this.createdBy,
    required this.fromType,
    required this.fromId,
    required this.toType,
    required this.toId,
  });

  String createdBy;

  String fromType;

  String fromId;

  String toType;

  String toId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConnectionCreateSchema &&
    other.createdBy == createdBy &&
    other.fromType == fromType &&
    other.fromId == fromId &&
    other.toType == toType &&
    other.toId == toId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdBy.hashCode) +
    (fromType.hashCode) +
    (fromId.hashCode) +
    (toType.hashCode) +
    (toId.hashCode);

  @override
  String toString() => 'ConnectionCreateSchema[createdBy=$createdBy, fromType=$fromType, fromId=$fromId, toType=$toType, toId=$toId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_by'] = this.createdBy;
      json[r'from_type'] = this.fromType;
      json[r'from_id'] = this.fromId;
      json[r'to_type'] = this.toType;
      json[r'to_id'] = this.toId;
    return json;
  }

  /// Returns a new [ConnectionCreateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConnectionCreateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConnectionCreateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConnectionCreateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConnectionCreateSchema(
        createdBy: mapValueOfType<String>(json, r'created_by')!,
        fromType: mapValueOfType<String>(json, r'from_type')!,
        fromId: mapValueOfType<String>(json, r'from_id')!,
        toType: mapValueOfType<String>(json, r'to_type')!,
        toId: mapValueOfType<String>(json, r'to_id')!,
      );
    }
    return null;
  }

  static List<ConnectionCreateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConnectionCreateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConnectionCreateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConnectionCreateSchema> mapFromJson(dynamic json) {
    final map = <String, ConnectionCreateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConnectionCreateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConnectionCreateSchema-objects as value to a dart map
  static Map<String, List<ConnectionCreateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConnectionCreateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConnectionCreateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_by',
    'from_type',
    'from_id',
    'to_type',
    'to_id',
  };
}

