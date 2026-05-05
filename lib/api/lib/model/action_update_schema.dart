//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class ActionUpdateSchema {
  /// Returns a new [ActionUpdateSchema] instance.
  ActionUpdateSchema({
    required this.userId,
    this.amount,
    this.imageUrls = const [],
    this.date,
    this.latitude,
    this.longitude,
    this.eventData = const {},
  });

  String userId;

  num? amount;

  List<String>? imageUrls;

  DateTime? date;

  num? latitude;

  num? longitude;

  Map<String, Object>? eventData;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ActionUpdateSchema &&
    other.userId == userId &&
    other.amount == amount &&
    _deepEquality.equals(other.imageUrls, imageUrls) &&
    other.date == date &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    _deepEquality.equals(other.eventData, eventData);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (amount == null ? 0 : amount!.hashCode) +
    (imageUrls == null ? 0 : imageUrls!.hashCode) +
    (date == null ? 0 : date!.hashCode) +
    (latitude == null ? 0 : latitude!.hashCode) +
    (longitude == null ? 0 : longitude!.hashCode) +
    (eventData == null ? 0 : eventData!.hashCode);

  @override
  String toString() => 'ActionUpdateSchema[userId=$userId, amount=$amount, imageUrls=$imageUrls, date=$date, latitude=$latitude, longitude=$longitude, eventData=$eventData]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'user_id'] = this.userId;
    if (this.amount != null) {
      json[r'amount'] = this.amount;
    } else {
      json[r'amount'] = null;
    }
    if (this.imageUrls != null) {
      json[r'image_urls'] = this.imageUrls;
    } else {
      json[r'image_urls'] = null;
    }
    if (this.date != null) {
      json[r'date'] = this.date!.toUtc().toIso8601String();
    } else {
      json[r'date'] = null;
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
    return json;
  }

  /// Returns a new [ActionUpdateSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ActionUpdateSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ActionUpdateSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ActionUpdateSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ActionUpdateSchema(
        userId: mapValueOfType<String>(json, r'user_id')!,
        amount: json[r'amount'] == null
            ? null
            : num.parse('${json[r'amount']}'),
        imageUrls: json[r'image_urls'] is Iterable
            ? (json[r'image_urls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        date: mapDateTime(json, r'date', r''),
        latitude: json[r'latitude'] == null
            ? null
            : num.parse('${json[r'latitude']}'),
        longitude: json[r'longitude'] == null
            ? null
            : num.parse('${json[r'longitude']}'),
        eventData: mapCastOfType<String, Object>(json, r'event_data') ?? const {},
      );
    }
    return null;
  }

  static List<ActionUpdateSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ActionUpdateSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ActionUpdateSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ActionUpdateSchema> mapFromJson(dynamic json) {
    final map = <String, ActionUpdateSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ActionUpdateSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ActionUpdateSchema-objects as value to a dart map
  static Map<String, List<ActionUpdateSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ActionUpdateSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ActionUpdateSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user_id',
  };
}

