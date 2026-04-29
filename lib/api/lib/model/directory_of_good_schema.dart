//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class DirectoryOfGoodSchema {
  /// Returns a new [DirectoryOfGoodSchema] instance.
  DirectoryOfGoodSchema({
    this.id,
    required this.name,
    this.focus,
    this.categoryIds = const [],
    this.imageUrl,
    this.location,
    this.socialLinks,
    this.userId,
    this.featured = false,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  String? id;

  String name;

  String? focus;

  List<String> categoryIds;

  String? imageUrl;

  LocationSchema? location;

  SocialLinksSchema? socialLinks;

  String? userId;

  bool featured;

  num? latitude;

  num? longitude;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DirectoryOfGoodSchema &&
    other.id == id &&
    other.name == name &&
    other.focus == focus &&
    _deepEquality.equals(other.categoryIds, categoryIds) &&
    other.imageUrl == imageUrl &&
    other.location == location &&
    other.socialLinks == socialLinks &&
    other.userId == userId &&
    other.featured == featured &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (name.hashCode) +
    (focus == null ? 0 : focus!.hashCode) +
    (categoryIds.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (socialLinks == null ? 0 : socialLinks!.hashCode) +
    (userId == null ? 0 : userId!.hashCode) +
    (featured.hashCode) +
    (latitude == null ? 0 : latitude!.hashCode) +
    (longitude == null ? 0 : longitude!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() => 'DirectoryOfGoodSchema[id=$id, name=$name, focus=$focus, categoryIds=$categoryIds, imageUrl=$imageUrl, location=$location, socialLinks=$socialLinks, userId=$userId, featured=$featured, latitude=$latitude, longitude=$longitude, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
      json[r'name'] = this.name;
    if (this.focus != null) {
      json[r'focus'] = this.focus;
    } else {
      json[r'focus'] = null;
    }
      json[r'category_ids'] = this.categoryIds;
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
    if (this.location != null) {
      json[r'location'] = this.location;
    } else {
      json[r'location'] = null;
    }
    if (this.socialLinks != null) {
      json[r'social_links'] = this.socialLinks;
    } else {
      json[r'social_links'] = null;
    }
    if (this.userId != null) {
      json[r'user_id'] = this.userId;
    } else {
      json[r'user_id'] = null;
    }
      json[r'featured'] = this.featured;
    if (this.latitude != null) {
      json[r'latitude'] = this.latitude;
    } else {
      json[r'latitude'] = null;
    }
    if (this.longitude != null) {
      json[r'longitude'] = this.longitude;
    } else {
      json[r'longitude'] = null;
    }
    if (this.createdAt != null) {
      json[r'created_at'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'created_at'] = null;
    }
    if (this.updatedAt != null) {
      json[r'updated_at'] = this.updatedAt!.toUtc().toIso8601String();
    } else {
      json[r'updated_at'] = null;
    }
    return json;
  }

  /// Returns a new [DirectoryOfGoodSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DirectoryOfGoodSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DirectoryOfGoodSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DirectoryOfGoodSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DirectoryOfGoodSchema(
        id: mapValueOfType<String>(json, r'id'),
        name: mapValueOfType<String>(json, r'name')!,
        focus: mapValueOfType<String>(json, r'focus'),
        categoryIds: json[r'category_ids'] is Iterable
            ? (json[r'category_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        location: LocationSchema.fromJson(json[r'location']),
        socialLinks: SocialLinksSchema.fromJson(json[r'social_links']),
        userId: mapValueOfType<String>(json, r'user_id'),
        featured: mapValueOfType<bool>(json, r'featured') ?? false,
        latitude: json[r'latitude'] == null
            ? null
            : num.parse('${json[r'latitude']}'),
        longitude: json[r'longitude'] == null
            ? null
            : num.parse('${json[r'longitude']}'),
        createdAt: mapDateTime(json, r'created_at', r''),
        updatedAt: mapDateTime(json, r'updated_at', r''),
      );
    }
    return null;
  }

  static List<DirectoryOfGoodSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DirectoryOfGoodSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DirectoryOfGoodSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DirectoryOfGoodSchema> mapFromJson(dynamic json) {
    final map = <String, DirectoryOfGoodSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DirectoryOfGoodSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DirectoryOfGoodSchema-objects as value to a dart map
  static Map<String, List<DirectoryOfGoodSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DirectoryOfGoodSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DirectoryOfGoodSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

