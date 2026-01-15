//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ActionsApi {
  ActionsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Action
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ActionCreateSchema] actionCreateSchema (required):
  Future<Response> createActionActionsPostWithHttpInfo(ActionCreateSchema actionCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/';

    // ignore: prefer_final_locals
    Object? postBody = actionCreateSchema;

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

  /// Create Action
  ///
  /// Parameters:
  ///
  /// * [ActionCreateSchema] actionCreateSchema (required):
  Future<ActionSchema?> createActionActionsPost(ActionCreateSchema actionCreateSchema,) async {
    final response = await createActionActionsPostWithHttpInfo(actionCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActionSchema',) as ActionSchema;
    
    }
    return null;
  }

  /// Get Action
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  Future<Response> getActionActionsActionIdGetWithHttpInfo(String actionId,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/{action_id}'
      .replaceAll('{action_id}', actionId);

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

  /// Get Action
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  Future<ActionSchema?> getActionActionsActionIdGet(String actionId,) async {
    final response = await getActionActionsActionIdGetWithHttpInfo(actionId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ActionSchema',) as ActionSchema;
    
    }
    return null;
  }

  /// Get Actions By Initiative
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] initiativeId (required):
  Future<Response> getActionsByInitiativeActionsByInitiativeInitiativeIdGetWithHttpInfo(String initiativeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/by_initiative/{initiative_id}'
      .replaceAll('{initiative_id}', initiativeId);

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

  /// Get Actions By Initiative
  ///
  /// Parameters:
  ///
  /// * [String] initiativeId (required):
  Future<List<ActionSchema>?> getActionsByInitiativeActionsByInitiativeInitiativeIdGet(String initiativeId,) async {
    final response = await getActionsByInitiativeActionsByInitiativeInitiativeIdGetWithHttpInfo(initiativeId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ActionSchema>') as List)
        .cast<ActionSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Actions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] limit:
  Future<Response> listActionsActionsGetWithHttpInfo({ int? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
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

  /// List Actions
  ///
  /// Parameters:
  ///
  /// * [int] limit:
  Future<List<ActionSchema>?> listActionsActionsGet({ int? limit, }) async {
    final response = await listActionsActionsGetWithHttpInfo( limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ActionSchema>') as List)
        .cast<ActionSchema>()
        .toList(growable: false);

    }
    return null;
  }
}
