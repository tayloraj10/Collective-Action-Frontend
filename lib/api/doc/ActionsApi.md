# collective_action_api.api.ActionsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addActionLikeActionsActionIdLikePost**](ActionsApi.md#addactionlikeactionsactionidlikepost) | **POST** /actions/{action_id}/like | Add Action Like
[**claimTrashReportCleanedActionsTrashReportIdClaimCleanedPost**](ActionsApi.md#claimtrashreportcleanedactionstrashreportidclaimcleanedpost) | **POST** /actions/{trash_report_id}/claim-cleaned | Claim Trash Report Cleaned
[**createActionActionsPost**](ActionsApi.md#createactionactionspost) | **POST** /actions/ | Create Action
[**deleteActionActionsActionIdDelete**](ActionsApi.md#deleteactionactionsactioniddelete) | **DELETE** /actions/{action_id} | Delete Action
[**getActionActionsActionIdGet**](ActionsApi.md#getactionactionsactionidget) | **GET** /actions/{action_id} | Get Action
[**getActionsByLinkedActionsByLinkedLinkedIdGet**](ActionsApi.md#getactionsbylinkedactionsbylinkedlinkedidget) | **GET** /actions/by_linked/{linked_id} | Get Actions By Linked
[**getActionsByUserActionsUserUserIdGet**](ActionsApi.md#getactionsbyuseractionsuseruseridget) | **GET** /actions/user/{user_id} | Get Actions By User
[**getLatestActionsActionsRecentGet**](ActionsApi.md#getlatestactionsactionsrecentget) | **GET** /actions/recent | Get Latest Actions
[**listActionsActionsGet**](ActionsApi.md#listactionsactionsget) | **GET** /actions/ | List Actions
[**removeActionLikeActionsActionIdLikeDelete**](ActionsApi.md#removeactionlikeactionsactionidlikedelete) | **DELETE** /actions/{action_id}/like | Remove Action Like
[**updateActionActionsActionIdPatch**](ActionsApi.md#updateactionactionsactionidpatch) | **PATCH** /actions/{action_id} | Update Action
[**updateActionPhotosActionsActionIdPhotosPatch**](ActionsApi.md#updateactionphotosactionsactionidphotospatch) | **PATCH** /actions/{action_id}/photos | Update Action Photos


# **addActionLikeActionsActionIdLikePost**
> ActionSchema addActionLikeActionsActionIdLikePost(actionId, actionLikeBody)

Add Action Like

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final actionLikeBody = ActionLikeBody(); // ActionLikeBody | 

try {
    final result = api_instance.addActionLikeActionsActionIdLikePost(actionId, actionLikeBody);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->addActionLikeActionsActionIdLikePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  | 
 **actionLikeBody** | [**ActionLikeBody**](ActionLikeBody.md)|  | 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **claimTrashReportCleanedActionsTrashReportIdClaimCleanedPost**
> ActionSchema claimTrashReportCleanedActionsTrashReportIdClaimCleanedPost(trashReportId, actionClaimCleanedSchema)

Claim Trash Report Cleaned

Create a cleanup from an active trash report and resolve the original report.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final trashReportId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final actionClaimCleanedSchema = ActionClaimCleanedSchema(); // ActionClaimCleanedSchema | 

try {
    final result = api_instance.claimTrashReportCleanedActionsTrashReportIdClaimCleanedPost(trashReportId, actionClaimCleanedSchema);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->claimTrashReportCleanedActionsTrashReportIdClaimCleanedPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **trashReportId** | **String**|  | 
 **actionClaimCleanedSchema** | [**ActionClaimCleanedSchema**](ActionClaimCleanedSchema.md)|  | 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createActionActionsPost**
> ActionSchema createActionActionsPost(actionCreateSchema)

Create Action

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionCreateSchema = ActionCreateSchema(); // ActionCreateSchema | 

try {
    final result = api_instance.createActionActionsPost(actionCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->createActionActionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionCreateSchema** | [**ActionCreateSchema**](ActionCreateSchema.md)|  | 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteActionActionsActionIdDelete**
> ActionSchema deleteActionActionsActionIdDelete(actionId)

Delete Action

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.deleteActionActionsActionIdDelete(actionId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->deleteActionActionsActionIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  | 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActionActionsActionIdGet**
> ActionSchema getActionActionsActionIdGet(actionId, forUserId)

Get Action

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final forUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | If set, includes whether this user liked the action.

try {
    final result = api_instance.getActionActionsActionIdGet(actionId, forUserId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getActionActionsActionIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  | 
 **forUserId** | **String**| If set, includes whether this user liked the action. | [optional] 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActionsByLinkedActionsByLinkedLinkedIdGet**
> List<ActionSchema> getActionsByLinkedActionsByLinkedLinkedIdGet(linkedId, days, includeInactive, forUserId)

Get Actions By Linked

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final linkedId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final days = 56; // int | Only return actions from the last N days
final includeInactive = true; // bool | Include resolved/inactive actions.
final forUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | If set, each action includes whether this user liked it.

try {
    final result = api_instance.getActionsByLinkedActionsByLinkedLinkedIdGet(linkedId, days, includeInactive, forUserId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getActionsByLinkedActionsByLinkedLinkedIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **linkedId** | **String**|  | 
 **days** | **int**| Only return actions from the last N days | [optional] 
 **includeInactive** | **bool**| Include resolved/inactive actions. | [optional] [default to false]
 **forUserId** | **String**| If set, each action includes whether this user liked it. | [optional] 

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActionsByUserActionsUserUserIdGet**
> List<ActionSchema> getActionsByUserActionsUserUserIdGet(userId, limit, actionType, includeInactive)

Get Actions By User

All actions submitted by a specific user, newest first.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final limit = 56; // int | Maximum number of actions to return
final actionType = ; // ActionTypeValuesEnum | 
final includeInactive = true; // bool | Include resolved/inactive actions.

try {
    final result = api_instance.getActionsByUserActionsUserUserIdGet(userId, limit, actionType, includeInactive);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getActionsByUserActionsUserUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **limit** | **int**| Maximum number of actions to return | [optional] 
 **actionType** | [**ActionTypeValuesEnum**](.md)|  | [optional] 
 **includeInactive** | **bool**| Include resolved/inactive actions. | [optional] [default to false]

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLatestActionsActionsRecentGet**
> List<ActionSchema> getLatestActionsActionsRecentGet(days, actionType, includeInactive, forUserId)

Get Latest Actions

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final days = 56; // int | 
final actionType = ; // ActionTypeValuesEnum | 
final includeInactive = true; // bool | Include resolved/inactive actions.
final forUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | If set, each action includes whether this user liked it.

try {
    final result = api_instance.getLatestActionsActionsRecentGet(days, actionType, includeInactive, forUserId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getLatestActionsActionsRecentGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **days** | **int**|  | [optional] [default to 30]
 **actionType** | [**ActionTypeValuesEnum**](.md)|  | [optional] 
 **includeInactive** | **bool**| Include resolved/inactive actions. | [optional] [default to false]
 **forUserId** | **String**| If set, each action includes whether this user liked it. | [optional] 

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listActionsActionsGet**
> List<ActionSchema> listActionsActionsGet(limit, includeInactive, forUserId)

List Actions

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final limit = 56; // int | 
final includeInactive = true; // bool | Include resolved/inactive actions.
final forUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | If set, each action includes whether this user liked it.

try {
    final result = api_instance.listActionsActionsGet(limit, includeInactive, forUserId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->listActionsActionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] 
 **includeInactive** | **bool**| Include resolved/inactive actions. | [optional] [default to false]
 **forUserId** | **String**| If set, each action includes whether this user liked it. | [optional] 

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeActionLikeActionsActionIdLikeDelete**
> ActionSchema removeActionLikeActionsActionIdLikeDelete(actionId, userId)

Remove Action Like

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Database id of the user unliking the action

try {
    final result = api_instance.removeActionLikeActionsActionIdLikeDelete(actionId, userId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->removeActionLikeActionsActionIdLikeDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  | 
 **userId** | **String**| Database id of the user unliking the action | 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateActionActionsActionIdPatch**
> ActionSchema updateActionActionsActionIdPatch(actionId, actionUpdateSchema)

Update Action

Update a cleanup map submission owned by the requesting user.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final actionUpdateSchema = ActionUpdateSchema(); // ActionUpdateSchema | 

try {
    final result = api_instance.updateActionActionsActionIdPatch(actionId, actionUpdateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->updateActionActionsActionIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  | 
 **actionUpdateSchema** | [**ActionUpdateSchema**](ActionUpdateSchema.md)|  | 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateActionPhotosActionsActionIdPhotosPatch**
> ActionSchema updateActionPhotosActionsActionIdPhotosPatch(actionId, actionPhotosUpdate)

Update Action Photos

Update the photo URLs for an action.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final actionPhotosUpdate = ActionPhotosUpdate(); // ActionPhotosUpdate | 

try {
    final result = api_instance.updateActionPhotosActionsActionIdPhotosPatch(actionId, actionPhotosUpdate);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->updateActionPhotosActionsActionIdPhotosPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  | 
 **actionPhotosUpdate** | [**ActionPhotosUpdate**](ActionPhotosUpdate.md)|  | 

### Return type

[**ActionSchema**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

