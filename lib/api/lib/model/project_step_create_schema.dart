//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ProjectStepCreateSchema {
  /// Returns a new [ProjectStepCreateSchema] instance.
  ProjectStepCreateSchema({
    this.order = 0,
    required this.title,
    this.description,
    this.completed = false,
    this.statusId,
  });

  int order;

  String title;

  String? description;

  bool completed;

  String? statusId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectStepCreateSchema &&
    other.order == order &&
    other.title == title &&
    other.description == description &&
    other.completed == completed &&
    other.statusId == statusId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (order.hashCode) +
    (title.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (completed.hashCode) +
    (statusId == null ? 0 : statusId!.hashCode);

  @override
  String toString() => 'ProjectStepCreateSchema[order=$order, title=$title, description=$description, completed=$completed, statusId=$statusId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'order'] = this.order;
      json[r'title'] = this.title;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'completed'] = this.completed;
    if (this.statusId != null) {
      json[r'status_id'] = this.statusId;
    } else {
      json[r'status_id'] = null;
    }
    return json;
  }

  /// Returns a new [ProjectStepCreateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectStepCreateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectStepCreateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectStepCreateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectStepCreateSchema(
        order: mapValueOfType<int>(json, r'order') ?? 0,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description'),
        completed: mapValueOfType<bool>(json, r'completed') ?? false,
        statusId: mapValueOfType<String>(json, r'status_id'),
      );
    }
    return null;
  }

  static List<ProjectStepCreateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectStepCreateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectStepCreateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectStepCreateSchema> mapFromJson(dynamic json) {
    final map = <String, ProjectStepCreateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectStepCreateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectStepCreateSchema-objects as value to a dart map
  static Map<String, List<ProjectStepCreateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectStepCreateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectStepCreateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
  };
}

