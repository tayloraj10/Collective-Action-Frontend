# collective_action_api.api.ActionsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createActionActionsPost**](ActionsApi.md#createactionactionspost) | **POST** /actions/ | Create Action
[**deleteActionActionsActionIdDelete**](ActionsApi.md#deleteactionactionsactioniddelete) | **DELETE** /actions/{action_id} | Delete Action
[**getActionActionsActionIdGet**](ActionsApi.md#getactionactionsactionidget) | **GET** /actions/{action_id} | Get Action
[**getActionsByLinkedActionsByLinkedLinkedIdGet**](ActionsApi.md#getactionsbylinkedactionsbylinkedlinkedidget) | **GET** /actions/by_linked/{linked_id} | Get Actions By Linked
[**getLatestActionActionsRecentGet**](ActionsApi.md#getlatestactionactionsrecentget) | **GET** /actions/recent | Get Latest Action
[**listActionsActionsGet**](ActionsApi.md#listactionsactionsget) | **GET** /actions/ | List Actions


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
> ActionSchema getActionActionsActionIdGet(actionId)

Get Action

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getActionActionsActionIdGet(actionId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getActionActionsActionIdGet: $e\n');
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

# **getActionsByLinkedActionsByLinkedLinkedIdGet**
> List<ActionSchema> getActionsByLinkedActionsByLinkedLinkedIdGet(linkedId)

Get Actions By Linked

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final linkedId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getActionsByLinkedActionsByLinkedLinkedIdGet(linkedId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getActionsByLinkedActionsByLinkedLinkedIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **linkedId** | **String**|  | 

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLatestActionActionsRecentGet**
> List<ActionSchema> getLatestActionActionsRecentGet(days, actionType)

Get Latest Action

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final days = 56; // int | 
final actionType = ; // ActionTypeValuesEnum | 

try {
    final result = api_instance.getLatestActionActionsRecentGet(days, actionType);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getLatestActionActionsRecentGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **days** | **int**|  | [optional] [default to 7]
 **actionType** | [**ActionTypeValuesEnum**](.md)|  | [optional] 

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listActionsActionsGet**
> List<ActionSchema> listActionsActionsGet(limit)

List Actions

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionsApi();
final limit = 56; // int | 

try {
    final result = api_instance.listActionsActionsGet(limit);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->listActionsActionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] 

### Return type

[**List<ActionSchema>**](ActionSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

