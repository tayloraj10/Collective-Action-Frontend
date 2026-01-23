import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class UserService {
  late final UsersApi _api;

  UserService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = UsersApi(client);
  }

  Future<UserSchema?> fetchUser({required String userId}) async {
    try {
      return await _api.getUserByFirebaseIdUsersFirebaseIdGet(userId);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<UserSchema?> createUser(UserCreate action) async {
    try {
      return await _api.createUserUsersPost(action);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
