//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class StatusTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const StatusTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const status = StatusTypeEnum._(r'Status');
  static const projectStatus = StatusTypeEnum._(r'Project Status');

  /// List of all possible values in this [enum][StatusTypeEnum].
  static const values = <StatusTypeEnum>[
    status,
    projectStatus,
  ];

  static StatusTypeEnum? fromJson(dynamic value) => StatusTypeEnumTypeTransformer().decode(value);

  static List<StatusTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StatusTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StatusTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [StatusTypeEnum] to String,
/// and [decode] dynamic data back to [StatusTypeEnum].
class StatusTypeEnumTypeTransformer {
  factory StatusTypeEnumTypeTransformer() => _instance ??= const StatusTypeEnumTypeTransformer._();

  const StatusTypeEnumTypeTransformer._();

  String encode(StatusTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a StatusTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  StatusTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Status': return StatusTypeEnum.status;
        case r'Project Status': return StatusTypeEnum.projectStatus;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [StatusTypeEnumTypeTransformer] instance.
  static StatusTypeEnumTypeTransformer? _instance;
}

