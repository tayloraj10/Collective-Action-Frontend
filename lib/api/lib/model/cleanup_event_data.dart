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
    this.date,
    this.name = '',
    this.imageUrl,
    this.smallBags,
    this.largeBags,
    this.pounds,
    this.location = '',
    this.group = '',
    this.bags = 0.0,
    this.weight = 0.0,
  });

  DateTime? date;

  String name;

  String? imageUrl;

  int? smallBags;

  int? largeBags;

  num? pounds;

  String location;

  String group;

  num bags;

  num weight;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CleanupEventData &&
    other.date == date &&
    other.name == name &&
    other.imageUrl == imageUrl &&
    other.smallBags == smallBags &&
    other.largeBags == largeBags &&
    other.pounds == pounds &&
    other.location == location &&
    other.group == group &&
    other.bags == bags &&
    other.weight == weight;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date == null ? 0 : date!.hashCode) +
    (name.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (smallBags == null ? 0 : smallBags!.hashCode) +
    (largeBags == null ? 0 : largeBags!.hashCode) +
    (pounds == null ? 0 : pounds!.hashCode) +
    (location.hashCode) +
    (group.hashCode) +
    (bags.hashCode) +
    (weight.hashCode);

  @override
  String toString() => 'CleanupEventData[date=$date, name=$name, imageUrl=$imageUrl, smallBags=$smallBags, largeBags=$largeBags, pounds=$pounds, location=$location, group=$group, bags=$bags, weight=$weight]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.date != null) {
      json[r'date'] = this.date!.toUtc().toIso8601String();
    } else {
      json[r'date'] = null;
    }
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
      json[r'group'] = this.group;
      json[r'bags'] = this.bags;
      json[r'weight'] = this.weight;
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
        date: mapDateTime(json, r'date', r''),
        name: mapValueOfType<String>(json, r'name') ?? '',
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        smallBags: mapValueOfType<int>(json, r'small_bags'),
        largeBags: mapValueOfType<int>(json, r'large_bags'),
        pounds: json[r'pounds'] == null
            ? null
            : num.parse('${json[r'pounds']}'),
        location: mapValueOfType<String>(json, r'location') ?? '',
        group: mapValueOfType<String>(json, r'group') ?? '',
        bags: num.parse('${json[r'bags']}'),
        weight: num.parse('${json[r'weight']}'),
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

