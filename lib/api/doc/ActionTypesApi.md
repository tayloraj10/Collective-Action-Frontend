# collective_action_api.api.ActionTypesApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createActionTypeActionTypesPost**](ActionTypesApi.md#createactiontypeactiontypespost) | **POST** /action_types/ | Create Action Type
[**deleteActionTypeActionTypesActionTypeIdDelete**](ActionTypesApi.md#deleteactiontypeactiontypesactiontypeiddelete) | **DELETE** /action_types/{action_type_id} | Delete Action Type
[**getActionTypeActionTypesActionTypeIdGet**](ActionTypesApi.md#getactiontypeactiontypesactiontypeidget) | **GET** /action_types/{action_type_id} | Get Action Type
[**listActionTypesActionTypesGet**](ActionTypesApi.md#listactiontypesactiontypesget) | **GET** /action_types/ | List Action Types
[**updateActionTypeActionTypesActionTypeIdPut**](ActionTypesApi.md#updateactiontypeactiontypesactiontypeidput) | **PUT** /action_types/{action_type_id} | Update Action Type


# **createActionTypeActionTypesPost**
> ActionTypeSchema createActionTypeActionTypesPost(actionTypeCreate)

Create Action Type

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionTypesApi();
final actionTypeCreate = ActionTypeCreate(); // ActionTypeCreate | 

try {
    final result = api_instance.createActionTypeActionTypesPost(actionTypeCreate);
    print(result);
} catch (e) {
    print('Exception when calling ActionTypesApi->createActionTypeActionTypesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionTypeCreate** | [**ActionTypeCreate**](ActionTypeCreate.md)|  | 

### Return type

[**ActionTypeSchema**](ActionTypeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteActionTypeActionTypesActionTypeIdDelete**
> Object deleteActionTypeActionTypesActionTypeIdDelete(actionTypeId)

Delete Action Type

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionTypesApi();
final actionTypeId = actionTypeId_example; // String | 

try {
    final result = api_instance.deleteActionTypeActionTypesActionTypeIdDelete(actionTypeId);
    print(result);
} catch (e) {
    print('Exception when calling ActionTypesApi->deleteActionTypeActionTypesActionTypeIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionTypeId** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActionTypeActionTypesActionTypeIdGet**
> ActionTypeSchema getActionTypeActionTypesActionTypeIdGet(actionTypeId)

Get Action Type

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionTypesApi();
final actionTypeId = actionTypeId_example; // String | 

try {
    final result = api_instance.getActionTypeActionTypesActionTypeIdGet(actionTypeId);
    print(result);
} catch (e) {
    print('Exception when calling ActionTypesApi->getActionTypeActionTypesActionTypeIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionTypeId** | **String**|  | 

### Return type

[**ActionTypeSchema**](ActionTypeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listActionTypesActionTypesGet**
> List<ActionTypeSchema> listActionTypesActionTypesGet()

List Action Types

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionTypesApi();

try {
    final result = api_instance.listActionTypesActionTypesGet();
    print(result);
} catch (e) {
    print('Exception when calling ActionTypesApi->listActionTypesActionTypesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ActionTypeSchema>**](ActionTypeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateActionTypeActionTypesActionTypeIdPut**
> ActionTypeSchema updateActionTypeActionTypesActionTypeIdPut(actionTypeId, actionTypeCreate)

Update Action Type

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ActionTypesApi();
final actionTypeId = actionTypeId_example; // String | 
final actionTypeCreate = ActionTypeCreate(); // ActionTypeCreate | 

try {
    final result = api_instance.updateActionTypeActionTypesActionTypeIdPut(actionTypeId, actionTypeCreate);
    print(result);
} catch (e) {
    print('Exception when calling ActionTypesApi->updateActionTypeActionTypesActionTypeIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionTypeId** | **String**|  | 
 **actionTypeCreate** | [**ActionTypeCreate**](ActionTypeCreate.md)|  | 

### Return type

[**ActionTypeSchema**](ActionTypeSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

