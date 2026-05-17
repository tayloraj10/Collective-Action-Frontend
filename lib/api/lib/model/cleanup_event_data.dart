//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class CleanupEventData {
  /// Returns a new [CleanupEventData] instance.
  CleanupEventData({
    this.type = EventDataType.cleanup,
    this.name = '',
    this.imageUrl,
    this.smallBags,
    this.largeBags,
    this.pounds,
    this.location = '',
    this.scheduledStart,
    this.scheduledEnd,
    this.organizerUserId,
    this.status,
    this.rsvpUserIds = const [],
    this.attendedUserIds = const [],
  });

  EventDataType type;

  String name;

  String? imageUrl;

  int? smallBags;

  int? largeBags;

  num? pounds;

  String location;

  DateTime? scheduledStart;

  DateTime? scheduledEnd;

  String? organizerUserId;

  String? status;

  List<String> rsvpUserIds;

  List<String> attendedUserIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CleanupEventData &&
    other.type == type &&
    other.name == name &&
    other.imageUrl == imageUrl &&
    other.smallBags == smallBags &&
    other.largeBags == largeBags &&
    other.pounds == pounds &&
    other.location == location &&
    other.scheduledStart == scheduledStart &&
    other.scheduledEnd == scheduledEnd &&
    other.organizerUserId == organizerUserId &&
    other.status == status &&
    _deepEquality.equals(other.rsvpUserIds, rsvpUserIds) &&
    _deepEquality.equals(other.attendedUserIds, attendedUserIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (type.hashCode) +
    (name.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (smallBags == null ? 0 : smallBags!.hashCode) +
    (largeBags == null ? 0 : largeBags!.hashCode) +
    (pounds == null ? 0 : pounds!.hashCode) +
    (location.hashCode) +
    (scheduledStart == null ? 0 : scheduledStart!.hashCode) +
    (scheduledEnd == null ? 0 : scheduledEnd!.hashCode) +
    (organizerUserId == null ? 0 : organizerUserId!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (rsvpUserIds.hashCode) +
    (attendedUserIds.hashCode);

  @override
  String toString() => 'CleanupEventData[type=$type, name=$name, imageUrl=$imageUrl, smallBags=$smallBags, largeBags=$largeBags, pounds=$pounds, location=$location, scheduledStart=$scheduledStart, scheduledEnd=$scheduledEnd, organizerUserId=$organizerUserId, status=$status, rsvpUserIds=$rsvpUserIds, attendedUserIds=$attendedUserIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'type'] = this.type;
      json[r'name'] = this.name;
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
    if (this.smallBags != null) {
      json[r'small_bags'] = this.smallBags;
    } else {
      json[r'small_bags'] = null;
    }
    if (this.largeBags != null) {
      json[r'large_bags'] = this.largeBags;
    } else {
      json[r'large_bags'] = null;
    }
    if (this.pounds != null) {
      json[r'pounds'] = this.pounds;
    } else {
      json[r'pounds'] = null;
    }
      json[r'location'] = this.location;
    if (this.scheduledStart != null) {
      json[r'scheduled_start'] = this.scheduledStart!.toUtc().toIso8601String();
    } else {
      json[r'scheduled_start'] = null;
    }
    if (this.scheduledEnd != null) {
      json[r'scheduled_end'] = this.scheduledEnd!.toUtc().toIso8601String();
    } else {
      json[r'scheduled_end'] = null;
    }
    if (this.organizerUserId != null) {
      json[r'organizer_user_id'] = this.organizerUserId;
    } else {
      json[r'organizer_user_id'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
      json[r'rsvp_user_ids'] = this.rsvpUserIds;
      json[r'attended_user_ids'] = this.attendedUserIds;
    return json;
  }

  /// Returns a new [CleanupEventData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CleanupEventData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CleanupEventData[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CleanupEventData[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CleanupEventData(
        type: EventDataType.fromJson(json[r'type']) ?? EventDataType.cleanup,
        name: mapValueOfType<String>(json, r'name') ?? '',
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        smallBags: mapValueOfType<int>(json, r'small_bags'),
        largeBags: mapValueOfType<int>(json, r'large_bags'),
        pounds: json[r'pounds'] == null
            ? null
            : num.parse('${json[r'pounds']}'),
        location: mapValueOfType<String>(json, r'location') ?? '',
        scheduledStart: mapDateTime(json, r'scheduled_start', r''),
        scheduledEnd: mapDateTime(json, r'scheduled_end', r''),
        organizerUserId: mapValueOfType<String>(json, r'organizer_user_id'),
        status: mapValueOfType<String>(json, r'status'),
        rsvpUserIds: json[r'rsvp_user_ids'] is Iterable
            ? (json[r'rsvp_user_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        attendedUserIds: json[r'attended_user_ids'] is Iterable
            ? (json[r'attended_user_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<CleanupEventData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CleanupEventData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CleanupEventData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CleanupEventData> mapFromJson(dynamic json) {
    final map = <String, CleanupEventData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CleanupEventData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CleanupEventData-objects as value to a dart map
  static Map<String, List<CleanupEventData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CleanupEventData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CleanupEventData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

