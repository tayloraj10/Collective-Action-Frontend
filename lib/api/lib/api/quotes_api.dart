//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class QuotesApi {
  QuotesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Quote
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [QuoteCreateSchema] quoteCreateSchema (required):
  Future<Response> createQuoteQuotesPostWithHttpInfo(QuoteCreateSchema quoteCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/quotes/';

    // ignore: prefer_final_locals
    Object? postBody = quoteCreateSchema;

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

  /// Create Quote
  ///
  /// Parameters:
  ///
  /// * [QuoteCreateSchema] quoteCreateSchema (required):
  Future<QuoteSchema?> createQuoteQuotesPost(QuoteCreateSchema quoteCreateSchema,) async {
    final response = await createQuoteQuotesPostWithHttpInfo(quoteCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QuoteSchema',) as QuoteSchema;
    
    }
    return null;
  }

  /// Delete Quote
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] quoteId (required):
  Future<Response> deleteQuoteQuotesQuoteIdDeleteWithHttpInfo(String quoteId,) async {
    // ignore: prefer_const_declarations
    final path = r'/quotes/{quote_id}'
      .replaceAll('{quote_id}', quoteId);

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

  /// Delete Quote
  ///
  /// Parameters:
  ///
  /// * [String] quoteId (required):
  Future<void> deleteQuoteQuotesQuoteIdDelete(String quoteId,) async {
    final response = await deleteQuoteQuotesQuoteIdDeleteWithHttpInfo(quoteId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Quote
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] quoteId (required):
  Future<Response> getQuoteQuotesQuoteIdGetWithHttpInfo(String quoteId,) async {
    // ignore: prefer_const_declarations
    final path = r'/quotes/{quote_id}'
      .replaceAll('{quote_id}', quoteId);

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

  /// Get Quote
  ///
  /// Parameters:
  ///
  /// * [String] quoteId (required):
  Future<QuoteSchema?> getQuoteQuotesQuoteIdGet(String quoteId,) async {
    final response = await getQuoteQuotesQuoteIdGetWithHttpInfo(quoteId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QuoteSchema',) as QuoteSchema;
    
    }
    return null;
  }

  /// Get Random Quote
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getRandomQuoteQuotesRandomGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/quotes/random';

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

  /// Get Random Quote
  Future<QuoteSchema?> getRandomQuoteQuotesRandomGet() async {
    final response = await getRandomQuoteQuotesRandomGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QuoteSchema',) as QuoteSchema;
    
    }
    return null;
  }

  /// List Quotes
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listQuotesQuotesGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/quotes/';

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

  /// List Quotes
  Future<List<QuoteSchema>?> listQuotesQuotesGet() async {
    final response = await listQuotesQuotesGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<QuoteSchema>') as List)
        .cast<QuoteSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Update Quote
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] quoteId (required):
  ///
  /// * [QuoteCreateSchema] quoteCreateSchema (required):
  Future<Response> updateQuoteQuotesQuoteIdPatchWithHttpInfo(String quoteId, QuoteCreateSchema quoteCreateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/quotes/{quote_id}'
      .replaceAll('{quote_id}', quoteId);

    // ignore: prefer_final_locals
    Object? postBody = quoteCreateSchema;

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

  /// Update Quote
  ///
  /// Parameters:
  ///
  /// * [String] quoteId (required):
  ///
  /// * [QuoteCreateSchema] quoteCreateSchema (required):
  Future<QuoteSchema?> updateQuoteQuotesQuoteIdPatch(String quoteId, QuoteCreateSchema quoteCreateSchema,) async {
    final response = await updateQuoteQuotesQuoteIdPatchWithHttpInfo(quoteId, quoteCreateSchema,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'QuoteSchema',) as QuoteSchema;
    
    }
    return null;
  }
}
