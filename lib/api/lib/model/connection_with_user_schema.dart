//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ConnectionWithUserSchema {
  /// Returns a new [ConnectionWithUserSchema] instance.
  ConnectionWithUserSchema({
    required this.id,
    required this.createdBy,
    required this.fromType,
    required this.fromId,
    required this.toType,
    required this.toId,
    required this.connectionType,
    required this.createdAt,
    this.user,
  });

  String id;

  String createdBy;

  String fromType;

  String fromId;

  String toType;

  String toId;

  String connectionType;

  DateTime createdAt;

  PreviewUserSchema? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConnectionWithUserSchema &&
    other.id == id &&
    other.createdBy == createdBy &&
    other.fromType == fromType &&
    other.fromId == fromId &&
    other.toType == toType &&
    other.toId == toId &&
    other.connectionType == connectionType &&
    other.createdAt == createdAt &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdBy.hashCode) +
    (fromType.hashCode) +
    (fromId.hashCode) +
    (toType.hashCode) +
    (toId.hashCode) +
    (connectionType.hashCode) +
    (createdAt.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'ConnectionWithUserSchema[id=$id, createdBy=$createdBy, fromType=$fromType, fromId=$fromId, toType=$toType, toId=$toId, connectionType=$connectionType, createdAt=$createdAt, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'created_by'] = this.createdBy;
      json[r'from_type'] = this.fromType;
      json[r'from_id'] = this.fromId;
      json[r'to_type'] = this.toType;
      json[r'to_id'] = this.toId;
      json[r'connection_type'] = this.connectionType;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [ConnectionWithUserSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConnectionWithUserSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConnectionWithUserSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConnectionWithUserSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConnectionWithUserSchema(
        id: mapValueOfType<String>(json, r'id')!,
        createdBy: mapValueOfType<String>(json, r'created_by')!,
        fromType: mapValueOfType<String>(json, r'from_type')!,
        fromId: mapValueOfType<String>(json, r'from_id')!,
        toType: mapValueOfType<String>(json, r'to_type')!,
        toId: mapValueOfType<String>(json, r'to_id')!,
        connectionType: mapValueOfType<String>(json, r'connection_type')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        user: PreviewUserSchema.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<ConnectionWithUserSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConnectionWithUserSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConnectionWithUserSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConnectionWithUserSchema> mapFromJson(dynamic json) {
    final map = <String, ConnectionWithUserSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConnectionWithUserSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConnectionWithUserSchema-objects as value to a dart map
  static Map<String, List<ConnectionWithUserSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConnectionWithUserSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConnectionWithUserSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'created_by',
    'from_type',
    'from_id',
    'to_type',
    'to_id',
    'connection_type',
    'created_at',
  };
}

