//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class CategoryValuesEnum {
  /// Instantiate a new enum with the provided [value].
  const CategoryValuesEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const environment = CategoryValuesEnum._(r'Environment');
  static const nature = CategoryValuesEnum._(r'Nature');
  static const trash = CategoryValuesEnum._(r'Trash');
  static const animals = CategoryValuesEnum._(r'Animals');
  static const fitness = CategoryValuesEnum._(r'Fitness');

  /// List of all possible values in this [enum][CategoryValuesEnum].
  static const values = <CategoryValuesEnum>[
    environment,
    nature,
    trash,
    animals,
    fitness,
  ];

  static CategoryValuesEnum? fromJson(dynamic value) => CategoryValuesEnumTypeTransformer().decode(value);

  static List<CategoryValuesEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CategoryValuesEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CategoryValuesEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CategoryValuesEnum] to String,
/// and [decode] dynamic data back to [CategoryValuesEnum].
class CategoryValuesEnumTypeTransformer {
  factory CategoryValuesEnumTypeTransformer() => _instance ??= const CategoryValuesEnumTypeTransformer._();

  const CategoryValuesEnumTypeTransformer._();

  String encode(CategoryValuesEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CategoryValuesEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CategoryValuesEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Environment': return CategoryValuesEnum.environment;
        case r'Nature': return CategoryValuesEnum.nature;
        case r'Trash': return CategoryValuesEnum.trash;
        case r'Animals': return CategoryValuesEnum.animals;
        case r'Fitness': return CategoryValuesEnum.fitness;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CategoryValuesEnumTypeTransformer] instance.
  static CategoryValuesEnumTypeTransformer? _instance;
}

