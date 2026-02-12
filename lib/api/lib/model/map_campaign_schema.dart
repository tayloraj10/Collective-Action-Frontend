//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapCampaignSchema {
  /// Returns a new [MapCampaignSchema] instance.
  MapCampaignSchema({
    required this.id,
    required this.title,
    required this.mapCampaignType,
    this.purpose,
    this.description,
    this.link,
    this.active = true,
    this.statusId,
    required this.createdBy,
  });

  String id;

  String title;

  String mapCampaignType;

  String? purpose;

  String? description;

  String? link;

  bool active;

  String? statusId;

  String createdBy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapCampaignSchema &&
    other.id == id &&
    other.title == title &&
    other.mapCampaignType == mapCampaignType &&
    other.purpose == purpose &&
    other.description == description &&
    other.link == link &&
    other.active == active &&
    other.statusId == statusId &&
    other.createdBy == createdBy;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (mapCampaignType.hashCode) +
    (purpose == null ? 0 : purpose!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (link == null ? 0 : link!.hashCode) +
    (active.hashCode) +
    (statusId == null ? 0 : statusId!.hashCode) +
    (createdBy.hashCode);

  @override
  String toString() => 'MapCampaignSchema[id=$id, title=$title, mapCampaignType=$mapCampaignType, purpose=$purpose, description=$description, link=$link, active=$active, statusId=$statusId, createdBy=$createdBy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'map_campaign_type'] = this.mapCampaignType;
    if (this.purpose != null) {
      json[r'purpose'] = this.purpose;
    } else {
      json[r'purpose'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.link != null) {
      json[r'link'] = this.link;
    } else {
      json[r'link'] = null;
    }
      json[r'active'] = this.active;
    if (this.statusId != null) {
      json[r'status_id'] = this.statusId;
    } else {
      json[r'status_id'] = null;
    }
      json[r'created_by'] = this.createdBy;
    return json;
  }

  /// Returns a new [MapCampaignSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapCampaignSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapCampaignSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapCampaignSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapCampaignSchema(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        mapCampaignType: mapValueOfType<String>(json, r'map_campaign_type')!,
        purpose: mapValueOfType<String>(json, r'purpose'),
        description: mapValueOfType<String>(json, r'description'),
        link: mapValueOfType<String>(json, r'link'),
        active: mapValueOfType<bool>(json, r'active') ?? true,
        statusId: mapValueOfType<String>(json, r'status_id'),
        createdBy: mapValueOfType<String>(json, r'created_by')!,
      );
    }
    return null;
  }

  static List<MapCampaignSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapCampaignSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapCampaignSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapCampaignSchema> mapFromJson(dynamic json) {
    final map = <String, MapCampaignSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapCampaignSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapCampaignSchema-objects as value to a dart map
  static Map<String, List<MapCampaignSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapCampaignSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapCampaignSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'map_campaign_type',
    'created_by',
  };
}

