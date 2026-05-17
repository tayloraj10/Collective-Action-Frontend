//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ActionSchema {
  /// Returns a new [ActionSchema] instance.
  ActionSchema({
    required this.id,
    required this.actionType,
    this.amount,
    required this.date,
    this.imageUrls = const [],
    this.linkedId,
    this.userId,
    this.latitude,
    this.longitude,
    this.eventData = const {},
    this.likeUserIds = const [],
    this.likeCount = 0,
    this.likedByMe = false,
    this.isActive = true,
    this.resolvedAt,
    this.resolvedByUserId,
    this.resolvedByActionId,
    this.sourceTrashReportId,
  });

  String id;

  String actionType;

  num? amount;

  DateTime date;

  /// List of image URLs
  List<String> imageUrls;

  String? linkedId;

  String? userId;

  num? latitude;

  num? longitude;

  Map<String, Object>? eventData;

  /// Database user ids who liked this action (newest first).
  List<String> likeUserIds;

  int likeCount;

  bool likedByMe;

  bool isActive;

  DateTime? resolvedAt;

  String? resolvedByUserId;

  String? resolvedByActionId;

  String? sourceTrashReportId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ActionSchema &&
    other.id == id &&
    other.actionType == actionType &&
    other.amount == amount &&
    other.date == date &&
    _deepEquality.equals(other.imageUrls, imageUrls) &&
    other.linkedId == linkedId &&
    other.userId == userId &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    _deepEquality.equals(other.eventData, eventData) &&
    _deepEquality.equals(other.likeUserIds, likeUserIds) &&
    other.likeCount == likeCount &&
    other.likedByMe == likedByMe &&
    other.isActive == isActive &&
    other.resolvedAt == resolvedAt &&
    other.resolvedByUserId == resolvedByUserId &&
    other.resolvedByActionId == resolvedByActionId &&
    other.sourceTrashReportId == sourceTrashReportId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (actionType.hashCode) +
    (amount == null ? 0 : amount!.hashCode) +
    (date.hashCode) +
    (imageUrls.hashCode) +
    (linkedId == null ? 0 : linkedId!.hashCode) +
    (userId == null ? 0 : userId!.hashCode) +
    (latitude == null ? 0 : latitude!.hashCode) +
    (longitude == null ? 0 : longitude!.hashCode) +
    (eventData == null ? 0 : eventData!.hashCode) +
    (likeUserIds.hashCode) +
    (likeCount.hashCode) +
    (likedByMe.hashCode) +
    (isActive.hashCode) +
    (resolvedAt == null ? 0 : resolvedAt!.hashCode) +
    (resolvedByUserId == null ? 0 : resolvedByUserId!.hashCode) +
    (resolvedByActionId == null ? 0 : resolvedByActionId!.hashCode) +
    (sourceTrashReportId == null ? 0 : sourceTrashReportId!.hashCode);

  @override
  String toString() => 'ActionSchema[id=$id, actionType=$actionType, amount=$amount, date=$date, imageUrls=$imageUrls, linkedId=$linkedId, userId=$userId, latitude=$latitude, longitude=$longitude, eventData=$eventData, likeUserIds=$likeUserIds, likeCount=$likeCount, likedByMe=$likedByMe, isActive=$isActive, resolvedAt=$resolvedAt, resolvedByUserId=$resolvedByUserId, resolvedByActionId=$resolvedByActionId, sourceTrashReportId=$sourceTrashReportId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'action_type'] = this.actionType;
    if (this.amount != null) {
      json[r'amount'] = this.amount;
    } else {
      json[r'amount'] = null;
    }
      json[r'date'] = this.date.toUtc().toIso8601String();
      json[r'image_urls'] = this.imageUrls;
    if (this.linkedId != null) {
      json[r'linked_id'] = this.linkedId;
    } else {
      json[r'linked_id'] = null;
    }
    if (this.userId != null) {
      json[r'user_id'] = this.userId;
    } else {
      json[r'user_id'] = null;
    }
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
    if (this.eventData != null) {
      json[r'event_data'] = this.eventData;
    } else {
      json[r'event_data'] = null;
    }
      json[r'like_user_ids'] = this.likeUserIds;
      json[r'like_count'] = this.likeCount;
      json[r'liked_by_me'] = this.likedByMe;
      json[r'is_active'] = this.isActive;
    if (this.resolvedAt != null) {
      json[r'resolved_at'] = this.resolvedAt!.toUtc().toIso8601String();
    } else {
      json[r'resolved_at'] = null;
    }
    if (this.resolvedByUserId != null) {
      json[r'resolved_by_user_id'] = this.resolvedByUserId;
    } else {
      json[r'resolved_by_user_id'] = null;
    }
    if (this.resolvedByActionId != null) {
      json[r'resolved_by_action_id'] = this.resolvedByActionId;
    } else {
      json[r'resolved_by_action_id'] = null;
    }
    if (this.sourceTrashReportId != null) {
      json[r'source_trash_report_id'] = this.sourceTrashReportId;
    } else {
      json[r'source_trash_report_id'] = null;
    }
    return json;
  }

  /// Returns a new [ActionSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ActionSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ActionSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ActionSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ActionSchema(
        id: mapValueOfType<String>(json, r'id')!,
        actionType: mapValueOfType<String>(json, r'action_type')!,
        amount: json[r'amount'] == null
            ? null
            : num.parse('${json[r'amount']}'),
        date: mapDateTime(json, r'date', r'')!,
        imageUrls: json[r'image_urls'] is Iterable
            ? (json[r'image_urls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        linkedId: mapValueOfType<String>(json, r'linked_id'),
        userId: mapValueOfType<String>(json, r'user_id'),
        latitude: json[r'latitude'] == null
            ? null
            : num.parse('${json[r'latitude']}'),
        longitude: json[r'longitude'] == null
            ? null
            : num.parse('${json[r'longitude']}'),
        eventData: mapCastOfType<String, Object>(json, r'event_data') ?? const {},
        likeUserIds: json[r'like_user_ids'] is Iterable
            ? (json[r'like_user_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        likeCount: mapValueOfType<int>(json, r'like_count') ?? 0,
        likedByMe: mapValueOfType<bool>(json, r'liked_by_me') ?? false,
        isActive: mapValueOfType<bool>(json, r'is_active') ?? true,
        resolvedAt: mapDateTime(json, r'resolved_at', r''),
        resolvedByUserId: mapValueOfType<String>(json, r'resolved_by_user_id'),
        resolvedByActionId: mapValueOfType<String>(json, r'resolved_by_action_id'),
        sourceTrashReportId: mapValueOfType<String>(json, r'source_trash_report_id'),
      );
    }
    return null;
  }

  static List<ActionSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ActionSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ActionSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ActionSchema> mapFromJson(dynamic json) {
    final map = <String, ActionSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ActionSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ActionSchema-objects as value to a dart map
  static Map<String, List<ActionSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ActionSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ActionSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'action_type',
    'date',
  };
}

