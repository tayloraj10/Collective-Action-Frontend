//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class StatusesApi {
  StatusesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [StatusCreate] statusCreate (required):
  Future<Response> createStatusStatusesPostWithHttpInfo(StatusCreate statusCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/statuses/';

    // ignore: prefer_final_locals
    Object? postBody = statusCreate;

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

  /// Create Status
  ///
  /// Parameters:
  ///
  /// * [StatusCreate] statusCreate (required):
  Future<StatusSchema?> createStatusStatusesPost(StatusCreate statusCreate,) async {
    final response = await createStatusStatusesPostWithHttpInfo(statusCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StatusSchema',) as StatusSchema;
    
    }
    return null;
  }

  /// Delete Status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] statusId (required):
  Future<Response> deleteStatusStatusesStatusIdDeleteWithHttpInfo(String statusId,) async {
    // ignore: prefer_const_declarations
    final path = r'/statuses/{status_id}'
      .replaceAll('{status_id}', statusId);

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

  /// Delete Status
  ///
  /// Parameters:
  ///
  /// * [String] statusId (required):
  Future<Object?> deleteStatusStatusesStatusIdDelete(String statusId,) async {
    final response = await deleteStatusStatusesStatusIdDeleteWithHttpInfo(statusId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Get Status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] statusId (required):
  Future<Response> getStatusStatusesStatusIdGetWithHttpInfo(String statusId,) async {
    // ignore: prefer_const_declarations
    final path = r'/statuses/{status_id}'
      .replaceAll('{status_id}', statusId);

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

  /// Get Status
  ///
  /// Parameters:
  ///
  /// * [String] statusId (required):
  Future<StatusSchema?> getStatusStatusesStatusIdGet(String statusId,) async {
    final response = await getStatusStatusesStatusIdGetWithHttpInfo(statusId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StatusSchema',) as StatusSchema;
    
    }
    return null;
  }

  /// Get Statuses By Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] statusType (required):
  Future<Response> getStatusesByTypeStatusesByTypeStatusTypeGetWithHttpInfo(String statusType,) async {
    // ignore: prefer_const_declarations
    final path = r'/statuses/by_type/{status_type}'
      .replaceAll('{status_type}', statusType);

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

  /// Get Statuses By Type
  ///
  /// Parameters:
  ///
  /// * [String] statusType (required):
  Future<List<StatusSchema>?> getStatusesByTypeStatusesByTypeStatusTypeGet(String statusType,) async {
    final response = await getStatusesByTypeStatusesByTypeStatusTypeGetWithHttpInfo(statusType,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<StatusSchema>') as List)
        .cast<StatusSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Statuses
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listStatusesStatusesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/statuses/';

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

  /// List Statuses
  Future<List<StatusSchema>?> listStatusesStatusesGet() async {
    final response = await listStatusesStatusesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<StatusSchema>') as List)
        .cast<StatusSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update Status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] statusId (required):
  ///
  /// * [StatusCreate] statusCreate (required):
  Future<Response> updateStatusStatusesStatusIdPutWithHttpInfo(String statusId, StatusCreate statusCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/statuses/{status_id}'
      .replaceAll('{status_id}', statusId);

    // ignore: prefer_final_locals
    Object? postBody = statusCreate;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update Status
  ///
  /// Parameters:
  ///
  /// * [String] statusId (required):
  ///
  /// * [StatusCreate] statusCreate (required):
  Future<StatusSchema?> updateStatusStatusesStatusIdPut(String statusId, StatusCreate statusCreate,) async {
    final response = await updateStatusStatusesStatusIdPutWithHttpInfo(statusId, statusCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StatusSchema',) as StatusSchema;
    
    }
    return null;
  }
}
