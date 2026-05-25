//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapAreaSchema {
  /// Returns a new [MapAreaSchema] instance.
  MapAreaSchema({
    required this.id,
    required this.mapCampaignId,
    required this.name,
    required this.areaType,
    this.slug,
    this.parentAreaId,
    this.bounds,
    this.sortOrder = 0,
    this.active = true,
  });

  String id;

  String mapCampaignId;

  String name;

  String areaType;

  String? slug;

  String? parentAreaId;

  MapAreaBoundsSchema? bounds;

  int sortOrder;

  bool active;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapAreaSchema &&
    other.id == id &&
    other.mapCampaignId == mapCampaignId &&
    other.name == name &&
    other.areaType == areaType &&
    other.slug == slug &&
    other.parentAreaId == parentAreaId &&
    other.bounds == bounds &&
    other.sortOrder == sortOrder &&
    other.active == active;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (mapCampaignId.hashCode) +
    (name.hashCode) +
    (areaType.hashCode) +
    (slug == null ? 0 : slug!.hashCode) +
    (parentAreaId == null ? 0 : parentAreaId!.hashCode) +
    (bounds == null ? 0 : bounds!.hashCode) +
    (sortOrder.hashCode) +
    (active.hashCode);

  @override
  String toString() => 'MapAreaSchema[id=$id, mapCampaignId=$mapCampaignId, name=$name, areaType=$areaType, slug=$slug, parentAreaId=$parentAreaId, bounds=$bounds, sortOrder=$sortOrder, active=$active]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
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
      json[r'active'] = this.active;
    return json;
  }

  /// Returns a new [MapAreaSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapAreaSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapAreaSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapAreaSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapAreaSchema(
        id: mapValueOfType<String>(json, r'id')!,
        mapCampaignId: mapValueOfType<String>(json, r'map_campaign_id')!,
        name: mapValueOfType<String>(json, r'name')!,
        areaType: mapValueOfType<String>(json, r'area_type')!,
        slug: mapValueOfType<String>(json, r'slug'),
        parentAreaId: mapValueOfType<String>(json, r'parent_area_id'),
        bounds: MapAreaBoundsSchema.fromJson(json[r'bounds']),
        sortOrder: mapValueOfType<int>(json, r'sort_order') ?? 0,
        active: mapValueOfType<bool>(json, r'active') ?? true,
      );
    }
    return null;
  }

  static List<MapAreaSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapAreaSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapAreaSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapAreaSchema> mapFromJson(dynamic json) {
    final map = <String, MapAreaSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapAreaSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapAreaSchema-objects as value to a dart map
  static Map<String, List<MapAreaSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapAreaSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapAreaSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'map_campaign_id',
    'name',
    'area_type',
  };
}

