//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapAreaCreateSchema {
  /// Returns a new [MapAreaCreateSchema] instance.
  MapAreaCreateSchema({
    required this.mapCampaignId,
    required this.name,
    required this.areaType,
    this.slug,
    this.parentAreaId,
    this.bounds,
    this.sortOrder = 0,
    required this.actingUserId,
  });

  String mapCampaignId;

  String name;

  MapAreaTypeEnum areaType;

  String? slug;

  String? parentAreaId;

  MapAreaBoundsSchema? bounds;

  int sortOrder;

  String actingUserId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapAreaCreateSchema &&
    other.mapCampaignId == mapCampaignId &&
    other.name == name &&
    other.areaType == areaType &&
    other.slug == slug &&
    other.parentAreaId == parentAreaId &&
    other.bounds == bounds &&
    other.sortOrder == sortOrder &&
    other.actingUserId == actingUserId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (mapCampaignId.hashCode) +
    (name.hashCode) +
    (areaType.hashCode) +
    (slug == null ? 0 : slug!.hashCode) +
    (parentAreaId == null ? 0 : parentAreaId!.hashCode) +
    (bounds == null ? 0 : bounds!.hashCode) +
    (sortOrder.hashCode) +
    (actingUserId.hashCode);

  @override
  String toString() => 'MapAreaCreateSchema[mapCampaignId=$mapCampaignId, name=$name, areaType=$areaType, slug=$slug, parentAreaId=$parentAreaId, bounds=$bounds, sortOrder=$sortOrder, actingUserId=$actingUserId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'map_campaign_id'] = this.mapCampaignId;
      json[r'name'] = this.name;
      json[r'area_type'] = this.areaType;
    if (this.slug != null) {
      json[r'slug'] = this.slug;
    } else {
      json[r'slug'] = null;
    }
    if (this.parentAreaId != null) {
      json[r'parent_area_id'] = this.parentAreaId;
    } else {
      json[r'parent_area_id'] = null;
    }
    if (this.bounds != null) {
      json[r'bounds'] = this.bounds;
    } else {
      json[r'bounds'] = null;
    }
      json[r'sort_order'] = this.sortOrder;
      json[r'acting_user_id'] = this.actingUserId;
    return json;
  }

  /// Returns a new [MapAreaCreateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapAreaCreateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapAreaCreateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapAreaCreateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapAreaCreateSchema(
        mapCampaignId: mapValueOfType<String>(json, r'map_campaign_id')!,
        name: mapValueOfType<String>(json, r'name')!,
        areaType: MapAreaTypeEnum.fromJson(json[r'area_type'])!,
        slug: mapValueOfType<String>(json, r'slug'),
        parentAreaId: mapValueOfType<String>(json, r'parent_area_id'),
        bounds: MapAreaBoundsSchema.fromJson(json[r'bounds']),
        sortOrder: mapValueOfType<int>(json, r'sort_order') ?? 0,
        actingUserId: mapValueOfType<String>(json, r'acting_user_id')!,
      );
    }
    return null;
  }

  static List<MapAreaCreateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapAreaCreateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapAreaCreateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapAreaCreateSchema> mapFromJson(dynamic json) {
    final map = <String, MapAreaCreateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapAreaCreateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapAreaCreateSchema-objects as value to a dart map
  static Map<String, List<MapAreaCreateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapAreaCreateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapAreaCreateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'map_campaign_id',
    'name',
    'area_type',
    'acting_user_id',
  };
}

