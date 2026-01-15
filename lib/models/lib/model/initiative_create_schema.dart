//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class InitiativeCreateSchema {
  /// Returns a new [InitiativeCreateSchema] instance.
  InitiativeCreateSchema({
    required this.title,
    required this.action,
    this.categoryId,
    this.goal,
    this.link,
    this.priority = false,
    this.statusId,
  });

  String title;

  String action;

  String? categoryId;

  int? goal;

  String? link;

  bool priority;

  String? statusId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InitiativeCreateSchema &&
    other.title == title &&
    other.action == action &&
    other.categoryId == categoryId &&
    other.goal == goal &&
    other.link == link &&
    other.priority == priority &&
    other.statusId == statusId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (action.hashCode) +
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (goal == null ? 0 : goal!.hashCode) +
    (link == null ? 0 : link!.hashCode) +
    (priority.hashCode) +
    (statusId == null ? 0 : statusId!.hashCode);

  @override
  String toString() => 'InitiativeCreateSchema[title=$title, action=$action, categoryId=$categoryId, goal=$goal, link=$link, priority=$priority, statusId=$statusId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'action'] = this.action;
    if (this.categoryId != null) {
      json[r'category_id'] = this.categoryId;
    } else {
      json[r'category_id'] = null;
    }
    if (this.goal != null) {
      json[r'goal'] = this.goal;
    } else {
      json[r'goal'] = null;
    }
    if (this.link != null) {
      json[r'link'] = this.link;
    } else {
      json[r'link'] = null;
    }
      json[r'priority'] = this.priority;
    if (this.statusId != null) {
      json[r'status_id'] = this.statusId;
    } else {
      json[r'status_id'] = null;
    }
    return json;
  }

  /// Returns a new [InitiativeCreateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InitiativeCreateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "InitiativeCreateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "InitiativeCreateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return InitiativeCreateSchema(
        title: mapValueOfType<String>(json, r'title')!,
        action: mapValueOfType<String>(json, r'action')!,
        categoryId: mapValueOfType<String>(json, r'category_id'),
        goal: mapValueOfType<int>(json, r'goal'),
        link: mapValueOfType<String>(json, r'link'),
        priority: mapValueOfType<bool>(json, r'priority') ?? false,
        statusId: mapValueOfType<String>(json, r'status_id'),
      );
    }
    return null;
  }

  static List<InitiativeCreateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InitiativeCreateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InitiativeCreateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InitiativeCreateSchema> mapFromJson(dynamic json) {
    final map = <String, InitiativeCreateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InitiativeCreateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InitiativeCreateSchema-objects as value to a dart map
  static Map<String, List<InitiativeCreateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InitiativeCreateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InitiativeCreateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'action',
  };
}

