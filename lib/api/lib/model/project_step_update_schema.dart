//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ProjectStepUpdateSchema {
  /// Returns a new [ProjectStepUpdateSchema] instance.
  ProjectStepUpdateSchema({
    this.order,
    this.title,
    this.description,
    this.completed,
    this.statusId,
  });

  int? order;

  String? title;

  String? description;

  bool? completed;

  String? statusId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectStepUpdateSchema &&
    other.order == order &&
    other.title == title &&
    other.description == description &&
    other.completed == completed &&
    other.statusId == statusId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (order == null ? 0 : order!.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (completed == null ? 0 : completed!.hashCode) +
    (statusId == null ? 0 : statusId!.hashCode);

  @override
  String toString() => 'ProjectStepUpdateSchema[order=$order, title=$title, description=$description, completed=$completed, statusId=$statusId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.order != null) {
      json[r'order'] = this.order;
    } else {
      json[r'order'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.completed != null) {
      json[r'completed'] = this.completed;
    } else {
      json[r'completed'] = null;
    }
    if (this.statusId != null) {
      json[r'status_id'] = this.statusId;
    } else {
      json[r'status_id'] = null;
    }
    return json;
  }

  /// Returns a new [ProjectStepUpdateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectStepUpdateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectStepUpdateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectStepUpdateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectStepUpdateSchema(
        order: mapValueOfType<int>(json, r'order'),
        title: mapValueOfType<String>(json, r'title'),
        description: mapValueOfType<String>(json, r'description'),
        completed: mapValueOfType<bool>(json, r'completed'),
        statusId: mapValueOfType<String>(json, r'status_id'),
      );
    }
    return null;
  }

  static List<ProjectStepUpdateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectStepUpdateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectStepUpdateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectStepUpdateSchema> mapFromJson(dynamic json) {
    final map = <String, ProjectStepUpdateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectStepUpdateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectStepUpdateSchema-objects as value to a dart map
  static Map<String, List<ProjectStepUpdateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectStepUpdateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectStepUpdateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

