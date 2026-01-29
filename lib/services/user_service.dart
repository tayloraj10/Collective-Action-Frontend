import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class UserService {
  late final UsersApi _api;

  UserService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = UsersApi(client);
  }

  Future<UserSchema?> fetchUserByFirebaseID({required String userId}) async {
    try {
      return await _api.getUserByFirebaseIdUsersFirebaseIdGet(userId);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<UserSchema?> fetchUserByUserID({required String userId}) async {
    try {
      return await _api.getUserByUserIdUsersDbUserIdGet(userId);
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<UserSchema?> createUser(UserCreate userData) async {
    try {
      return await _api.createUserUsersPost(userData);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserSchema?> updateUser(String userId, UserCreate userData) async {
    try {
      return await _api.updateUserUsersUserIdPatch(userId, userData);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
