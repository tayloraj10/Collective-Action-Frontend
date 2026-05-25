//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapHotspotSchema {
  /// Returns a new [MapHotspotSchema] instance.
  MapHotspotSchema({
    required this.id,
    required this.mapCampaignId,
    required this.mapAreaId,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
    this.area,
  });

  String id;

  String mapCampaignId;

  String mapAreaId;

  String title;

  String? description;

  num latitude;

  num longitude;

  String createdBy;

  bool active;

  DateTime createdAt;

  DateTime updatedAt;

  MapAreaSchema? area;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapHotspotSchema &&
    other.id == id &&
    other.mapCampaignId == mapCampaignId &&
    other.mapAreaId == mapAreaId &&
    other.title == title &&
    other.description == description &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    other.createdBy == createdBy &&
    other.active == active &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.area == area;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (mapCampaignId.hashCode) +
    (mapAreaId.hashCode) +
    (title.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (latitude.hashCode) +
    (longitude.hashCode) +
    (createdBy.hashCode) +
    (active.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode) +
    (area == null ? 0 : area!.hashCode);

  @override
  String toString() => 'MapHotspotSchema[id=$id, mapCampaignId=$mapCampaignId, mapAreaId=$mapAreaId, title=$title, description=$description, latitude=$latitude, longitude=$longitude, createdBy=$createdBy, active=$active, createdAt=$createdAt, updatedAt=$updatedAt, area=$area]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
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
      json[r'active'] = this.active;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    if (this.area != null) {
      json[r'area'] = this.area;
    } else {
      json[r'area'] = null;
    }
    return json;
  }

  /// Returns a new [MapHotspotSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapHotspotSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapHotspotSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapHotspotSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapHotspotSchema(
        id: mapValueOfType<String>(json, r'id')!,
        mapCampaignId: mapValueOfType<String>(json, r'map_campaign_id')!,
        mapAreaId: mapValueOfType<String>(json, r'map_area_id')!,
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description'),
        latitude: num.parse('${json[r'latitude']}'),
        longitude: num.parse('${json[r'longitude']}'),
        createdBy: mapValueOfType<String>(json, r'created_by')!,
        active: mapValueOfType<bool>(json, r'active') ?? true,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        area: MapAreaSchema.fromJson(json[r'area']),
      );
    }
    return null;
  }

  static List<MapHotspotSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapHotspotSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapHotspotSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapHotspotSchema> mapFromJson(dynamic json) {
    final map = <String, MapHotspotSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapHotspotSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapHotspotSchema-objects as value to a dart map
  static Map<String, List<MapHotspotSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapHotspotSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapHotspotSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'map_campaign_id',
    'map_area_id',
    'title',
    'latitude',
    'longitude',
    'created_by',
    'created_at',
    'updated_at',
  };
}

