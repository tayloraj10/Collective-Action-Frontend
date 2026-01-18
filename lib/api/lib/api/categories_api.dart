//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class CategoriesApi {
  CategoriesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CategoryCreate] categoryCreate (required):
  Future<Response> createCategoryCategoriesPostWithHttpInfo(CategoryCreate categoryCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/categories/';

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
  Future<CategorySchema?> createCategoryCategoriesPost(CategoryCreate categoryCreate,) async {
    final response = await createCategoryCategoriesPostWithHttpInfo(categoryCreate,);
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

  /// Delete Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<Response> deleteCategoryCategoriesCategoryIdDeleteWithHttpInfo(String categoryId,) async {
    // ignore: prefer_const_declarations
    final path = r'/categories/{category_id}'
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
  Future<Object?> deleteCategoryCategoriesCategoryIdDelete(String categoryId,) async {
    final response = await deleteCategoryCategoriesCategoryIdDeleteWithHttpInfo(categoryId,);
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

  /// Get Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<Response> getCategoryCategoriesCategoryIdGetWithHttpInfo(String categoryId,) async {
    // ignore: prefer_const_declarations
    final path = r'/categories/{category_id}'
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
  Future<CategorySchema?> getCategoryCategoriesCategoryIdGet(String categoryId,) async {
    final response = await getCategoryCategoriesCategoryIdGetWithHttpInfo(categoryId,);
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

  /// List Categories
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listCategoriesCategoriesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/categories/';

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
  Future<List<CategorySchema>?> listCategoriesCategoriesGet() async {
    final response = await listCategoriesCategoriesGetWithHttpInfo();
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

  /// Update Category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  ///
  /// * [CategoryCreate] categoryCreate (required):
  Future<Response> updateCategoryCategoriesCategoryIdPutWithHttpInfo(String categoryId, CategoryCreate categoryCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/categories/{category_id}'
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
  Future<CategorySchema?> updateCategoryCategoriesCategoryIdPut(String categoryId, CategoryCreate categoryCreate,) async {
    final response = await updateCategoryCategoriesCategoryIdPutWithHttpInfo(categoryId, categoryCreate,);
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
}
