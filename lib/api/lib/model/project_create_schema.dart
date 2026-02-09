//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ProjectCreateSchema {
  /// Returns a new [ProjectCreateSchema] instance.
  ProjectCreateSchema({
    required this.name,
    this.description,
    this.categoryId,
    this.statusId,
    required this.creatorId,
    this.active = true,
    this.members,
    this.steps = const [],
    this.linkedIds = const [],
  });

  String name;

  String? description;

  String? categoryId;

  String? statusId;

  String creatorId;

  bool active;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MemberIdsByRole? members;

  List<ProjectStepItem> steps;

  List<String> linkedIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectCreateSchema &&
    other.name == name &&
    other.description == description &&
    other.categoryId == categoryId &&
    other.statusId == statusId &&
    other.creatorId == creatorId &&
    other.active == active &&
    other.members == members &&
    _deepEquality.equals(other.steps, steps) &&
    _deepEquality.equals(other.linkedIds, linkedIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (statusId == null ? 0 : statusId!.hashCode) +
    (creatorId.hashCode) +
    (active.hashCode) +
    (members == null ? 0 : members!.hashCode) +
    (steps.hashCode) +
    (linkedIds.hashCode);

  @override
  String toString() => 'ProjectCreateSchema[name=$name, description=$description, categoryId=$categoryId, statusId=$statusId, creatorId=$creatorId, active=$active, members=$members, steps=$steps, linkedIds=$linkedIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
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
      json[r'creator_id'] = this.creatorId;
      json[r'active'] = this.active;
    if (this.members != null) {
      json[r'members'] = this.members;
    } else {
      json[r'members'] = null;
    }
      json[r'steps'] = this.steps;
      json[r'linked_ids'] = this.linkedIds;
    return json;
  }

  /// Returns a new [ProjectCreateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectCreateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectCreateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectCreateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectCreateSchema(
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description'),
        categoryId: mapValueOfType<String>(json, r'category_id'),
        statusId: mapValueOfType<String>(json, r'status_id'),
        creatorId: mapValueOfType<String>(json, r'creator_id')!,
        active: mapValueOfType<bool>(json, r'active') ?? true,
        members: MemberIdsByRole.fromJson(json[r'members']),
        steps: ProjectStepItem.listFromJson(json[r'steps']),
        linkedIds: json[r'linked_ids'] is Iterable
            ? (json[r'linked_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ProjectCreateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectCreateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectCreateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectCreateSchema> mapFromJson(dynamic json) {
    final map = <String, ProjectCreateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectCreateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectCreateSchema-objects as value to a dart map
  static Map<String, List<ProjectCreateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectCreateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectCreateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'creator_id',
  };
}

