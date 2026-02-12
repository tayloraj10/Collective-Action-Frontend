//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ProjectSchema {
  /// Returns a new [ProjectSchema] instance.
  ProjectSchema({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    this.statusId,
    required this.creatorId,
    this.active = true,
    this.members,
    this.steps = const [],
    this.links = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  String id;

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

  List<ProjectStepSchema> steps;

  List<ProjectLinkSchema> links;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectSchema &&
    other.id == id &&
    other.name == name &&
    other.description == description &&
    other.categoryId == categoryId &&
    other.statusId == statusId &&
    other.creatorId == creatorId &&
    other.active == active &&
    other.members == members &&
    _deepEquality.equals(other.steps, steps) &&
    _deepEquality.equals(other.links, links) &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (statusId == null ? 0 : statusId!.hashCode) +
    (creatorId.hashCode) +
    (active.hashCode) +
    (members == null ? 0 : members!.hashCode) +
    (steps.hashCode) +
    (links.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'ProjectSchema[id=$id, name=$name, description=$description, categoryId=$categoryId, statusId=$statusId, creatorId=$creatorId, active=$active, members=$members, steps=$steps, links=$links, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
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
      json[r'links'] = this.links;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ProjectSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectSchema(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description'),
        categoryId: mapValueOfType<String>(json, r'category_id'),
        statusId: mapValueOfType<String>(json, r'status_id'),
        creatorId: mapValueOfType<String>(json, r'creator_id')!,
        active: mapValueOfType<bool>(json, r'active') ?? true,
        members: MemberIdsByRole.fromJson(json[r'members']),
        steps: ProjectStepSchema.listFromJson(json[r'steps']),
        links: ProjectLinkSchema.listFromJson(json[r'links']),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<ProjectSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectSchema> mapFromJson(dynamic json) {
    final map = <String, ProjectSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectSchema-objects as value to a dart map
  static Map<String, List<ProjectSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'creator_id',
    'created_at',
    'updated_at',
  };
}

