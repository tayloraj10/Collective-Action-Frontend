//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class ConfigApi {
  ConfigApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Action Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ActionTypeCreate] actionTypeCreate (required):
  Future<Response> createActionTypeConfigActionTypesPostWithHttpInfo(ActionTypeCreate actionTypeCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/action_types';

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
  Future<ActionTypeSchema?> createActionTypeConfigActionTypesPost(ActionTypeCreate actionTypeCreate,) async {
    final response = await createActionTypeConfigActionTypesPostWithHttpInfo(actionTypeCreate,);
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

  /// Create Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CategoryCreate] categoryCreate (required):
  Future<Response> createCategoryConfigCategoriesPostWithHttpInfo(CategoryCreate categoryCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/categories';

    // ignore: prefer_final_locals
    Object? postBody = categoryCreate;

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

  /// Create Category
  ///
  /// Parameters:
  ///
  /// * [CategoryCreate] categoryCreate (required):
  Future<CategorySchema?> createCategoryConfigCategoriesPost(CategoryCreate categoryCreate,) async {
    final response = await createCategoryConfigCategoriesPostWithHttpInfo(categoryCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CategorySchema',) as CategorySchema;
    
    }
    return null;
  }

  /// Create Status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [StatusCreate] statusCreate (required):
  Future<Response> createStatusConfigStatusesPostWithHttpInfo(StatusCreate statusCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/statuses';

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
  Future<StatusSchema?> createStatusConfigStatusesPost(StatusCreate statusCreate,) async {
    final response = await createStatusConfigStatusesPostWithHttpInfo(statusCreate,);
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

  /// Delete Action Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  Future<Response> deleteActionTypeConfigActionTypesActionTypeIdDeleteWithHttpInfo(String actionTypeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/action_types/{action_type_id}'
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
  Future<Object?> deleteActionTypeConfigActionTypesActionTypeIdDelete(String actionTypeId,) async {
    final response = await deleteActionTypeConfigActionTypesActionTypeIdDeleteWithHttpInfo(actionTypeId,);
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

  /// Delete Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<Response> deleteCategoryConfigCategoriesCategoryIdDeleteWithHttpInfo(String categoryId,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/categories/{category_id}'
      .replaceAll('{category_id}', categoryId);

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

  /// Delete Category
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<Object?> deleteCategoryConfigCategoriesCategoryIdDelete(String categoryId,) async {
    final response = await deleteCategoryConfigCategoriesCategoryIdDeleteWithHttpInfo(categoryId,);
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

  /// Delete Status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] statusId (required):
  Future<Response> deleteStatusConfigStatusesStatusIdDeleteWithHttpInfo(String statusId,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/statuses/{status_id}'
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
  Future<Object?> deleteStatusConfigStatusesStatusIdDelete(String statusId,) async {
    final response = await deleteStatusConfigStatusesStatusIdDeleteWithHttpInfo(statusId,);
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
  Future<Response> getActionTypeConfigActionTypesActionTypeIdGetWithHttpInfo(String actionTypeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/action_types/{action_type_id}'
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
  Future<ActionTypeSchema?> getActionTypeConfigActionTypesActionTypeIdGet(String actionTypeId,) async {
    final response = await getActionTypeConfigActionTypesActionTypeIdGetWithHttpInfo(actionTypeId,);
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

  /// Get Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<Response> getCategoryConfigCategoriesCategoryIdGetWithHttpInfo(String categoryId,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/categories/{category_id}'
      .replaceAll('{category_id}', categoryId);

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

  /// Get Category
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<CategorySchema?> getCategoryConfigCategoriesCategoryIdGet(String categoryId,) async {
    final response = await getCategoryConfigCategoriesCategoryIdGetWithHttpInfo(categoryId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CategorySchema',) as CategorySchema;
    
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
  Future<Response> getStatusConfigStatusesStatusIdGetWithHttpInfo(String statusId,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/statuses/{status_id}'
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
  Future<StatusSchema?> getStatusConfigStatusesStatusIdGet(String statusId,) async {
    final response = await getStatusConfigStatusesStatusIdGetWithHttpInfo(statusId,);
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

  /// List Action Types
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listActionTypesConfigActionTypesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/config/action_types';

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
  Future<List<ActionTypeSchema>?> listActionTypesConfigActionTypesGet() async {
    final response = await listActionTypesConfigActionTypesGetWithHttpInfo();
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

  /// List Categories
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listCategoriesConfigCategoriesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/config/categories';

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

  /// List Categories
  Future<List<CategorySchema>?> listCategoriesConfigCategoriesGet() async {
    final response = await listCategoriesConfigCategoriesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<CategorySchema>') as List)
        .cast<CategorySchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Statuses
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listStatusesConfigStatusesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/config/statuses';

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
  Future<List<StatusSchema>?> listStatusesConfigStatusesGet() async {
    final response = await listStatusesConfigStatusesGetWithHttpInfo();
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

  /// Update Action Type
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionTypeId (required):
  ///
  /// * [ActionTypeCreate] actionTypeCreate (required):
  Future<Response> updateActionTypeConfigActionTypesActionTypeIdPutWithHttpInfo(String actionTypeId, ActionTypeCreate actionTypeCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/action_types/{action_type_id}'
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
  Future<ActionTypeSchema?> updateActionTypeConfigActionTypesActionTypeIdPut(String actionTypeId, ActionTypeCreate actionTypeCreate,) async {
    final response = await updateActionTypeConfigActionTypesActionTypeIdPutWithHttpInfo(actionTypeId, actionTypeCreate,);
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

  /// Update Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  ///
  /// * [CategoryCreate] categoryCreate (required):
  Future<Response> updateCategoryConfigCategoriesCategoryIdPutWithHttpInfo(String categoryId, CategoryCreate categoryCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/categories/{category_id}'
      .replaceAll('{category_id}', categoryId);

    // ignore: prefer_final_locals
    Object? postBody = categoryCreate;

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

  /// Update Category
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  ///
  /// * [CategoryCreate] categoryCreate (required):
  Future<CategorySchema?> updateCategoryConfigCategoriesCategoryIdPut(String categoryId, CategoryCreate categoryCreate,) async {
    final response = await updateCategoryConfigCategoriesCategoryIdPutWithHttpInfo(categoryId, categoryCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CategorySchema',) as CategorySchema;
    
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
  Future<Response> updateStatusConfigStatusesStatusIdPutWithHttpInfo(String statusId, StatusCreate statusCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/config/statuses/{status_id}'
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
  Future<StatusSchema?> updateStatusConfigStatusesStatusIdPut(String statusId, StatusCreate statusCreate,) async {
    final response = await updateStatusConfigStatusesStatusIdPutWithHttpInfo(statusId, statusCreate,);
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
