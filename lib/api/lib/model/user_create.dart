//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class UserCreate {
  /// Returns a new [UserCreate] instance.
  UserCreate({
    required this.email,
    this.name,
    this.photoUrl,
    this.userType,
    this.isActive,
    this.location,
    this.socialLinks,
    this.firebaseUserId,
  });

  String email;

  String? name;

  String? photoUrl;

  UserType? userType;

  bool? isActive;

  LocationSchema? location;

  SocialLinksSchema? socialLinks;

  String? firebaseUserId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserCreate &&
    other.email == email &&
    other.name == name &&
    other.photoUrl == photoUrl &&
    other.userType == userType &&
    other.isActive == isActive &&
    other.location == location &&
    other.socialLinks == socialLinks &&
    other.firebaseUserId == firebaseUserId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (email.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (photoUrl == null ? 0 : photoUrl!.hashCode) +
    (userType == null ? 0 : userType!.hashCode) +
    (isActive == null ? 0 : isActive!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (socialLinks == null ? 0 : socialLinks!.hashCode) +
    (firebaseUserId == null ? 0 : firebaseUserId!.hashCode);

  @override
  String toString() => 'UserCreate[email=$email, name=$name, photoUrl=$photoUrl, userType=$userType, isActive=$isActive, location=$location, socialLinks=$socialLinks, firebaseUserId=$firebaseUserId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'email'] = this.email;
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.photoUrl != null) {
      json[r'photo_url'] = this.photoUrl;
    } else {
      json[r'photo_url'] = null;
    }
    if (this.userType != null) {
      json[r'user_type'] = this.userType;
    } else {
      json[r'user_type'] = null;
    }
    if (this.isActive != null) {
      json[r'is_active'] = this.isActive;
    } else {
      json[r'is_active'] = null;
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
    if (this.firebaseUserId != null) {
      json[r'firebase_user_id'] = this.firebaseUserId;
    } else {
      json[r'firebase_user_id'] = null;
    }
    return json;
  }

  /// Returns a new [UserCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserCreate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserCreate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserCreate(
        email: mapValueOfType<String>(json, r'email')!,
        name: mapValueOfType<String>(json, r'name'),
        photoUrl: mapValueOfType<String>(json, r'photo_url'),
        userType: UserType.fromJson(json[r'user_type']),
        isActive: mapValueOfType<bool>(json, r'is_active'),
        location: LocationSchema.fromJson(json[r'location']),
        socialLinks: SocialLinksSchema.fromJson(json[r'social_links']),
        firebaseUserId: mapValueOfType<String>(json, r'firebase_user_id'),
      );
    }
    return null;
  }

  static List<UserCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserCreate> mapFromJson(dynamic json) {
    final map = <String, UserCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserCreate-objects as value to a dart map
  static Map<String, List<UserCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'email',
  };
}

