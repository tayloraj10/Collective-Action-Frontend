//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;

class UserStatsSchema {
  /// Returns a new [UserStatsSchema] instance.
  UserStatsSchema({
    required this.userId,
    this.mapSubmissionCount = 0,
    this.cleanupCount = 0,
    this.trashReportCount = 0,
    this.totalSmallBags = 0,
    this.totalLargeBags = 0,
    this.totalBags = 0,
    this.totalPounds = 0.0,
    this.initiativeActionCount = 0,
    this.initiativesParticipated = 0,
    this.mapCampaignBreakdown = const [],
    this.actionTypeCounts = const {},
    this.followsCount = 0,
    this.contributionsCount = 0,
    this.orgId,
    this.orgName,
    this.orgFollowersCount = 0,
    this.orgPartnershipsCount = 0,
    this.orgInitiativeConnections = 0,
    this.totalActions = 0,
    this.firstActionDate,
    this.lastActionDate,
  });

  String userId;

  int mapSubmissionCount;

  int cleanupCount;

  int trashReportCount;

  int totalSmallBags;

  int totalLargeBags;

  int totalBags;

  num totalPounds;

  int initiativeActionCount;

  int initiativesParticipated;

  List<MapCampaignStatsSchema> mapCampaignBreakdown;

  Map<String, int> actionTypeCounts;

  int followsCount;

  int contributionsCount;

  String? orgId;

  String? orgName;

  int orgFollowersCount;

  int orgPartnershipsCount;

  int orgInitiativeConnections;

  int totalActions;

  DateTime? firstActionDate;

  DateTime? lastActionDate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserStatsSchema &&
    other.userId == userId &&
    other.mapSubmissionCount == mapSubmissionCount &&
    other.cleanupCount == cleanupCount &&
    other.trashReportCount == trashReportCount &&
    other.totalSmallBags == totalSmallBags &&
    other.totalLargeBags == totalLargeBags &&
    other.totalBags == totalBags &&
    other.totalPounds == totalPounds &&
    other.initiativeActionCount == initiativeActionCount &&
    other.initiativesParticipated == initiativesParticipated &&
    _deepEquality.equals(other.mapCampaignBreakdown, mapCampaignBreakdown) &&
    _deepEquality.equals(other.actionTypeCounts, actionTypeCounts) &&
    other.followsCount == followsCount &&
    other.contributionsCount == contributionsCount &&
    other.orgId == orgId &&
    other.orgName == orgName &&
    other.orgFollowersCount == orgFollowersCount &&
    other.orgPartnershipsCount == orgPartnershipsCount &&
    other.orgInitiativeConnections == orgInitiativeConnections &&
    other.totalActions == totalActions &&
    other.firstActionDate == firstActionDate &&
    other.lastActionDate == lastActionDate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (mapSubmissionCount.hashCode) +
    (cleanupCount.hashCode) +
    (trashReportCount.hashCode) +
    (totalSmallBags.hashCode) +
    (totalLargeBags.hashCode) +
    (totalBags.hashCode) +
    (totalPounds.hashCode) +
    (initiativeActionCount.hashCode) +
    (initiativesParticipated.hashCode) +
    (mapCampaignBreakdown.hashCode) +
    (actionTypeCounts.hashCode) +
    (followsCount.hashCode) +
    (contributionsCount.hashCode) +
    (orgId == null ? 0 : orgId!.hashCode) +
    (orgName == null ? 0 : orgName!.hashCode) +
    (orgFollowersCount.hashCode) +
    (orgPartnershipsCount.hashCode) +
    (orgInitiativeConnections.hashCode) +
    (totalActions.hashCode) +
    (firstActionDate == null ? 0 : firstActionDate!.hashCode) +
    (lastActionDate == null ? 0 : lastActionDate!.hashCode);

