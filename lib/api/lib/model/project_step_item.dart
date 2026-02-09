//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ProjectStepItem {
  /// Returns a new [ProjectStepItem] instance.
  ProjectStepItem({
    this.order = 0,
    required this.title,
    this.description,
    this.completed = false,
    this.status,
  });

  int order;

  String title;

  String? description;

  bool completed;

  StatusValuesEnum? status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectStepItem &&
    other.order == order &&
    other.title == title &&
    other.description == description &&
    other.completed == completed &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (order.hashCode) +
    (title.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (completed.hashCode) +
    (status == null ? 0 : status!.hashCode);

  @override
  String toString() => 'ProjectStepItem[order=$order, title=$title, description=$description, completed=$completed, status=$status]';

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
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    return json;
  }

  /// Returns a new [ProjectStepItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectStepItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectStepItem[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectStepItem[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectStepItem(
        order: mapValueOfType<int>(json, r'order') ?? 0,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description'),
        completed: mapValueOfType<bool>(json, r'completed') ?? false,
        status: StatusValuesEnum.fromJson(json[r'status']),
      );
    }
    return null;
  }

  static List<ProjectStepItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectStepItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectStepItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectStepItem> mapFromJson(dynamic json) {
    final map = <String, ProjectStepItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectStepItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectStepItem-objects as value to a dart map
  static Map<String, List<ProjectStepItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectStepItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectStepItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
  };
}

