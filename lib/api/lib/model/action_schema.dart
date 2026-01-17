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
    this.imageUrl,
    this.initiativeId,
    required this.userId,
    this.extraData = const {},
  });

  String id;

  String actionType;

  int? amount;

  DateTime date;

  String? imageUrl;

  String? initiativeId;

  String userId;

  Map<String, Object>? extraData;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ActionSchema &&
    other.id == id &&
    other.actionType == actionType &&
    other.amount == amount &&
    other.date == date &&
    other.imageUrl == imageUrl &&
    other.initiativeId == initiativeId &&
    other.userId == userId &&
    _deepEquality.equals(other.extraData, extraData);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (actionType.hashCode) +
    (amount == null ? 0 : amount!.hashCode) +
    (date.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (initiativeId == null ? 0 : initiativeId!.hashCode) +
    (userId.hashCode) +
    (extraData == null ? 0 : extraData!.hashCode);

  @override
  String toString() => 'ActionSchema[id=$id, actionType=$actionType, amount=$amount, date=$date, imageUrl=$imageUrl, initiativeId=$initiativeId, userId=$userId, extraData=$extraData]';

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
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
    if (this.initiativeId != null) {
      json[r'initiative_id'] = this.initiativeId;
    } else {
      json[r'initiative_id'] = null;
    }
      json[r'user_id'] = this.userId;
    if (this.extraData != null) {
      json[r'extra_data'] = this.extraData;
    } else {
      json[r'extra_data'] = null;
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
        amount: mapValueOfType<int>(json, r'amount'),
        date: mapDateTime(json, r'date', r'')!,
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        initiativeId: mapValueOfType<String>(json, r'initiative_id'),
        userId: mapValueOfType<String>(json, r'user_id')!,
        extraData: mapCastOfType<String, Object>(json, r'extra_data') ?? const {},
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
    'user_id',
  };
}

