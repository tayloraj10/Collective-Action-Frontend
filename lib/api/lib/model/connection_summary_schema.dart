//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ConnectionSummarySchema {
  /// Returns a new [ConnectionSummarySchema] instance.
  ConnectionSummarySchema({
    required this.toId,
    required this.totalCount,
    required this.userCount,
    required this.orgCount,
    this.previewUsers = const [],
    this.orgIds = const [],
  });

  String toId;

  int totalCount;

  int userCount;

  int orgCount;

  List<PreviewUserSchema> previewUsers;

  List<String> orgIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConnectionSummarySchema &&
    other.toId == toId &&
    other.totalCount == totalCount &&
    other.userCount == userCount &&
    other.orgCount == orgCount &&
    _deepEquality.equals(other.previewUsers, previewUsers) &&
    _deepEquality.equals(other.orgIds, orgIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (toId.hashCode) +
    (totalCount.hashCode) +
    (userCount.hashCode) +
    (orgCount.hashCode) +
    (previewUsers.hashCode) +
    (orgIds.hashCode);

  @override
  String toString() => 'ConnectionSummarySchema[toId=$toId, totalCount=$totalCount, userCount=$userCount, orgCount=$orgCount, previewUsers=$previewUsers, orgIds=$orgIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'to_id'] = this.toId;
      json[r'total_count'] = this.totalCount;
      json[r'user_count'] = this.userCount;
      json[r'org_count'] = this.orgCount;
      json[r'preview_users'] = this.previewUsers;
      json[r'org_ids'] = this.orgIds;
    return json;
  }

  /// Returns a new [ConnectionSummarySchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConnectionSummarySchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConnectionSummarySchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConnectionSummarySchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConnectionSummarySchema(
        toId: mapValueOfType<String>(json, r'to_id')!,
        totalCount: mapValueOfType<int>(json, r'total_count')!,
        userCount: mapValueOfType<int>(json, r'user_count')!,
        orgCount: mapValueOfType<int>(json, r'org_count')!,
        previewUsers: PreviewUserSchema.listFromJson(json[r'preview_users']),
        orgIds: json[r'org_ids'] is Iterable
            ? (json[r'org_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ConnectionSummarySchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConnectionSummarySchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConnectionSummarySchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConnectionSummarySchema> mapFromJson(dynamic json) {
    final map = <String, ConnectionSummarySchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConnectionSummarySchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConnectionSummarySchema-objects as value to a dart map
  static Map<String, List<ConnectionSummarySchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConnectionSummarySchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConnectionSummarySchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'to_id',
    'total_count',
    'user_count',
    'org_count',
    'preview_users',
    'org_ids',
  };
}

