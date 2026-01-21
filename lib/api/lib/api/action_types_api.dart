//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class ActionTypesApi {
  ActionTypesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Action Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ActionTypeCreate] actionTypeCreate (required):
  Future<Response> createActionTypeActionTypesPostWithHttpInfo(ActionTypeCreate actionTypeCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/action_types/';

    // ignore: prefer_final_locals
    Object? postBody = actionTypeCreate;

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

  /// Create Action Type
  ///
  /// Parameters:
  ///
  /// * [ActionTypeCreate] actionTypeCreate (required):
  Future<ActionTypeSchema?> createActionTypeActionTypesPost(ActionTypeCreate actionTypeCreate,) async {
    final response = await createActionTypeActionTypesPostWithHttpInfo(actionTypeCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActionTypeSchema',) as ActionTypeSchema;
    
    }
    return null;
  }

  /// Delete Action Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  Future<Response> deleteActionTypeActionTypesActionTypeIdDeleteWithHttpInfo(String actionTypeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/action_types/{action_type_id}'
      .replaceAll('{action_type_id}', actionTypeId);

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

  /// Delete Action Type
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  Future<Object?> deleteActionTypeActionTypesActionTypeIdDelete(String actionTypeId,) async {
    final response = await deleteActionTypeActionTypesActionTypeIdDeleteWithHttpInfo(actionTypeId,);
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

  /// Get Action Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  Future<Response> getActionTypeActionTypesActionTypeIdGetWithHttpInfo(String actionTypeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/action_types/{action_type_id}'
      .replaceAll('{action_type_id}', actionTypeId);

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

  /// Get Action Type
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  Future<ActionTypeSchema?> getActionTypeActionTypesActionTypeIdGet(String actionTypeId,) async {
    final response = await getActionTypeActionTypesActionTypeIdGetWithHttpInfo(actionTypeId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActionTypeSchema',) as ActionTypeSchema;
    
    }
    return null;
  }

  /// List Action Types
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listActionTypesActionTypesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/action_types/';

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

  /// List Action Types
  Future<List<ActionTypeSchema>?> listActionTypesActionTypesGet() async {
    final response = await listActionTypesActionTypesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ActionTypeSchema>') as List)
        .cast<ActionTypeSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update Action Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  ///
  /// * [ActionTypeCreate] actionTypeCreate (required):
  Future<Response> updateActionTypeActionTypesActionTypeIdPutWithHttpInfo(String actionTypeId, ActionTypeCreate actionTypeCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/action_types/{action_type_id}'
      .replaceAll('{action_type_id}', actionTypeId);

    // ignore: prefer_final_locals
    Object? postBody = actionTypeCreate;

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

  /// Update Action Type
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  ///
  /// * [ActionTypeCreate] actionTypeCreate (required):
  Future<ActionTypeSchema?> updateActionTypeActionTypesActionTypeIdPut(String actionTypeId, ActionTypeCreate actionTypeCreate,) async {
    final response = await updateActionTypeActionTypesActionTypeIdPutWithHttpInfo(actionTypeId, actionTypeCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActionTypeSchema',) as ActionTypeSchema;
    
    }
    return null;
  }
}
