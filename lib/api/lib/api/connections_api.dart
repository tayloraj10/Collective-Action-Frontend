//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class ConnectionsApi {
  ConnectionsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Connection
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ConnectionCreateSchema] connectionCreateSchema (required):
  Future<Response> createConnectionConnectionsPostWithHttpInfo(ConnectionCreateSchema connectionCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/connections/';

    // ignore: prefer_final_locals
    Object? postBody = connectionCreateSchema;

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

  /// Create Connection
  ///
  /// Parameters:
  ///
  /// * [ConnectionCreateSchema] connectionCreateSchema (required):
  Future<ConnectionSchema?> createConnectionConnectionsPost(ConnectionCreateSchema connectionCreateSchema,) async {
    final response = await createConnectionConnectionsPostWithHttpInfo(connectionCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConnectionSchema',) as ConnectionSchema;
    
    }
    return null;
  }

  /// Delete Connection
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] connectionId (required):
  ///
  /// * [String] userId (required):
  ///   ID of the user requesting deletion
  Future<Response> deleteConnectionConnectionsConnectionIdDeleteWithHttpInfo(String connectionId, String userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/connections/{connection_id}'
      .replaceAll('{connection_id}', connectionId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'user_id', userId));

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

  /// Delete Connection
  ///
  /// Parameters:
  ///
  /// * [String] connectionId (required):
  ///
  /// * [String] userId (required):
  ///   ID of the user requesting deletion
  Future<void> deleteConnectionConnectionsConnectionIdDelete(String connectionId, String userId,) async {
    final response = await deleteConnectionConnectionsConnectionIdDeleteWithHttpInfo(connectionId, userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Connection Summary
  ///
  /// Aggregated connection counts + avatar previews for every entity of `to_type`. One request covers all cards on the Connect screen.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] toType (required):
  Future<Response> getConnectionSummaryConnectionsSummaryToTypeGetWithHttpInfo(String toType,) async {
    // ignore: prefer_const_declarations
    final path = r'/connections/summary/{to_type}'
      .replaceAll('{to_type}', toType);

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

  /// Get Connection Summary
  ///
  /// Aggregated connection counts + avatar previews for every entity of `to_type`. One request covers all cards on the Connect screen.
  ///
  /// Parameters:
  ///
  /// * [String] toType (required):
  Future<List<ConnectionSummarySchema>?> getConnectionSummaryConnectionsSummaryToTypeGet(String toType,) async {
    final response = await getConnectionSummaryConnectionsSummaryToTypeGetWithHttpInfo(toType,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ConnectionSummarySchema>') as List)
        .cast<ConnectionSummarySchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get Connections For Entity
  ///
  /// All connections to a specific entity, optionally filtered by type.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] toType (required):
  ///
  /// * [String] toId (required):
  ///
  /// * [String] connectionType:
  ///   Filter by connection_type
  Future<Response> getConnectionsForEntityConnectionsEntityToTypeToIdGetWithHttpInfo(String toType, String toId, { String? connectionType, }) async {
    // ignore: prefer_const_declarations
    final path = r'/connections/entity/{to_type}/{to_id}'
      .replaceAll('{to_type}', toType)
      .replaceAll('{to_id}', toId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (connectionType != null) {
      queryParams.addAll(_queryParams('', 'connection_type', connectionType));
    }

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

  /// Get Connections For Entity
  ///
  /// All connections to a specific entity, optionally filtered by type.
  ///
  /// Parameters:
  ///
  /// * [String] toType (required):
  ///
  /// * [String] toId (required):
  ///
  /// * [String] connectionType:
  ///   Filter by connection_type
  Future<List<ConnectionWithUserSchema>?> getConnectionsForEntityConnectionsEntityToTypeToIdGet(String toType, String toId, { String? connectionType, }) async {
    final response = await getConnectionsForEntityConnectionsEntityToTypeToIdGetWithHttpInfo(toType, toId,  connectionType: connectionType, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ConnectionWithUserSchema>') as List)
        .cast<ConnectionWithUserSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get Connections For User
  ///
  /// All connections created by a specific user, optionally filtered by type.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [String] connectionType:
  Future<Response> getConnectionsForUserConnectionsUserUserIdGetWithHttpInfo(String userId, { String? connectionType, }) async {
    // ignore: prefer_const_declarations
    final path = r'/connections/user/{user_id}'
      .replaceAll('{user_id}', userId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (connectionType != null) {
      queryParams.addAll(_queryParams('', 'connection_type', connectionType));
    }

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

  /// Get Connections For User
  ///
  /// All connections created by a specific user, optionally filtered by type.
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [String] connectionType:
  Future<List<ConnectionSchema>?> getConnectionsForUserConnectionsUserUserIdGet(String userId, { String? connectionType, }) async {
    final response = await getConnectionsForUserConnectionsUserUserIdGetWithHttpInfo(userId,  connectionType: connectionType, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ConnectionSchema>') as List)
        .cast<ConnectionSchema>()
        .toList(growable: false);

    }
    return null;
  }
}
