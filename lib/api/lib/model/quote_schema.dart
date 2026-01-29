//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class QuoteSchema {
  /// Returns a new [QuoteSchema] instance.
  QuoteSchema({
    required this.id,
    required this.text,
    this.translation,
    required this.active,
  });

  String id;

  String text;

  String? translation;

  bool active;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QuoteSchema &&
    other.id == id &&
    other.text == text &&
    other.translation == translation &&
    other.active == active;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (text.hashCode) +
    (translation == null ? 0 : translation!.hashCode) +
    (active.hashCode);

  @override
  String toString() => 'QuoteSchema[id=$id, text=$text, translation=$translation, active=$active]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'text'] = this.text;
    if (this.translation != null) {
      json[r'translation'] = this.translation;
    } else {
      json[r'translation'] = null;
    }
      json[r'active'] = this.active;
    return json;
  }

  /// Returns a new [QuoteSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QuoteSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "QuoteSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "QuoteSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return QuoteSchema(
        id: mapValueOfType<String>(json, r'id')!,
        text: mapValueOfType<String>(json, r'text')!,
        translation: mapValueOfType<String>(json, r'translation'),
        active: mapValueOfType<bool>(json, r'active')!,
      );
    }
    return null;
  }

  static List<QuoteSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QuoteSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QuoteSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QuoteSchema> mapFromJson(dynamic json) {
    final map = <String, QuoteSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QuoteSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QuoteSchema-objects as value to a dart map
  static Map<String, List<QuoteSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QuoteSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QuoteSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'text',
    'active',
  };
}

