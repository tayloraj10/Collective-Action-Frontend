//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class TrashReportEventData {
  /// Returns a new [TrashReportEventData] instance.
  TrashReportEventData({
    this.location = '',
    required this.date,
    this.imageUrl,
  });

  String location;

  DateTime date;

  String? imageUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrashReportEventData &&
    other.location == location &&
    other.date == date &&
    other.imageUrl == imageUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (location.hashCode) +
    (date.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode);

  @override
  String toString() => 'TrashReportEventData[location=$location, date=$date, imageUrl=$imageUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'location'] = this.location;
      json[r'date'] = this.date.toUtc().toIso8601String();
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
    return json;
  }

  /// Returns a new [TrashReportEventData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TrashReportEventData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TrashReportEventData[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TrashReportEventData[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TrashReportEventData(
        location: mapValueOfType<String>(json, r'location') ?? '',
        date: mapDateTime(json, r'date', r'')!,
        imageUrl: mapValueOfType<String>(json, r'image_url'),
      );
    }
    return null;
  }

  static List<TrashReportEventData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrashReportEventData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrashReportEventData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrashReportEventData> mapFromJson(dynamic json) {
    final map = <String, TrashReportEventData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TrashReportEventData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrashReportEventData-objects as value to a dart map
  static Map<String, List<TrashReportEventData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrashReportEventData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrashReportEventData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
  };
}

