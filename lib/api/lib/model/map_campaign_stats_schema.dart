//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class MapCampaignStatsSchema {
  /// Returns a new [MapCampaignStatsSchema] instance.
  MapCampaignStatsSchema({
    this.campaignId,
    this.campaignName = 'Unknown campaign',
    this.submissionCount = 0,
    this.cleanupCount = 0,
    this.trashReportCount = 0,
    this.totalBags = 0,
    this.totalPounds = 0.0,
    this.treePlantingCount = 0,
    this.wildflowerPlantingCount = 0,
    this.totalPlantings = 0,
  });

  String? campaignId;

  String campaignName;

  int submissionCount;

  int cleanupCount;

  int trashReportCount;

  int totalBags;

  num totalPounds;

  int treePlantingCount;

  int wildflowerPlantingCount;

  int totalPlantings;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MapCampaignStatsSchema &&
    other.campaignId == campaignId &&
    other.campaignName == campaignName &&
    other.submissionCount == submissionCount &&
    other.cleanupCount == cleanupCount &&
    other.trashReportCount == trashReportCount &&
    other.totalBags == totalBags &&
    other.totalPounds == totalPounds &&
    other.treePlantingCount == treePlantingCount &&
    other.wildflowerPlantingCount == wildflowerPlantingCount &&
    other.totalPlantings == totalPlantings;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (campaignId == null ? 0 : campaignId!.hashCode) +
    (campaignName.hashCode) +
    (submissionCount.hashCode) +
    (cleanupCount.hashCode) +
    (trashReportCount.hashCode) +
    (totalBags.hashCode) +
    (totalPounds.hashCode) +
    (treePlantingCount.hashCode) +
    (wildflowerPlantingCount.hashCode) +
    (totalPlantings.hashCode);

  @override
  String toString() => 'MapCampaignStatsSchema[campaignId=$campaignId, campaignName=$campaignName, submissionCount=$submissionCount, cleanupCount=$cleanupCount, trashReportCount=$trashReportCount, totalBags=$totalBags, totalPounds=$totalPounds, treePlantingCount=$treePlantingCount, wildflowerPlantingCount=$wildflowerPlantingCount, totalPlantings=$totalPlantings]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.campaignId != null) {
      json[r'campaign_id'] = this.campaignId;
    } else {
      json[r'campaign_id'] = null;
    }
      json[r'campaign_name'] = this.campaignName;
      json[r'submission_count'] = this.submissionCount;
      json[r'cleanup_count'] = this.cleanupCount;
      json[r'trash_report_count'] = this.trashReportCount;
      json[r'total_bags'] = this.totalBags;
      json[r'total_pounds'] = this.totalPounds;
      json[r'tree_planting_count'] = this.treePlantingCount;
      json[r'wildflower_planting_count'] = this.wildflowerPlantingCount;
      json[r'total_plantings'] = this.totalPlantings;
    return json;
  }

  /// Returns a new [MapCampaignStatsSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MapCampaignStatsSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MapCampaignStatsSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MapCampaignStatsSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MapCampaignStatsSchema(
        campaignId: mapValueOfType<String>(json, r'campaign_id'),
        campaignName: mapValueOfType<String>(json, r'campaign_name') ?? 'Unknown campaign',
        submissionCount: mapValueOfType<int>(json, r'submission_count') ?? 0,
        cleanupCount: mapValueOfType<int>(json, r'cleanup_count') ?? 0,
        trashReportCount: mapValueOfType<int>(json, r'trash_report_count') ?? 0,
        totalBags: mapValueOfType<int>(json, r'total_bags') ?? 0,
        totalPounds: num.parse('${json[r'total_pounds']}'),
        treePlantingCount: mapValueOfType<int>(json, r'tree_planting_count') ?? 0,
        wildflowerPlantingCount: mapValueOfType<int>(json, r'wildflower_planting_count') ?? 0,
        totalPlantings: mapValueOfType<int>(json, r'total_plantings') ?? 0,
      );
    }
    return null;
  }

  static List<MapCampaignStatsSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MapCampaignStatsSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MapCampaignStatsSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MapCampaignStatsSchema> mapFromJson(dynamic json) {
    final map = <String, MapCampaignStatsSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MapCampaignStatsSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MapCampaignStatsSchema-objects as value to a dart map
  static Map<String, List<MapCampaignStatsSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MapCampaignStatsSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MapCampaignStatsSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

