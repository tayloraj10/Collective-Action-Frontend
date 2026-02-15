//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

/// Type discriminator for event_data payloads.
class EventDataType {
  /// Instantiate a new enum with the provided [value].
  const EventDataType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const cleanup = EventDataType._(r'Cleanup');
  static const trashReport = EventDataType._(r'Trash Report');
  static const cleanupRoute = EventDataType._(r'Cleanup Route');
  static const zipCodeSubmission = EventDataType._(r'Zip Code Submission');

  /// List of all possible values in this [enum][EventDataType].
  static const values = <EventDataType>[
    cleanup,
    trashReport,
    cleanupRoute,
    zipCodeSubmission,
  ];

  static EventDataType? fromJson(dynamic value) => EventDataTypeTypeTransformer().decode(value);

  static List<EventDataType> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EventDataType>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EventDataType.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EventDataType] to String,
/// and [decode] dynamic data back to [EventDataType].
class EventDataTypeTypeTransformer {
  factory EventDataTypeTypeTransformer() => _instance ??= const EventDataTypeTypeTransformer._();

  const EventDataTypeTypeTransformer._();

  String encode(EventDataType data) => data.value;

  /// Decodes a [dynamic value][data] to a EventDataType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EventDataType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Cleanup': return EventDataType.cleanup;
        case r'Trash Report': return EventDataType.trashReport;
        case r'Cleanup Route': return EventDataType.cleanupRoute;
        case r'Zip Code Submission': return EventDataType.zipCodeSubmission;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EventDataTypeTypeTransformer] instance.
  static EventDataTypeTypeTransformer? _instance;
}

