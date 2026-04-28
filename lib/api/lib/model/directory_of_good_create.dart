//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class DirectoryOfGoodCreate {
  /// Returns a new [DirectoryOfGoodCreate] instance.
  DirectoryOfGoodCreate({
    required this.name,
    this.focus,
    this.categoryIds = const [],
    this.imageUrl,
    this.location,
    this.socialLinks,
    this.featured = false,
  });

  String name;

  String? focus;

  List<String> categoryIds;

  String? imageUrl;

  LocationSchema? location;

  SocialLinksSchema? socialLinks;

  bool featured;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DirectoryOfGoodCreate &&
    other.name == name &&
    other.focus == focus &&
    _deepEquality.equals(other.categoryIds, categoryIds) &&
    other.imageUrl == imageUrl &&
    other.location == location &&
    other.socialLinks == socialLinks &&
    other.featured == featured;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (focus == null ? 0 : focus!.hashCode) +
    (categoryIds.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (socialLinks == null ? 0 : socialLinks!.hashCode) +
    (featured.hashCode);

  @override
  String toString() => 'DirectoryOfGoodCreate[name=$name, focus=$focus, categoryIds=$categoryIds, imageUrl=$imageUrl, location=$location, socialLinks=$socialLinks, featured=$featured]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
      json[r'featured'] = this.featured;
    return json;
  }

  /// Returns a new [DirectoryOfGoodCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DirectoryOfGoodCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DirectoryOfGoodCreate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DirectoryOfGoodCreate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DirectoryOfGoodCreate(
        name: mapValueOfType<String>(json, r'name')!,
        focus: mapValueOfType<String>(json, r'focus'),
        categoryIds: json[r'category_ids'] is Iterable
            ? (json[r'category_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        location: LocationSchema.fromJson(json[r'location']),
        socialLinks: SocialLinksSchema.fromJson(json[r'social_links']),
        featured: mapValueOfType<bool>(json, r'featured') ?? false,
      );
    }
    return null;
  }

  static List<DirectoryOfGoodCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DirectoryOfGoodCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DirectoryOfGoodCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DirectoryOfGoodCreate> mapFromJson(dynamic json) {
    final map = <String, DirectoryOfGoodCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DirectoryOfGoodCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DirectoryOfGoodCreate-objects as value to a dart map
  static Map<String, List<DirectoryOfGoodCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DirectoryOfGoodCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DirectoryOfGoodCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

