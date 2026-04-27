//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class DirectoryOfGoodApi {
  DirectoryOfGoodApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create Entry
  ///
  /// Create a new directory of good entry and an action record.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [DirectoryOfGoodCreate] directoryOfGoodCreate (required):
  Future<Response> createEntryDirectoryOfGoodPostWithHttpInfo(DirectoryOfGoodCreate directoryOfGoodCreate,) async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/';

    // ignore: prefer_final_locals
    Object? postBody = directoryOfGoodCreate;

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

  /// Create Entry
  ///
  /// Create a new directory of good entry and an action record.
  ///
  /// Parameters:
  ///
  /// * [DirectoryOfGoodCreate] directoryOfGoodCreate (required):
  Future<DirectoryOfGoodSchema?> createEntryDirectoryOfGoodPost(DirectoryOfGoodCreate directoryOfGoodCreate,) async {
    final response = await createEntryDirectoryOfGoodPostWithHttpInfo(directoryOfGoodCreate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DirectoryOfGoodSchema',) as DirectoryOfGoodSchema;
    
    }
    return null;
  }

  /// Delete Entry
  ///
  /// Delete a directory of good entry.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  Future<Response> deleteEntryDirectoryOfGoodEntryIdDeleteWithHttpInfo(String entryId,) async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/{entry_id}'
      .replaceAll('{entry_id}', entryId);

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

  /// Delete Entry
  ///
  /// Delete a directory of good entry.
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  Future<void> deleteEntryDirectoryOfGoodEntryIdDelete(String entryId,) async {
    final response = await deleteEntryDirectoryOfGoodEntryIdDeleteWithHttpInfo(entryId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get Entry
  ///
  /// Get a single directory of good entry by ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  Future<Response> getEntryDirectoryOfGoodEntryIdGetWithHttpInfo(String entryId,) async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/{entry_id}'
      .replaceAll('{entry_id}', entryId);

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

  /// Get Entry
  ///
  /// Get a single directory of good entry by ID.
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  Future<DirectoryOfGoodSchema?> getEntryDirectoryOfGoodEntryIdGet(String entryId,) async {
    final response = await getEntryDirectoryOfGoodEntryIdGetWithHttpInfo(entryId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DirectoryOfGoodSchema',) as DirectoryOfGoodSchema;
    
    }
    return null;
  }

  /// List Entries By User
  ///
  /// List directory entries linked to a specific user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<Response> listEntriesByUserDirectoryOfGoodByUserUserIdGetWithHttpInfo(String userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/by-user/{user_id}'
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

  /// List Entries By User
  ///
  /// List directory entries linked to a specific user.
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  Future<List<DirectoryOfGoodSchema>?> listEntriesByUserDirectoryOfGoodByUserUserIdGet(String userId,) async {
    final response = await listEntriesByUserDirectoryOfGoodByUserUserIdGetWithHttpInfo(userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<DirectoryOfGoodSchema>') as List)
        .cast<DirectoryOfGoodSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// List Entries
  ///
  /// List all directory of good entries.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> listEntriesDirectoryOfGoodGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/';

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

  /// List Entries
  ///
  /// List all directory of good entries.
  Future<List<DirectoryOfGoodSchema>?> listEntriesDirectoryOfGoodGet() async {
    final response = await listEntriesDirectoryOfGoodGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<DirectoryOfGoodSchema>') as List)
        .cast<DirectoryOfGoodSchema>()
        .toList(growable: false);

    }
    return null;
  }

  /// Set Featured
  ///
  /// Feature or unfeature a directory of good entry.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  ///
  /// * [FeatureUpdate] featureUpdate (required):
  Future<Response> setFeaturedDirectoryOfGoodEntryIdFeaturePatchWithHttpInfo(String entryId, FeatureUpdate featureUpdate,) async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/{entry_id}/feature'
      .replaceAll('{entry_id}', entryId);

    // ignore: prefer_final_locals
    Object? postBody = featureUpdate;

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

  /// Set Featured
  ///
  /// Feature or unfeature a directory of good entry.
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  ///
  /// * [FeatureUpdate] featureUpdate (required):
  Future<DirectoryOfGoodSchema?> setFeaturedDirectoryOfGoodEntryIdFeaturePatch(String entryId, FeatureUpdate featureUpdate,) async {
    final response = await setFeaturedDirectoryOfGoodEntryIdFeaturePatchWithHttpInfo(entryId, featureUpdate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DirectoryOfGoodSchema',) as DirectoryOfGoodSchema;
    
    }
    return null;
  }

  /// Sync From Google Sheet
  ///
  /// Upsert directory rows from the configured 'Interesting People' Google Sheet.  **Credentials:** If ``GOOGLE_APPLICATION_CREDENTIALS`` is set to a service account JSON path, that key is used. Otherwise **Application Default Credentials** are used (e.g. Cloud Run / GCE runtime service account). Enable the Google Sheets API for the project and share the spreadsheet with that service account email.  When ``DIRECTORY_GOOGLE_SHEET_SYNC_SECRET`` is set, the same value must be sent in the ``X-Sync-Secret`` header.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xSyncSecret:
  Future<Response> syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPostWithHttpInfo({ String? xSyncSecret, }) async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/sync-from-google-sheet';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (xSyncSecret != null) {
      headerParams[r'X-Sync-Secret'] = parameterToString(xSyncSecret);
    }

    const contentTypes = <String>[];


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

  /// Sync From Google Sheet
  ///
  /// Upsert directory rows from the configured 'Interesting People' Google Sheet.  **Credentials:** If ``GOOGLE_APPLICATION_CREDENTIALS`` is set to a service account JSON path, that key is used. Otherwise **Application Default Credentials** are used (e.g. Cloud Run / GCE runtime service account). Enable the Google Sheets API for the project and share the spreadsheet with that service account email.  When ``DIRECTORY_GOOGLE_SHEET_SYNC_SECRET`` is set, the same value must be sent in the ``X-Sync-Secret`` header.
  ///
  /// Parameters:
  ///
  /// * [String] xSyncSecret:
  Future<SheetSyncResponse?> syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPost({ String? xSyncSecret, }) async {
    final response = await syncFromGoogleSheetDirectoryOfGoodSyncFromGoogleSheetPostWithHttpInfo( xSyncSecret: xSyncSecret, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SheetSyncResponse',) as SheetSyncResponse;
    
    }
    return null;
  }

  /// Update Entry
  ///
  /// Update a directory of good entry (partial update).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  ///
  /// * [DirectoryOfGoodUpdate] directoryOfGoodUpdate (required):
  Future<Response> updateEntryDirectoryOfGoodEntryIdPatchWithHttpInfo(String entryId, DirectoryOfGoodUpdate directoryOfGoodUpdate,) async {
    // ignore: prefer_const_declarations
    final path = r'/directory-of-good/{entry_id}'
      .replaceAll('{entry_id}', entryId);

    // ignore: prefer_final_locals
    Object? postBody = directoryOfGoodUpdate;

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

  /// Update Entry
  ///
  /// Update a directory of good entry (partial update).
  ///
  /// Parameters:
  ///
  /// * [String] entryId (required):
  ///
  /// * [DirectoryOfGoodUpdate] directoryOfGoodUpdate (required):
  Future<DirectoryOfGoodSchema?> updateEntryDirectoryOfGoodEntryIdPatch(String entryId, DirectoryOfGoodUpdate directoryOfGoodUpdate,) async {
    final response = await updateEntryDirectoryOfGoodEntryIdPatchWithHttpInfo(entryId, directoryOfGoodUpdate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DirectoryOfGoodSchema',) as DirectoryOfGoodSchema;
    
    }
    return null;
  }
}
