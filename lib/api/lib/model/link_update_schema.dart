//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class LinkUpdateSchema {
  /// Returns a new [LinkUpdateSchema] instance.
  LinkUpdateSchema({
    this.projectId,
    this.initiativeId,
    this.mapCampaignId,
  });

  String? projectId;

  String? initiativeId;

  String? mapCampaignId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LinkUpdateSchema &&
    other.projectId == projectId &&
    other.initiativeId == initiativeId &&
    other.mapCampaignId == mapCampaignId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (projectId == null ? 0 : projectId!.hashCode) +
    (initiativeId == null ? 0 : initiativeId!.hashCode) +
    (mapCampaignId == null ? 0 : mapCampaignId!.hashCode);

  @override
  String toString() => 'LinkUpdateSchema[projectId=$projectId, initiativeId=$initiativeId, mapCampaignId=$mapCampaignId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.projectId != null) {
      json[r'project_id'] = this.projectId;
    } else {
      json[r'project_id'] = null;
    }
    if (this.initiativeId != null) {
      json[r'initiative_id'] = this.initiativeId;
    } else {
      json[r'initiative_id'] = null;
    }
    if (this.mapCampaignId != null) {
      json[r'map_campaign_id'] = this.mapCampaignId;
    } else {
      json[r'map_campaign_id'] = null;
    }
    return json;
  }

  /// Returns a new [LinkUpdateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LinkUpdateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LinkUpdateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LinkUpdateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LinkUpdateSchema(
        projectId: mapValueOfType<String>(json, r'project_id'),
        initiativeId: mapValueOfType<String>(json, r'initiative_id'),
        mapCampaignId: mapValueOfType<String>(json, r'map_campaign_id'),
      );
    }
    return null;
  }

  static List<LinkUpdateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LinkUpdateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LinkUpdateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LinkUpdateSchema> mapFromJson(dynamic json) {
    final map = <String, LinkUpdateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LinkUpdateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LinkUpdateSchema-objects as value to a dart map
  static Map<String, List<LinkUpdateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LinkUpdateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LinkUpdateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

