//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class StatusValuesEnum {
  /// Instantiate a new enum with the provided [value].
  const StatusValuesEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const inProgress = StatusValuesEnum._(r'In Progress');
  static const completed = StatusValuesEnum._(r'Completed');
  static const active = StatusValuesEnum._(r'Active');
  static const inactive = StatusValuesEnum._(r'Inactive');

  /// List of all possible values in this [enum][StatusValuesEnum].
  static const values = <StatusValuesEnum>[
    inProgress,
    completed,
    active,
    inactive,
  ];

  static StatusValuesEnum? fromJson(dynamic value) => StatusValuesEnumTypeTransformer().decode(value);

  static List<StatusValuesEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StatusValuesEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StatusValuesEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [StatusValuesEnum] to String,
/// and [decode] dynamic data back to [StatusValuesEnum].
class StatusValuesEnumTypeTransformer {
  factory StatusValuesEnumTypeTransformer() => _instance ??= const StatusValuesEnumTypeTransformer._();

  const StatusValuesEnumTypeTransformer._();

  String encode(StatusValuesEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a StatusValuesEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  StatusValuesEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'In Progress': return StatusValuesEnum.inProgress;
        case r'Completed': return StatusValuesEnum.completed;
        case r'Active': return StatusValuesEnum.active;
        case r'Inactive': return StatusValuesEnum.inactive;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [StatusValuesEnumTypeTransformer] instance.
  static StatusValuesEnumTypeTransformer? _instance;
}