  @override
  String toString() => 'UserStatsSchema[userId=$userId, mapSubmissionCount=$mapSubmissionCount, cleanupCount=$cleanupCount, trashReportCount=$trashReportCount, totalSmallBags=$totalSmallBags, totalLargeBags=$totalLargeBags, totalBags=$totalBags, totalPounds=$totalPounds, initiativeActionCount=$initiativeActionCount, initiativesParticipated=$initiativesParticipated, mapCampaignBreakdown=$mapCampaignBreakdown, actionTypeCounts=$actionTypeCounts, followsCount=$followsCount, contributionsCount=$contributionsCount, orgId=$orgId, orgName=$orgName, orgFollowersCount=$orgFollowersCount, orgPartnershipsCount=$orgPartnershipsCount, orgInitiativeConnections=$orgInitiativeConnections, totalActions=$totalActions, firstActionDate=$firstActionDate, lastActionDate=$lastActionDate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'user_id'] = this.userId;
      json[r'map_submission_count'] = this.mapSubmissionCount;
      json[r'cleanup_count'] = this.cleanupCount;
      json[r'trash_report_count'] = this.trashReportCount;
      json[r'total_small_bags'] = this.totalSmallBags;
      json[r'total_large_bags'] = this.totalLargeBags;
      json[r'total_bags'] = this.totalBags;
      json[r'total_pounds'] = this.totalPounds;
      json[r'initiative_action_count'] = this.initiativeActionCount;
      json[r'initiatives_participated'] = this.initiativesParticipated;
      json[r'map_campaign_breakdown'] = this.mapCampaignBreakdown;
      json[r'action_type_counts'] = this.actionTypeCounts;
      json[r'follows_count'] = this.followsCount;
      json[r'contributions_count'] = this.contributionsCount;
    if (this.orgId != null) {
      json[r'org_id'] = this.orgId;
    } else {
      json[r'org_id'] = null;
    }
    if (this.orgName != null) {
      json[r'org_name'] = this.orgName;
    } else {
      json[r'org_name'] = null;
    }
      json[r'org_followers_count'] = this.orgFollowersCount;
      json[r'org_partnerships_count'] = this.orgPartnershipsCount;
      json[r'org_initiative_connections'] = this.orgInitiativeConnections;
      json[r'total_actions'] = this.totalActions;
    if (this.firstActionDate != null) {
      json[r'first_action_date'] = this.firstActionDate!.toUtc().toIso8601String();
    } else {
      json[r'first_action_date'] = null;
    }
    if (this.lastActionDate != null) {
      json[r'last_action_date'] = this.lastActionDate!.toUtc().toIso8601String();
    } else {
      json[r'last_action_date'] = null;
    }
    return json;
  }

  /// Returns a new [UserStatsSchema] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserStatsSchema? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserStatsSchema[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserStatsSchema[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserStatsSchema(
        userId: mapValueOfType<String>(json, r'user_id')!,
        mapSubmissionCount: mapValueOfType<int>(json, r'map_submission_count') ?? 0,
        cleanupCount: mapValueOfType<int>(json, r'cleanup_count') ?? 0,
        trashReportCount: mapValueOfType<int>(json, r'trash_report_count') ?? 0,
        totalSmallBags: mapValueOfType<int>(json, r'total_small_bags') ?? 0,
        totalLargeBags: mapValueOfType<int>(json, r'total_large_bags') ?? 0,
        totalBags: mapValueOfType<int>(json, r'total_bags') ?? 0,
        totalPounds: num.parse('${json[r'total_pounds']}'),
        initiativeActionCount: mapValueOfType<int>(json, r'initiative_action_count') ?? 0,
        initiativesParticipated: mapValueOfType<int>(json, r'initiatives_participated') ?? 0,
        mapCampaignBreakdown: MapCampaignStatsSchema.listFromJson(json[r'map_campaign_breakdown']),
        actionTypeCounts: mapCastOfType<String, int>(json, r'action_type_counts') ?? const {},
        followsCount: mapValueOfType<int>(json, r'follows_count') ?? 0,
        contributionsCount: mapValueOfType<int>(json, r'contributions_count') ?? 0,
        orgId: mapValueOfType<String>(json, r'org_id'),
        orgName: mapValueOfType<String>(json, r'org_name'),
        orgFollowersCount: mapValueOfType<int>(json, r'org_followers_count') ?? 0,
        orgPartnershipsCount: mapValueOfType<int>(json, r'org_partnerships_count') ?? 0,
        orgInitiativeConnections: mapValueOfType<int>(json, r'org_initiative_connections') ?? 0,
        totalActions: mapValueOfType<int>(json, r'total_actions') ?? 0,
        firstActionDate: mapDateTime(json, r'first_action_date', r''),
        lastActionDate: mapDateTime(json, r'last_action_date', r''),
      );
    }
    return null;
  }

  static List<UserStatsSchema> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserStatsSchema>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserStatsSchema.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserStatsSchema> mapFromJson(dynamic json) {
    final map = <String, UserStatsSchema>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserStatsSchema.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserStatsSchema-objects as value to a dart map
  static Map<String, List<UserStatsSchema>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserStatsSchema>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserStatsSchema.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user_id',
  };
}

