import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class StatusService {
  late final StatusesApi _api;

  StatusService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = StatusesApi(client);
  }

  Future<List<StatusSchema>?> fetchStatusOptions() async {
    try {
      return await _api.listStatusesStatusesGet();
    } catch (e) {
      throw Exception('Failed to fetch status options: $e');
    }
  }
}

class CategoryService {
  late final CategoriesApi _api;

  CategoryService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = CategoriesApi(client);
  }

  Future<List<CategorySchema>?> fetchCategoryOptions() async {
    try {
      return await _api.listCategoriesCategoriesGet();
    } catch (e) {
      throw Exception('Failed to fetch category options: $e');
    }
  }
}

class ActionTypeService {
  late final ActionTypesApi _api;

  ActionTypeService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = ActionTypesApi(client);
  }

  Future<List<ActionTypeSchema>?> fetchActionTypeOptions() async {
    try {
      return await _api.listActionTypesActionTypesGet();
    } catch (e) {
      throw Exception('Failed to fetch action type options: $e');
    }
  }
}
