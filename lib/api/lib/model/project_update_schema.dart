//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ProjectUpdateSchema {
  /// Returns a new [ProjectUpdateSchema] instance.
  ProjectUpdateSchema({
    this.name,
    this.description,
    this.categoryId,
    this.statusId,
    this.active,
    this.members,
    this.steps = const [],
  });

  String? name;

  String? description;

  String? categoryId;

  String? statusId;

  bool? active;

  MemberIdsByRole? members;

  List<ProjectStepCreateSchema>? steps;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectUpdateSchema &&
    other.name == name &&
    other.description == description &&
    other.categoryId == categoryId &&
    other.statusId == statusId &&
    other.active == active &&
    other.members == members &&
    _deepEquality.equals(other.steps, steps);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (statusId == null ? 0 : statusId!.hashCode) +
    (active == null ? 0 : active!.hashCode) +
    (members == null ? 0 : members!.hashCode) +
    (steps == null ? 0 : steps!.hashCode);

  @override
  String toString() => 'ProjectUpdateSchema[name=$name, description=$description, categoryId=$categoryId, statusId=$statusId, active=$active, members=$members, steps=$steps]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.categoryId != null) {
      json[r'category_id'] = this.categoryId;
    } else {
      json[r'category_id'] = null;
    }
    if (this.statusId != null) {
      json[r'status_id'] = this.statusId;
    } else {
      json[r'status_id'] = null;
    }
    if (this.active != null) {
      json[r'active'] = this.active;
    } else {
      json[r'active'] = null;
    }
    if (this.members != null) {
      json[r'members'] = this.members;
    } else {
      json[r'members'] = null;
    }
    if (this.steps != null) {
      json[r'steps'] = this.steps;
    } else {
      json[r'steps'] = null;
    }
    return json;
  }

  /// Returns a new [ProjectUpdateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectUpdateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectUpdateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectUpdateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectUpdateSchema(
        name: mapValueOfType<String>(json, r'name'),
        description: mapValueOfType<String>(json, r'description'),
        categoryId: mapValueOfType<String>(json, r'category_id'),
        statusId: mapValueOfType<String>(json, r'status_id'),
        active: mapValueOfType<bool>(json, r'active'),
        members: MemberIdsByRole.fromJson(json[r'members']),
        steps: ProjectStepCreateSchema.listFromJson(json[r'steps']),
      );
    }
    return null;
  }

  static List<ProjectUpdateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectUpdateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectUpdateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectUpdateSchema> mapFromJson(dynamic json) {
    final map = <String, ProjectUpdateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectUpdateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectUpdateSchema-objects as value to a dart map
  static Map<String, List<ProjectUpdateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectUpdateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectUpdateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

