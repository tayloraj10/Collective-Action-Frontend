//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class PreviewUserSchema {
  /// Returns a new [PreviewUserSchema] instance.
  PreviewUserSchema({
    required this.id,
    this.name,
    this.photoUrl,
  });

  String id;

  String? name;

  String? photoUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PreviewUserSchema &&
    other.id == id &&
    other.name == name &&
    other.photoUrl == photoUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (photoUrl == null ? 0 : photoUrl!.hashCode);

  @override
  String toString() => 'PreviewUserSchema[id=$id, name=$name, photoUrl=$photoUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.photoUrl != null) {
      json[r'photo_url'] = this.photoUrl;
    } else {
      json[r'photo_url'] = null;
    }
    return json;
  }

  /// Returns a new [PreviewUserSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PreviewUserSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PreviewUserSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PreviewUserSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PreviewUserSchema(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name'),
        photoUrl: mapValueOfType<String>(json, r'photo_url'),
      );
    }
    return null;
  }

  static List<PreviewUserSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PreviewUserSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PreviewUserSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PreviewUserSchema> mapFromJson(dynamic json) {
    final map = <String, PreviewUserSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PreviewUserSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PreviewUserSchema-objects as value to a dart map
  static Map<String, List<PreviewUserSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PreviewUserSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PreviewUserSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

