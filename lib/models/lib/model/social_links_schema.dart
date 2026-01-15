//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SocialLinksSchema {
  /// Returns a new [SocialLinksSchema] instance.
  SocialLinksSchema({
    this.youtube,
    this.instagram,
    this.tiktok,
    this.website,
  });

  String? youtube;

  String? instagram;

  String? tiktok;

  String? website;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SocialLinksSchema &&
    other.youtube == youtube &&
    other.instagram == instagram &&
    other.tiktok == tiktok &&
    other.website == website;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (youtube == null ? 0 : youtube!.hashCode) +
    (instagram == null ? 0 : instagram!.hashCode) +
    (tiktok == null ? 0 : tiktok!.hashCode) +
    (website == null ? 0 : website!.hashCode);

  @override
  String toString() => 'SocialLinksSchema[youtube=$youtube, instagram=$instagram, tiktok=$tiktok, website=$website]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.youtube != null) {
      json[r'youtube'] = this.youtube;
    } else {
      json[r'youtube'] = null;
    }
    if (this.instagram != null) {
      json[r'instagram'] = this.instagram;
    } else {
      json[r'instagram'] = null;
    }
    if (this.tiktok != null) {
      json[r'tiktok'] = this.tiktok;
    } else {
      json[r'tiktok'] = null;
    }
    if (this.website != null) {
      json[r'website'] = this.website;
    } else {
      json[r'website'] = null;
    }
    return json;
  }

  /// Returns a new [SocialLinksSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SocialLinksSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SocialLinksSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SocialLinksSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SocialLinksSchema(
        youtube: mapValueOfType<String>(json, r'youtube'),
        instagram: mapValueOfType<String>(json, r'instagram'),
        tiktok: mapValueOfType<String>(json, r'tiktok'),
        website: mapValueOfType<String>(json, r'website'),
      );
    }
    return null;
  }

  static List<SocialLinksSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SocialLinksSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SocialLinksSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SocialLinksSchema> mapFromJson(dynamic json) {
    final map = <String, SocialLinksSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SocialLinksSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SocialLinksSchema-objects as value to a dart map
  static Map<String, List<SocialLinksSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SocialLinksSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SocialLinksSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

