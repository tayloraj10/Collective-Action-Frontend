//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class CategorySchema {
  /// Returns a new [CategorySchema] instance.
  CategorySchema({
    this.id,
    required this.name,
  });

  String? id;

  CategoryValuesEnum name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CategorySchema &&
    other.id == id &&
    other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'CategorySchema[id=$id, name=$name]';

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

  /// Returns a new [CategorySchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CategorySchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CategorySchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CategorySchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CategorySchema(
        id: mapValueOfType<String>(json, r'id'),
        name: CategoryValuesEnum.fromJson(json[r'name'])!,
      );
    }
    return null;
  }

  static List<CategorySchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CategorySchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CategorySchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CategorySchema> mapFromJson(dynamic json) {
    final map = <String, CategorySchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CategorySchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CategorySchema-objects as value to a dart map
  static Map<String, List<CategorySchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CategorySchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CategorySchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

