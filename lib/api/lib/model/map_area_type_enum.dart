//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

/// Granularity of a map area — boroughs today, neighborhoods/cities/towns later.
class MapAreaTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const MapAreaTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const borough = MapAreaTypeEnum._(r'borough');
  static const neighborhood = MapAreaTypeEnum._(r'neighborhood');
  static const city = MapAreaTypeEnum._(r'city');
  static const town = MapAreaTypeEnum._(r'town');
  static const region = MapAreaTypeEnum._(r'region');
  static const custom = MapAreaTypeEnum._(r'custom');

  /// List of all possible values in this [enum][MapAreaTypeEnum].
  static const values = <MapAreaTypeEnum>[
    borough,
    neighborhood,
    city,
    town,
    region,
    custom,
  ];

  static MapAreaTypeEnum? fromJson(dynamic value) => MapAreaTypeEnumTypeTransformer().decode(value);

  static List<MapAreaTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapAreaTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapAreaTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MapAreaTypeEnum] to String,
/// and [decode] dynamic data back to [MapAreaTypeEnum].
class MapAreaTypeEnumTypeTransformer {
  factory MapAreaTypeEnumTypeTransformer() => _instance ??= const MapAreaTypeEnumTypeTransformer._();

  const MapAreaTypeEnumTypeTransformer._();

  String encode(MapAreaTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MapAreaTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MapAreaTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'borough': return MapAreaTypeEnum.borough;
        case r'neighborhood': return MapAreaTypeEnum.neighborhood;
        case r'city': return MapAreaTypeEnum.city;
        case r'town': return MapAreaTypeEnum.town;
        case r'region': return MapAreaTypeEnum.region;
        case r'custom': return MapAreaTypeEnum.custom;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MapAreaTypeEnumTypeTransformer] instance.
  static MapAreaTypeEnumTypeTransformer? _instance;
}

