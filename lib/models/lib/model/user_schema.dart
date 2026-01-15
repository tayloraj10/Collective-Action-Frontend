//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserSchema {
  /// Returns a new [UserSchema] instance.
  UserSchema({
    this.id,
    this.email,
    this.name,
    this.photoUrl,
    this.userType,
    this.isActive,
    this.location,
    this.socialLinks,
    this.firebaseUserId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;

  String? email;

  String? name;

  String? photoUrl;

  UserType? userType;

  bool? isActive;

  LocationSchema? location;

  SocialLinksSchema? socialLinks;

  String? firebaseUserId;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserSchema &&
    other.id == id &&
    other.email == email &&
    other.name == name &&
    other.photoUrl == photoUrl &&
    other.userType == userType &&
    other.isActive == isActive &&
    other.location == location &&
    other.socialLinks == socialLinks &&
    other.firebaseUserId == firebaseUserId &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (photoUrl == null ? 0 : photoUrl!.hashCode) +
    (userType == null ? 0 : userType!.hashCode) +
    (isActive == null ? 0 : isActive!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (socialLinks == null ? 0 : socialLinks!.hashCode) +
    (firebaseUserId == null ? 0 : firebaseUserId!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() => 'UserSchema[id=$id, email=$email, name=$name, photoUrl=$photoUrl, userType=$userType, isActive=$isActive, location=$location, socialLinks=$socialLinks, firebaseUserId=$firebaseUserId, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
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

  /// Returns a new [UserSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserSchema(
        id: mapValueOfType<String>(json, r'id'),
        email: mapValueOfType<String>(json, r'email'),
        name: mapValueOfType<String>(json, r'name'),
        photoUrl: mapValueOfType<String>(json, r'photo_url'),
        userType: UserType.fromJson(json[r'user_type']),
        isActive: mapValueOfType<bool>(json, r'is_active'),
        location: LocationSchema.fromJson(json[r'location']),
        socialLinks: SocialLinksSchema.fromJson(json[r'social_links']),
        firebaseUserId: mapValueOfType<String>(json, r'firebase_user_id'),
        createdAt: mapDateTime(json, r'created_at', r''),
        updatedAt: mapDateTime(json, r'updated_at', r''),
      );
    }
    return null;
  }

  static List<UserSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserSchema> mapFromJson(dynamic json) {
    final map = <String, UserSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserSchema-objects as value to a dart map
  static Map<String, List<UserSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

