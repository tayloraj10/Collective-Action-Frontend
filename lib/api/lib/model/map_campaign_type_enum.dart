//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class MapCampaignTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const MapCampaignTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const cleanupMap = MapCampaignTypeEnum._(r'Cleanup Map');
  static const zipCodeMap = MapCampaignTypeEnum._(r'Zip Code Map');

  /// List of all possible values in this [enum][MapCampaignTypeEnum].
  static const values = <MapCampaignTypeEnum>[
    cleanupMap,
    zipCodeMap,
  ];

  static MapCampaignTypeEnum? fromJson(dynamic value) => MapCampaignTypeEnumTypeTransformer().decode(value);

  static List<MapCampaignTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapCampaignTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapCampaignTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MapCampaignTypeEnum] to String,
/// and [decode] dynamic data back to [MapCampaignTypeEnum].
class MapCampaignTypeEnumTypeTransformer {
  factory MapCampaignTypeEnumTypeTransformer() => _instance ??= const MapCampaignTypeEnumTypeTransformer._();

  const MapCampaignTypeEnumTypeTransformer._();

  String encode(MapCampaignTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MapCampaignTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MapCampaignTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Cleanup Map': return MapCampaignTypeEnum.cleanupMap;
        case r'Zip Code Map': return MapCampaignTypeEnum.zipCodeMap;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MapCampaignTypeEnumTypeTransformer] instance.
  static MapCampaignTypeEnumTypeTransformer? _instance;
}

