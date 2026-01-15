# openapi.api.ActionsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createActionActionsPost**](ActionsApi.md#createactionactionspost) | **POST** /actions/ | Create Action
[**getActionActionsActionIdGet**](ActionsApi.md#getactionactionsactionidget) | **GET** /actions/{action_id} | Get Action
[**getActionsByInitiativeActionsByInitiativeInitiativeIdGet**](ActionsApi.md#getactionsbyinitiativeactionsbyinitiativeinitiativeidget) | **GET** /actions/by_initiative/{initiative_id} | Get Actions By Initiative
[**listActionsActionsGet**](ActionsApi.md#listactionsactionsget) | **GET** /actions/ | List Actions


# **createActionActionsPost**
> ActionSchema createActionActionsPost(actionCreateSchema)

Create Action

### Example
```dart
import 'package:openapi/api.dart';

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

# **getActionActionsActionIdGet**
> ActionSchema getActionActionsActionIdGet(actionId)

Get Action

### Example
```dart
import 'package:openapi/api.dart';

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

# **getActionsByInitiativeActionsByInitiativeInitiativeIdGet**
> List<ActionSchema> getActionsByInitiativeActionsByInitiativeInitiativeIdGet(initiativeId)

Get Actions By Initiative

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ActionsApi();
final initiativeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getActionsByInitiativeActionsByInitiativeInitiativeIdGet(initiativeId);
    print(result);
} catch (e) {
    print('Exception when calling ActionsApi->getActionsByInitiativeActionsByInitiativeInitiativeIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **initiativeId** | **String**|  | 

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
import 'package:openapi/api.dart';

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

