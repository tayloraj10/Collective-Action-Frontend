//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ActionCreateSchema {
  /// Returns a new [ActionCreateSchema] instance.
  ActionCreateSchema({
    required this.actionType,
    required this.amount,
    this.imageUrl,
    this.linkedId,
    this.userId,
    this.date,
  });

  String actionType;

  num amount;

  String? imageUrl;

  String? linkedId;

  String? userId;

  DateTime? date;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ActionCreateSchema &&
    other.actionType == actionType &&
    other.amount == amount &&
    other.imageUrl == imageUrl &&
    other.linkedId == linkedId &&
    other.userId == userId &&
    other.date == date;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (actionType.hashCode) +
    (amount.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (linkedId == null ? 0 : linkedId!.hashCode) +
    (userId == null ? 0 : userId!.hashCode) +
    (date == null ? 0 : date!.hashCode);

  @override
  String toString() => 'ActionCreateSchema[actionType=$actionType, amount=$amount, imageUrl=$imageUrl, linkedId=$linkedId, userId=$userId, date=$date]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'action_type'] = this.actionType;
      json[r'amount'] = this.amount;
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
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
    if (this.date != null) {
      json[r'date'] = this.date!.toUtc().toIso8601String();
    } else {
      json[r'date'] = null;
    }
    return json;
  }

  /// Returns a new [ActionCreateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ActionCreateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ActionCreateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ActionCreateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ActionCreateSchema(
        actionType: mapValueOfType<String>(json, r'action_type')!,
        amount: num.parse('${json[r'amount']}'),
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        linkedId: mapValueOfType<String>(json, r'linked_id'),
        userId: mapValueOfType<String>(json, r'user_id'),
        date: mapDateTime(json, r'date', r''),
      );
    }
    return null;
  }

  static List<ActionCreateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ActionCreateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ActionCreateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ActionCreateSchema> mapFromJson(dynamic json) {
    final map = <String, ActionCreateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ActionCreateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ActionCreateSchema-objects as value to a dart map
  static Map<String, List<ActionCreateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ActionCreateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ActionCreateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'action_type',
    'amount',
  };
}

