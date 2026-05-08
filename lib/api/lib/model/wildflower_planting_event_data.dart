//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class WildflowerPlantingEventData {
  /// Returns a new [WildflowerPlantingEventData] instance.
  WildflowerPlantingEventData({
    this.type = EventDataType.wildflowerPlanting,
    this.name = '',
    this.location = '',
    this.plantingType = 'wildflower',
    this.species = '',
    this.quantity = 1,
    this.notes = '',
    this.imageUrl,
  });

  EventDataType type;

  String name;

  String location;

  String plantingType;

  String species;

  int quantity;

  String notes;

  String? imageUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WildflowerPlantingEventData &&
    other.type == type &&
    other.name == name &&
    other.location == location &&
    other.plantingType == plantingType &&
    other.species == species &&
    other.quantity == quantity &&
    other.notes == notes &&
    other.imageUrl == imageUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (type.hashCode) +
    (name.hashCode) +
    (location.hashCode) +
    (plantingType.hashCode) +
    (species.hashCode) +
    (quantity.hashCode) +
    (notes.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode);

  @override
  String toString() => 'WildflowerPlantingEventData[type=$type, name=$name, location=$location, plantingType=$plantingType, species=$species, quantity=$quantity, notes=$notes, imageUrl=$imageUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'type'] = this.type;
      json[r'name'] = this.name;
      json[r'location'] = this.location;
      json[r'planting_type'] = this.plantingType;
      json[r'species'] = this.species;
      json[r'quantity'] = this.quantity;
      json[r'notes'] = this.notes;
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
    return json;
  }

  /// Returns a new [WildflowerPlantingEventData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WildflowerPlantingEventData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WildflowerPlantingEventData[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WildflowerPlantingEventData[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WildflowerPlantingEventData(
        type: EventDataType.fromJson(json[r'type']) ?? EventDataType.wildflowerPlanting,
        name: mapValueOfType<String>(json, r'name') ?? '',
        location: mapValueOfType<String>(json, r'location') ?? '',
        plantingType: mapValueOfType<String>(json, r'planting_type') ?? 'wildflower',
        species: mapValueOfType<String>(json, r'species') ?? '',
        quantity: mapValueOfType<int>(json, r'quantity') ?? 1,
        notes: mapValueOfType<String>(json, r'notes') ?? '',
        imageUrl: mapValueOfType<String>(json, r'image_url'),
      );
    }
    return null;
  }

  static List<WildflowerPlantingEventData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WildflowerPlantingEventData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WildflowerPlantingEventData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WildflowerPlantingEventData> mapFromJson(dynamic json) {
    final map = <String, WildflowerPlantingEventData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WildflowerPlantingEventData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WildflowerPlantingEventData-objects as value to a dart map
  static Map<String, List<WildflowerPlantingEventData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WildflowerPlantingEventData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WildflowerPlantingEventData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

