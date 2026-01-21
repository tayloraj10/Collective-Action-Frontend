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
}
