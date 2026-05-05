//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of collective_action_api;


class ActionsApi {
  ActionsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add Action Like
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [ActionLikeBody] actionLikeBody (required):
  Future<Response> addActionLikeActionsActionIdLikePostWithHttpInfo(String actionId, ActionLikeBody actionLikeBody,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/{action_id}/like'
      .replaceAll('{action_id}', actionId);

    // ignore: prefer_final_locals
    Object? postBody = actionLikeBody;

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

  /// Add Action Like
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [ActionLikeBody] actionLikeBody (required):
  Future<ActionSchema?> addActionLikeActionsActionIdLikePost(String actionId, ActionLikeBody actionLikeBody,) async {
    final response = await addActionLikeActionsActionIdLikePostWithHttpInfo(actionId, actionLikeBody,);
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

  /// Claim Trash Report Cleaned
  ///
  /// Create a cleanup from an active trash report and resolve the original report.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] trashReportId (required):
  ///
  /// * [ActionClaimCleanedSchema] actionClaimCleanedSchema (required):
  Future<Response> claimTrashReportCleanedActionsTrashReportIdClaimCleanedPostWithHttpInfo(String trashReportId, ActionClaimCleanedSchema actionClaimCleanedSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/{trash_report_id}/claim-cleaned'
      .replaceAll('{trash_report_id}', trashReportId);

    // ignore: prefer_final_locals
    Object? postBody = actionClaimCleanedSchema;

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

  /// Claim Trash Report Cleaned
  ///
  /// Create a cleanup from an active trash report and resolve the original report.
  ///
  /// Parameters:
  ///
  /// * [String] trashReportId (required):
  ///
  /// * [ActionClaimCleanedSchema] actionClaimCleanedSchema (required):
  Future<ActionSchema?> claimTrashReportCleanedActionsTrashReportIdClaimCleanedPost(String trashReportId, ActionClaimCleanedSchema actionClaimCleanedSchema,) async {
    final response = await claimTrashReportCleanedActionsTrashReportIdClaimCleanedPostWithHttpInfo(trashReportId, actionClaimCleanedSchema,);
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

  /// Delete Action
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  Future<Response> deleteActionActionsActionIdDeleteWithHttpInfo(String actionId,) async {
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
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete Action
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  Future<ActionSchema?> deleteActionActionsActionIdDelete(String actionId,) async {
    final response = await deleteActionActionsActionIdDeleteWithHttpInfo(actionId,);
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
  ///
  /// * [String] forUserId:
  ///   If set, includes whether this user liked the action.
  Future<Response> getActionActionsActionIdGetWithHttpInfo(String actionId, { String? forUserId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/{action_id}'
      .replaceAll('{action_id}', actionId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (forUserId != null) {
      queryParams.addAll(_queryParams('', 'for_user_id', forUserId));
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

  /// Get Action
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [String] forUserId:
  ///   If set, includes whether this user liked the action.
  Future<ActionSchema?> getActionActionsActionIdGet(String actionId, { String? forUserId, }) async {
    final response = await getActionActionsActionIdGetWithHttpInfo(actionId,  forUserId: forUserId, );
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

  /// Get Actions By Linked
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] linkedId (required):
  ///
  /// * [int] days:
  ///   Only return actions from the last N days
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  ///
  /// * [String] forUserId:
  ///   If set, each action includes whether this user liked it.
  Future<Response> getActionsByLinkedActionsByLinkedLinkedIdGetWithHttpInfo(String linkedId, { int? days, bool? includeInactive, String? forUserId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/by_linked/{linked_id}'
      .replaceAll('{linked_id}', linkedId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (days != null) {
      queryParams.addAll(_queryParams('', 'days', days));
    }
    if (includeInactive != null) {
      queryParams.addAll(_queryParams('', 'include_inactive', includeInactive));
    }
    if (forUserId != null) {
      queryParams.addAll(_queryParams('', 'for_user_id', forUserId));
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

  /// Get Actions By Linked
  ///
  /// Parameters:
  ///
  /// * [String] linkedId (required):
  ///
  /// * [int] days:
  ///   Only return actions from the last N days
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  ///
  /// * [String] forUserId:
  ///   If set, each action includes whether this user liked it.
  Future<List<ActionSchema>?> getActionsByLinkedActionsByLinkedLinkedIdGet(String linkedId, { int? days, bool? includeInactive, String? forUserId, }) async {
    final response = await getActionsByLinkedActionsByLinkedLinkedIdGetWithHttpInfo(linkedId,  days: days, includeInactive: includeInactive, forUserId: forUserId, );
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

  /// Get Actions By User
  ///
  /// All actions submitted by a specific user, newest first.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [int] limit:
  ///   Maximum number of actions to return
  ///
  /// * [ActionTypeValuesEnum] actionType:
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  Future<Response> getActionsByUserActionsUserUserIdGetWithHttpInfo(String userId, { int? limit, ActionTypeValuesEnum? actionType, bool? includeInactive, }) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/user/{user_id}'
      .replaceAll('{user_id}', userId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }
    if (actionType != null) {
      queryParams.addAll(_queryParams('', 'action_type', actionType));
    }
    if (includeInactive != null) {
      queryParams.addAll(_queryParams('', 'include_inactive', includeInactive));
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

  /// Get Actions By User
  ///
  /// All actions submitted by a specific user, newest first.
  ///
  /// Parameters:
  ///
  /// * [String] userId (required):
  ///
  /// * [int] limit:
  ///   Maximum number of actions to return
  ///
  /// * [ActionTypeValuesEnum] actionType:
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  Future<List<ActionSchema>?> getActionsByUserActionsUserUserIdGet(String userId, { int? limit, ActionTypeValuesEnum? actionType, bool? includeInactive, }) async {
    final response = await getActionsByUserActionsUserUserIdGetWithHttpInfo(userId,  limit: limit, actionType: actionType, includeInactive: includeInactive, );
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

  /// Get Latest Actions
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] days:
  ///
  /// * [ActionTypeValuesEnum] actionType:
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  ///
  /// * [String] forUserId:
  ///   If set, each action includes whether this user liked it.
  Future<Response> getLatestActionsActionsRecentGetWithHttpInfo({ int? days, ActionTypeValuesEnum? actionType, bool? includeInactive, String? forUserId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/recent';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (days != null) {
      queryParams.addAll(_queryParams('', 'days', days));
    }
    if (actionType != null) {
      queryParams.addAll(_queryParams('', 'action_type', actionType));
    }
    if (includeInactive != null) {
      queryParams.addAll(_queryParams('', 'include_inactive', includeInactive));
    }
    if (forUserId != null) {
      queryParams.addAll(_queryParams('', 'for_user_id', forUserId));
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

  /// Get Latest Actions
  ///
  /// Parameters:
  ///
  /// * [int] days:
  ///
  /// * [ActionTypeValuesEnum] actionType:
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  ///
  /// * [String] forUserId:
  ///   If set, each action includes whether this user liked it.
  Future<List<ActionSchema>?> getLatestActionsActionsRecentGet({ int? days, ActionTypeValuesEnum? actionType, bool? includeInactive, String? forUserId, }) async {
    final response = await getLatestActionsActionsRecentGetWithHttpInfo( days: days, actionType: actionType, includeInactive: includeInactive, forUserId: forUserId, );
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
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  ///
  /// * [String] forUserId:
  ///   If set, each action includes whether this user liked it.
  Future<Response> listActionsActionsGetWithHttpInfo({ int? limit, bool? includeInactive, String? forUserId, }) async {
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
    if (includeInactive != null) {
      queryParams.addAll(_queryParams('', 'include_inactive', includeInactive));
    }
    if (forUserId != null) {
      queryParams.addAll(_queryParams('', 'for_user_id', forUserId));
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
  ///
  /// * [bool] includeInactive:
  ///   Include resolved/inactive actions.
  ///
  /// * [String] forUserId:
  ///   If set, each action includes whether this user liked it.
  Future<List<ActionSchema>?> listActionsActionsGet({ int? limit, bool? includeInactive, String? forUserId, }) async {
    final response = await listActionsActionsGetWithHttpInfo( limit: limit, includeInactive: includeInactive, forUserId: forUserId, );
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

  /// Remove Action Like
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [String] userId (required):
  ///   Database id of the user unliking the action
  Future<Response> removeActionLikeActionsActionIdLikeDeleteWithHttpInfo(String actionId, String userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/{action_id}/like'
      .replaceAll('{action_id}', actionId);

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

  /// Remove Action Like
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [String] userId (required):
  ///   Database id of the user unliking the action
  Future<ActionSchema?> removeActionLikeActionsActionIdLikeDelete(String actionId, String userId,) async {
    final response = await removeActionLikeActionsActionIdLikeDeleteWithHttpInfo(actionId, userId,);
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

  /// Update Action
  ///
  /// Update a cleanup map submission owned by the requesting user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [ActionUpdateSchema] actionUpdateSchema (required):
  Future<Response> updateActionActionsActionIdPatchWithHttpInfo(String actionId, ActionUpdateSchema actionUpdateSchema,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/{action_id}'
      .replaceAll('{action_id}', actionId);

    // ignore: prefer_final_locals
    Object? postBody = actionUpdateSchema;

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

  /// Update Action
  ///
  /// Update a cleanup map submission owned by the requesting user.
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [ActionUpdateSchema] actionUpdateSchema (required):
  Future<ActionSchema?> updateActionActionsActionIdPatch(String actionId, ActionUpdateSchema actionUpdateSchema,) async {
    final response = await updateActionActionsActionIdPatchWithHttpInfo(actionId, actionUpdateSchema,);
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

  /// Update Action Photos
  ///
  /// Update the photo URLs for an action.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [ActionPhotosUpdate] actionPhotosUpdate (required):
  Future<Response> updateActionPhotosActionsActionIdPhotosPatchWithHttpInfo(String actionId, ActionPhotosUpdate actionPhotosUpdate,) async {
    // ignore: prefer_const_declarations
    final path = r'/actions/{action_id}/photos'
      .replaceAll('{action_id}', actionId);

    // ignore: prefer_final_locals
    Object? postBody = actionPhotosUpdate;

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

  /// Update Action Photos
  ///
  /// Update the photo URLs for an action.
  ///
  /// Parameters:
  ///
  /// * [String] actionId (required):
  ///
  /// * [ActionPhotosUpdate] actionPhotosUpdate (required):
  Future<ActionSchema?> updateActionPhotosActionsActionIdPhotosPatch(String actionId, ActionPhotosUpdate actionPhotosUpdate,) async {
    final response = await updateActionPhotosActionsActionIdPhotosPatchWithHttpInfo(actionId, actionPhotosUpdate,);
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
}
