/// Granularity of a map area (borough, neighborhood, city, town, etc.).
enum MapAreaType {
  borough('borough'),
  neighborhood('neighborhood'),
  city('city'),
  town('town'),
  region('region'),
  custom('custom');

  const MapAreaType(this.value);
  final String value;

  static MapAreaType? fromValue(String? value) {
    if (value == null) return null;
    for (final t in MapAreaType.values) {
      if (t.value == value) return t;
    }
    return null;
  }

  String get label {
    switch (this) {
      case MapAreaType.borough:
        return 'Borough';
      case MapAreaType.neighborhood:
        return 'Neighborhood';
      case MapAreaType.city:
        return 'City';
      case MapAreaType.town:
        return 'Town';
      case MapAreaType.region:
        return 'Region';
      case MapAreaType.custom:
        return 'Custom';
    }
  }
}

class MapAreaBounds {
  MapAreaBounds({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
  });

  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;

  factory MapAreaBounds.fromJson(Map<String, dynamic> json) {
    return MapAreaBounds(
      minLat: (json['min_lat'] as num).toDouble(),
      maxLat: (json['max_lat'] as num).toDouble(),
      minLng: (json['min_lng'] as num).toDouble(),
      maxLng: (json['max_lng'] as num).toDouble(),
    );
  }

  bool contains(double latitude, double longitude) {
    return latitude >= minLat &&
        latitude <= maxLat &&
        longitude >= minLng &&
        longitude <= maxLng;
  }
}

class MapAreaModel {
  MapAreaModel({
    required this.id,
    required this.mapCampaignId,
    required this.name,
    required this.areaType,
    this.slug,
    this.parentAreaId,
    this.bounds,
    required this.sortOrder,
    required this.active,
  });

  final String id;
  final String mapCampaignId;
  final String name;
  final String areaType;
  final String? slug;
  final String? parentAreaId;
  final MapAreaBounds? bounds;
  final int sortOrder;
  final bool active;

  MapAreaType? get areaTypeEnum => MapAreaType.fromValue(areaType);

  factory MapAreaModel.fromJson(Map<String, dynamic> json) {
    final boundsJson = json['bounds'];
    return MapAreaModel(
      id: json['id'] as String,
      mapCampaignId: json['map_campaign_id'] as String,
      name: json['name'] as String,
      areaType: json['area_type'] as String,
      slug: json['slug'] as String?,
      parentAreaId: json['parent_area_id'] as String?,
      bounds: boundsJson is Map<String, dynamic>
          ? MapAreaBounds.fromJson(boundsJson)
          : null,
      sortOrder: json['sort_order'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }
}

class AreaCaptainModel {
  AreaCaptainModel({
    required this.id,
    required this.mapAreaId,
    required this.captainUserId,
    this.assignedByUserId,
    required this.createdAt,
    required this.updatedAt,
    this.area,
  });

  final String id;
  final String mapAreaId;
  final String captainUserId;
  final String? assignedByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MapAreaModel? area;

  factory AreaCaptainModel.fromJson(Map<String, dynamic> json) {
    final areaJson = json['area'];
    return AreaCaptainModel(
      id: json['id'] as String,
      mapAreaId: json['map_area_id'] as String,
      captainUserId: json['captain_user_id'] as String,
      assignedByUserId: json['assigned_by_user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      area: areaJson is Map<String, dynamic>
          ? MapAreaModel.fromJson(areaJson)
          : null,
    );
  }
}

class MapHotspotModel {
  MapHotspotModel({
    required this.id,
    required this.mapCampaignId,
    required this.mapAreaId,
    required this.title,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.area,
  });

  final String id;
  final String mapCampaignId;
  final String mapAreaId;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MapAreaModel? area;

  String get areaName => area?.name ?? 'Unknown area';

  factory MapHotspotModel.fromJson(Map<String, dynamic> json) {
    final areaJson = json['area'];
    return MapHotspotModel(
      id: json['id'] as String,
      mapCampaignId: json['map_campaign_id'] as String,
      mapAreaId: json['map_area_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdBy: json['created_by'] as String,
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      area: areaJson is Map<String, dynamic>
          ? MapAreaModel.fromJson(areaJson)
          : null,
    );
  }
}
