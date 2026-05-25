//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapHotspotCreateSchema {
  /// Returns a new [MapHotspotCreateSchema] instance.
  MapHotspotCreateSchema({
    required this.mapCampaignId,
    required this.mapAreaId,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
  });

  String mapCampaignId;

  String mapAreaId;

  String title;

  String? description;

  num latitude;

  num longitude;

  String createdBy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapHotspotCreateSchema &&
    other.mapCampaignId == mapCampaignId &&
    other.mapAreaId == mapAreaId &&
    other.title == title &&
    other.description == description &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    other.createdBy == createdBy;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (mapCampaignId.hashCode) +
    (mapAreaId.hashCode) +
    (title.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (latitude.hashCode) +
    (longitude.hashCode) +
    (createdBy.hashCode);

  @override
  String toString() => 'MapHotspotCreateSchema[mapCampaignId=$mapCampaignId, mapAreaId=$mapAreaId, title=$title, description=$description, latitude=$latitude, longitude=$longitude, createdBy=$createdBy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'map_campaign_id'] = this.mapCampaignId;
      json[r'map_area_id'] = this.mapAreaId;
      json[r'title'] = this.title;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'latitude'] = this.latitude;
      json[r'longitude'] = this.longitude;
      json[r'created_by'] = this.createdBy;
    return json;
  }

  /// Returns a new [MapHotspotCreateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapHotspotCreateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapHotspotCreateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapHotspotCreateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapHotspotCreateSchema(
        mapCampaignId: mapValueOfType<String>(json, r'map_campaign_id')!,
        mapAreaId: mapValueOfType<String>(json, r'map_area_id')!,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description'),
        latitude: num.parse('${json[r'latitude']}'),
        longitude: num.parse('${json[r'longitude']}'),
        createdBy: mapValueOfType<String>(json, r'created_by')!,
      );
    }
    return null;
  }

  static List<MapHotspotCreateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapHotspotCreateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapHotspotCreateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapHotspotCreateSchema> mapFromJson(dynamic json) {
    final map = <String, MapHotspotCreateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapHotspotCreateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapHotspotCreateSchema-objects as value to a dart map
  static Map<String, List<MapHotspotCreateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapHotspotCreateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapHotspotCreateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'map_campaign_id',
    'map_area_id',
    'title',
    'latitude',
    'longitude',
    'created_by',
  };
}

