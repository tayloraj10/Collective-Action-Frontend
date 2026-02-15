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
  }) async {
    try {
      return await _api.getLatestActionsActionsRecentGet(
        days: days,
        actionType: actionType,
      );
    } catch (e) {
      throw Exception('Failed to fetch initiatives: $e');
    }
  }

  Future<ActionSchema?> createAction(ActionCreateSchema action) async {
    try {
      return await _api.createActionActionsPost(action);
    } catch (e) {
      throw Exception('Failed to create action: $e');
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
  }) async {
    try {
      return await _api.getActionsByLinkedActionsByLinkedLinkedIdGet(
        linkedId,
        days: days,
      );
    } catch (e) {
      throw Exception('Failed to fetch actions by linked: $e');
    }
  }

  /// Map events are actions with latitude/longitude (and optional event_data).
  /// Use [linkedId] as the map campaign id to get events for that campaign.
  Future<List<ActionSchema>> fetchMapEvents(String campaignId, {int? days}) async {
    final list = await fetchActionsByLinked(campaignId, days: days);
    if (list == null) return [];
    return list
        .where((a) => a.latitude != null && a.longitude != null)
        .toList();
  }
}
