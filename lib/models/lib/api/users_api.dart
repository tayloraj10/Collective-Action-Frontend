//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UsersApi {
  UsersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create User
  ///
  /// Create a new user in the database. Validates required fields and checks for duplicate emails.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UserCreate] userCreate (required):
  Future<Response> createUserUsersPostWithHttpInfo(UserCreate userCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/users/';

    // ignore: prefer_final_locals
    Object? postBody = userCreate;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create User
  ///
  /// Create a new user in the database. Validates required fields and checks for duplicate emails.
  ///
  /// Parameters:
  ///
  /// * [UserCreate] userCreate (required):
  Future<UserSchema?> createUserUsersPost(UserCreate userCreate,) async {
    final response = await createUserUsersPostWithHttpInfo(userCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserSchema',) as UserSchema;
    
    }
    return null;
  }

  /// Delete User
  ///
  /// Delete a user by their unique ID. Raises 404 if the user is not found.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<Response> deleteUserUsersUserIdDeleteWithHttpInfo(String userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/users/{user_id}'
      .replaceAll('{user_id}', userId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete User
  ///
  /// Delete a user by their unique ID. Raises 404 if the user is not found.
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<void> deleteUserUsersUserIdDelete(String userId,) async {
    final response = await deleteUserUsersUserIdDeleteWithHttpInfo(userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get User
  ///
  /// Retrieve a user by their unique ID. Raises 404 if the user is not found.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<Response> getUserUsersUserIdGetWithHttpInfo(String userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/users/{user_id}'
      .replaceAll('{user_id}', userId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get User
  ///
  /// Retrieve a user by their unique ID. Raises 404 if the user is not found.
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<UserSchema?> getUserUsersUserIdGet(String userId,) async {
    final response = await getUserUsersUserIdGetWithHttpInfo(userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserSchema',) as UserSchema;
    
    }
    return null;
  }

  /// List Users
  ///
  /// Retrieve a list of all users from the database.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listUsersUsersGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/users/';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List Users
  ///
  /// Retrieve a list of all users from the database.
  Future<List<UserSchema>?> listUsersUsersGet() async {
    final response = await listUsersUsersGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<UserSchema>') as List)
        .cast<UserSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update User
  ///
  /// Update an existing user's information. Checks for email uniqueness and applies partial updates. Raises 404 if the user is not found.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [UserCreate] userCreate (required):
  Future<Response> updateUserUsersUserIdPatchWithHttpInfo(String userId, UserCreate userCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/users/{user_id}'
      .replaceAll('{user_id}', userId);

    // ignore: prefer_final_locals
    Object? postBody = userCreate;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update User
  ///
  /// Update an existing user's information. Checks for email uniqueness and applies partial updates. Raises 404 if the user is not found.
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [UserCreate] userCreate (required):
  Future<UserSchema?> updateUserUsersUserIdPatch(String userId, UserCreate userCreate,) async {
    final response = await updateUserUsersUserIdPatchWithHttpInfo(userId, userCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserSchema',) as UserSchema;
    
    }
    return null;
  }
}
