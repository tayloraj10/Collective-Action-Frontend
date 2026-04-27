# collective_action_api.api.ActionsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addActionLikeActionsActionIdLikePost**](ActionsApi.md#addactionlikeactionsactionidlikepost) | **POST** /actions/{action_id}/like | Add Action Like
[**createActionActionsPost**](ActionsApi.md#createactionactionspost) | **POST** /actions/ | Create Action
[**deleteActionActionsActionIdDelete**](ActionsApi.md#deleteactionactionsactioniddelete) | **DELETE** /actions/{action_id} | Delete Action
[**getActionActionsActionIdGet**](ActionsApi.md#getactionactionsactionidget) | **GET** /actions/{action_id} | Get Action
[**getActionsByLinkedActionsByLinkedLinkedIdGet**](ActionsApi.md#getactionsbylinkedactionsbylinkedlinkedidget) | **GET** /actions/by_linked/{linked_id} | Get Actions By Linked
[**getLatestActionsActionsRecentGet**](ActionsApi.md#getlatestactionsactionsrecentget) | **GET** /actions/recent | Get Latest Actions
[**listActionsActionsGet**](ActionsApi.md#listactionsactionsget) | **GET** /actions/ | List Actions
[**removeActionLikeActionsActionIdLikeDelete**](ActionsApi.md#removeactionlikeactionsactionidlikedelete) | **DELETE** /actions/{action_id}/like | Remove Action Like
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
> List<ActionSchema> getActionsByLinkedActionsByLinkedLinkedIdGet(linkedId, days, forUserId)

Get Actions By Linked

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final linkedId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final days = 56; // int | Only return actions from the last N days
final forUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | If set, each action includes whether this user liked it.

try {
    final result = api_instance.getActionsByLinkedActionsByLinkedLinkedIdGet(linkedId, days, forUserId);
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
 **forUserId** | **String**| If set, each action includes whether this user liked it. | [optional] 

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLatestActionsActionsRecentGet**
> List<ActionSchema> getLatestActionsActionsRecentGet(days, actionType, forUserId)

Get Latest Actions

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final days = 56; // int | 
final actionType = ; // ActionTypeValuesEnum | 
final forUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | If set, each action includes whether this user liked it.

try {
    final result = api_instance.getLatestActionsActionsRecentGet(days, actionType, forUserId);
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
> List<ActionSchema> listActionsActionsGet(limit, forUserId)

List Actions

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final limit = 56; // int | 
final forUserId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | If set, each action includes whether this user liked it.

try {
    final result = api_instance.listActionsActionsGet(limit, forUserId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->listActionsActionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] 
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

