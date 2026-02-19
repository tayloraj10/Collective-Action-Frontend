//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class DirectoryOfGoodUpdate {
  /// Returns a new [DirectoryOfGoodUpdate] instance.
  DirectoryOfGoodUpdate({
    this.name,
    this.focus,
    this.categoryId,
    this.imageUrl,
    this.location,
    this.socialLinks,
  });

  String? name;

  String? focus;

  String? categoryId;

  String? imageUrl;

  LocationSchema? location;

  SocialLinksSchema? socialLinks;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DirectoryOfGoodUpdate &&
    other.name == name &&
    other.focus == focus &&
    other.categoryId == categoryId &&
    other.imageUrl == imageUrl &&
    other.location == location &&
    other.socialLinks == socialLinks;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (focus == null ? 0 : focus!.hashCode) +
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (socialLinks == null ? 0 : socialLinks!.hashCode);

  @override
  String toString() => 'DirectoryOfGoodUpdate[name=$name, focus=$focus, categoryId=$categoryId, imageUrl=$imageUrl, location=$location, socialLinks=$socialLinks]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.focus != null) {
      json[r'focus'] = this.focus;
    } else {
      json[r'focus'] = null;
    }
    if (this.categoryId != null) {
      json[r'category_id'] = this.categoryId;
    } else {
      json[r'category_id'] = null;
    }
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
    return json;
  }

  /// Returns a new [DirectoryOfGoodUpdate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DirectoryOfGoodUpdate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DirectoryOfGoodUpdate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DirectoryOfGoodUpdate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DirectoryOfGoodUpdate(
        name: mapValueOfType<String>(json, r'name'),
        focus: mapValueOfType<String>(json, r'focus'),
        categoryId: mapValueOfType<String>(json, r'category_id'),
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        location: LocationSchema.fromJson(json[r'location']),
        socialLinks: SocialLinksSchema.fromJson(json[r'social_links']),
      );
    }
    return null;
  }

  static List<DirectoryOfGoodUpdate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DirectoryOfGoodUpdate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DirectoryOfGoodUpdate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DirectoryOfGoodUpdate> mapFromJson(dynamic json) {
    final map = <String, DirectoryOfGoodUpdate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DirectoryOfGoodUpdate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DirectoryOfGoodUpdate-objects as value to a dart map
  static Map<String, List<DirectoryOfGoodUpdate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DirectoryOfGoodUpdate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DirectoryOfGoodUpdate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

