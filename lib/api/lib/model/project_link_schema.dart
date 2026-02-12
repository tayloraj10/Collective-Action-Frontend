//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ProjectLinkSchema {
  /// Returns a new [ProjectLinkSchema] instance.
  ProjectLinkSchema({
    required this.id,
    required this.projectId,
    required this.initiativeId,
  });

  String id;

  String projectId;

  String initiativeId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectLinkSchema &&
    other.id == id &&
    other.projectId == projectId &&
    other.initiativeId == initiativeId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (projectId.hashCode) +
    (initiativeId.hashCode);

  @override
  String toString() => 'ProjectLinkSchema[id=$id, projectId=$projectId, initiativeId=$initiativeId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'project_id'] = this.projectId;
      json[r'initiative_id'] = this.initiativeId;
    return json;
  }

  /// Returns a new [ProjectLinkSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectLinkSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectLinkSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectLinkSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectLinkSchema(
        id: mapValueOfType<String>(json, r'id')!,
        projectId: mapValueOfType<String>(json, r'project_id')!,
        initiativeId: mapValueOfType<String>(json, r'initiative_id')!,
      );
    }
    return null;
  }

  static List<ProjectLinkSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectLinkSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectLinkSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectLinkSchema> mapFromJson(dynamic json) {
    final map = <String, ProjectLinkSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectLinkSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectLinkSchema-objects as value to a dart map
  static Map<String, List<ProjectLinkSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectLinkSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectLinkSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'project_id',
    'initiative_id',
  };
}

