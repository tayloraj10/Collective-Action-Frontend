//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MemberIdsByRole {
  /// Returns a new [MemberIdsByRole] instance.
  MemberIdsByRole({
    this.members = const [],
    this.owners = const [],
    this.developers = const [],
  });

  List<String> members;

  List<String> owners;

  List<String> developers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MemberIdsByRole &&
    _deepEquality.equals(other.members, members) &&
    _deepEquality.equals(other.owners, owners) &&
    _deepEquality.equals(other.developers, developers);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (members.hashCode) +
    (owners.hashCode) +
    (developers.hashCode);

  @override
  String toString() => 'MemberIdsByRole[members=$members, owners=$owners, developers=$developers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'members'] = this.members;
      json[r'owners'] = this.owners;
      json[r'developers'] = this.developers;
    return json;
  }

  /// Returns a new [MemberIdsByRole] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MemberIdsByRole? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MemberIdsByRole[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MemberIdsByRole[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MemberIdsByRole(
        members: json[r'members'] is Iterable
            ? (json[r'members'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        owners: json[r'owners'] is Iterable
            ? (json[r'owners'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        developers: json[r'developers'] is Iterable
            ? (json[r'developers'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<MemberIdsByRole> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MemberIdsByRole>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MemberIdsByRole.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MemberIdsByRole> mapFromJson(dynamic json) {
    final map = <String, MemberIdsByRole>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MemberIdsByRole.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MemberIdsByRole-objects as value to a dart map
  static Map<String, List<MemberIdsByRole>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MemberIdsByRole>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MemberIdsByRole.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

