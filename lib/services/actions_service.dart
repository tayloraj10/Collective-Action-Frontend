import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class ActionsService {
  late final ActionsApi _api;

  ActionsService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = ActionsApi(client);
  }

  Future<List<ActionSchema>?> fetchLatestActions({
    int? days,
    ActionTypeValuesEnum? actionType,
    bool? includeInactive,
    String? forUserId,
  }) async {
    try {
      return await _api.getLatestActionsActionsRecentGet(
        days: days,
        actionType: actionType,
        includeInactive: includeInactive,
        forUserId: forUserId,
      );
    } catch (e) {
      throw Exception('Failed to fetch initiatives: $e');
    }
  }

  /// Like an action. Returns the updated action (like counts, liked_by_me).
  Future<ActionSchema?> addActionLike(String actionId, String userId) async {
    try {
      return await _api.addActionLikeActionsActionIdLikePost(
        actionId,
        ActionLikeBody(userId: userId),
      );
    } catch (e) {
      throw Exception('Failed to like action: $e');
    }
  }

  /// Remove the current user's like. Returns the updated action.
  Future<ActionSchema?> removeActionLike(String actionId, String userId) async {
    try {
      return await _api.removeActionLikeActionsActionIdLikeDelete(
        actionId,
        userId,
      );
    } catch (e) {
      throw Exception('Failed to remove like: $e');
    }
  }

  Future<ActionSchema?> createAction(ActionCreateSchema action) async {
    try {
      return await _api.createActionActionsPost(action);
    } catch (e) {
      throw Exception('Failed to create action: $e');
    }
  }

  /// [CleanupEventData.toJson] leaves `type` as [EventDataType]; APIs need the string value.
  static Map<String, dynamic> cleanupEventDataToJson(CleanupEventData data) {
    final json = data.toJson();
    json['type'] = data.type.toJson();
    return json;
  }

  static Map<String, dynamic> trashReportEventDataToJson(TrashReportEventData data) {
    final json = data.toJson();
    json['type'] = data.type.toJson();
    return json;
  }

  /// Encode event_data for API bodies (string type discriminator, ISO dates, no null keys).
  static Map<String, Object> encodeEventDataForApi(Map<String, dynamic> data) {
    final result = <String, Object>{};
    for (final entry in data.entries) {
      final encoded = _encodeEventDataValue(entry.value);
      if (encoded != null) {
        result[entry.key] = encoded;
      }
    }
    return result;
  }

  static Object? _encodeEventDataValue(dynamic value) {
    if (value == null) return null;
    if (value is EventDataType) return value.toJson();
    if (value is DateTime) return value.toUtc().toIso8601String();
    if (value is List) {
      return value
          .map(_encodeEventDataValue)
          .where((e) => e != null)
          .map((e) => e as Object)
          .toList();
    }
    if (value is Map) {
      return encodeEventDataForApi(Map<String, dynamic>.from(value));
    }
    return value as Object;
  }

  Future<ActionSchema?> updateAction({
    required String actionId,
    required String userId,
    num? amount,
    List<String>? imageUrls,
    DateTime? date,
    num? latitude,
    num? longitude,
    Map<String, dynamic>? eventData,
  }) async {
    try {
      return await _api.updateActionActionsActionIdPatch(
        actionId,
        ActionUpdateSchema(
          userId: userId,
          amount: amount,
          imageUrls: imageUrls,
          date: date,
          latitude: latitude,
          longitude: longitude,
          eventData: eventData == null
              ? null
              : encodeEventDataForApi(eventData),
        ),
      );
    } catch (e) {
      throw Exception('Failed to update action: $e');
    }
  }

  Future<ActionSchema?> claimTrashReportCleaned({
    required String trashReportId,
    String? userId,
    required Map<String, dynamic> eventData,
    num amount = 1,
    List<String>? imageUrls,
    DateTime? date,
    num? latitude,
    num? longitude,
  }) async {
    try {
      return await _api
          .claimTrashReportCleanedActionsTrashReportIdClaimCleanedPost(
            trashReportId,
            ActionClaimCleanedSchema(
              userId: userId,
              amount: amount,
              imageUrls: imageUrls,
              date: date,
              latitude: latitude,
              longitude: longitude,
              eventData: encodeEventDataForApi(eventData),
            ),
          );
    } catch (e) {
      throw Exception('Failed to claim trash report: $e');
    }
  }

  Future<List<String>> fetchCleanupRsvps(String cleanupId) async {
    try {
      return await _api.listCleanupRsvpsActionsCleanupIdRsvpsGet(cleanupId) ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch cleanup RSVPs: $e');
    }
  }

  Future<ActionSchema?> rsvpToCleanup(String cleanupId, String userId) async {
    try {
      return await _api.upsertCleanupRsvpActionsCleanupIdRsvpPost(
        cleanupId,
        CleanupParticipationBody(userId: userId),
      );
    } catch (e) {
      throw Exception('Failed to RSVP to cleanup: $e');
    }
  }

  Future<ActionSchema?> removeCleanupRsvp(
    String cleanupId,
    String userId,
  ) async {
    try {
      return await _api.deleteCleanupRsvpActionsCleanupIdRsvpDelete(
        cleanupId,
        userId,
      );
    } catch (e) {
      throw Exception('Failed to remove cleanup RSVP: $e');
    }
  }

  Future<List<String>> fetchCleanupAttendance(String cleanupId) async {
    try {
      return await _api.listCleanupAttendanceActionsCleanupIdAttendanceGet(
            cleanupId,
          ) ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch cleanup attendance: $e');
    }
  }

  Future<ActionSchema?> markCleanupAttendance(
    String cleanupId,
    String userId,
  ) async {
    try {
      return await _api.markCleanupAttendanceActionsCleanupIdAttendancePost(
        cleanupId,
        CleanupParticipationBody(userId: userId),
      );
    } catch (e) {
      throw Exception('Failed to mark cleanup attendance: $e');
    }
  }

  /// Update only the photo URLs for an existing action (e.g. after uploading under action id).
  Future<ActionSchema?> updateActionPhotos(
    String actionId,
    List<String> imageUrls,
  ) async {
    try {
      final body = ActionPhotosUpdate(imageUrls: imageUrls);
      return await _api.updateActionPhotosActionsActionIdPhotosPatch(
        actionId,
        body,
      );
    } catch (e) {
      throw Exception('Failed to update action photos: $e');
    }
  }

  Future<ActionSchema?> deleteAction(ActionSchema action) async {
    try {
      return await _api.deleteActionActionsActionIdDelete(action.id);
    } catch (e) {
      throw Exception('Failed to create action: $e');
    }
  }

  Future<List<ActionSchema>?> fetchActionsByLinked(
    String linkedId, {
    int? days,
    bool? includeInactive,
    String? forUserId,
  }) async {
    try {
      return await _api.getActionsByLinkedActionsByLinkedLinkedIdGet(
        linkedId,
        days: days,
        includeInactive: includeInactive,
        forUserId: forUserId,
      );
    } catch (e) {
      throw Exception('Failed to fetch actions by linked: $e');
    }
  }

  /// Map events are actions with latitude/longitude (and optional event_data).
  /// Use [linkedId] as the map campaign id to get events for that campaign.
  Future<List<ActionSchema>> fetchMapEvents(
    String campaignId, {
    int? days,
    bool? includeInactive,
    String? forUserId,
  }) async {
    final list = await fetchActionsByLinked(
      campaignId,
      days: days,
      includeInactive: includeInactive,
      forUserId: forUserId,
    );
    if (list == null) return [];
    return list
        .where((a) => a.latitude != null && a.longitude != null)
        .toList();
  }
}
