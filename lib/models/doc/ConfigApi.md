# openapi.api.ConfigApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createActionTypeConfigActionTypesPost**](ConfigApi.md#createactiontypeconfigactiontypespost) | **POST** /config/action_types | Create Action Type
[**createCategoryConfigCategoriesPost**](ConfigApi.md#createcategoryconfigcategoriespost) | **POST** /config/categories | Create Category
[**createStatusConfigStatusesPost**](ConfigApi.md#createstatusconfigstatusespost) | **POST** /config/statuses | Create Status
[**deleteActionTypeConfigActionTypesActionTypeIdDelete**](ConfigApi.md#deleteactiontypeconfigactiontypesactiontypeiddelete) | **DELETE** /config/action_types/{action_type_id} | Delete Action Type
[**deleteCategoryConfigCategoriesCategoryIdDelete**](ConfigApi.md#deletecategoryconfigcategoriescategoryiddelete) | **DELETE** /config/categories/{category_id} | Delete Category
[**deleteStatusConfigStatusesStatusIdDelete**](ConfigApi.md#deletestatusconfigstatusesstatusiddelete) | **DELETE** /config/statuses/{status_id} | Delete Status
[**getActionTypeConfigActionTypesActionTypeIdGet**](ConfigApi.md#getactiontypeconfigactiontypesactiontypeidget) | **GET** /config/action_types/{action_type_id} | Get Action Type
[**getCategoryConfigCategoriesCategoryIdGet**](ConfigApi.md#getcategoryconfigcategoriescategoryidget) | **GET** /config/categories/{category_id} | Get Category
[**getStatusConfigStatusesStatusIdGet**](ConfigApi.md#getstatusconfigstatusesstatusidget) | **GET** /config/statuses/{status_id} | Get Status
[**listActionTypesConfigActionTypesGet**](ConfigApi.md#listactiontypesconfigactiontypesget) | **GET** /config/action_types | List Action Types
[**listCategoriesConfigCategoriesGet**](ConfigApi.md#listcategoriesconfigcategoriesget) | **GET** /config/categories | List Categories
[**listStatusesConfigStatusesGet**](ConfigApi.md#liststatusesconfigstatusesget) | **GET** /config/statuses | List Statuses
[**updateActionTypeConfigActionTypesActionTypeIdPut**](ConfigApi.md#updateactiontypeconfigactiontypesactiontypeidput) | **PUT** /config/action_types/{action_type_id} | Update Action Type
[**updateCategoryConfigCategoriesCategoryIdPut**](ConfigApi.md#updatecategoryconfigcategoriescategoryidput) | **PUT** /config/categories/{category_id} | Update Category
[**updateStatusConfigStatusesStatusIdPut**](ConfigApi.md#updatestatusconfigstatusesstatusidput) | **PUT** /config/statuses/{status_id} | Update Status


# **createActionTypeConfigActionTypesPost**
> ActionTypeSchema createActionTypeConfigActionTypesPost(actionTypeCreate)

Create Action Type

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final actionTypeCreate = ActionTypeCreate(); // ActionTypeCreate | 

try {
    final result = api_instance.createActionTypeConfigActionTypesPost(actionTypeCreate);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->createActionTypeConfigActionTypesPost: $e\n');
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

# **createCategoryConfigCategoriesPost**
> CategorySchema createCategoryConfigCategoriesPost(categoryCreate)

Create Category

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final categoryCreate = CategoryCreate(); // CategoryCreate | 

try {
    final result = api_instance.createCategoryConfigCategoriesPost(categoryCreate);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->createCategoryConfigCategoriesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryCreate** | [**CategoryCreate**](CategoryCreate.md)|  | 

### Return type

[**CategorySchema**](CategorySchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createStatusConfigStatusesPost**
> StatusSchema createStatusConfigStatusesPost(statusCreate)

Create Status

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final statusCreate = StatusCreate(); // StatusCreate | 

try {
    final result = api_instance.createStatusConfigStatusesPost(statusCreate);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->createStatusConfigStatusesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusCreate** | [**StatusCreate**](StatusCreate.md)|  | 

### Return type

[**StatusSchema**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteActionTypeConfigActionTypesActionTypeIdDelete**
> Object deleteActionTypeConfigActionTypesActionTypeIdDelete(actionTypeId)

Delete Action Type

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final actionTypeId = actionTypeId_example; // String | 

try {
    final result = api_instance.deleteActionTypeConfigActionTypesActionTypeIdDelete(actionTypeId);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->deleteActionTypeConfigActionTypesActionTypeIdDelete: $e\n');
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

# **deleteCategoryConfigCategoriesCategoryIdDelete**
> Object deleteCategoryConfigCategoriesCategoryIdDelete(categoryId)

Delete Category

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final categoryId = categoryId_example; // String | 

try {
    final result = api_instance.deleteCategoryConfigCategoriesCategoryIdDelete(categoryId);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->deleteCategoryConfigCategoriesCategoryIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteStatusConfigStatusesStatusIdDelete**
> Object deleteStatusConfigStatusesStatusIdDelete(statusId)

Delete Status

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final statusId = statusId_example; // String | 

try {
    final result = api_instance.deleteStatusConfigStatusesStatusIdDelete(statusId);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->deleteStatusConfigStatusesStatusIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusId** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActionTypeConfigActionTypesActionTypeIdGet**
> ActionTypeSchema getActionTypeConfigActionTypesActionTypeIdGet(actionTypeId)

Get Action Type

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final actionTypeId = actionTypeId_example; // String | 

try {
    final result = api_instance.getActionTypeConfigActionTypesActionTypeIdGet(actionTypeId);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->getActionTypeConfigActionTypesActionTypeIdGet: $e\n');
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

# **getCategoryConfigCategoriesCategoryIdGet**
> CategorySchema getCategoryConfigCategoriesCategoryIdGet(categoryId)

Get Category

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final categoryId = categoryId_example; // String | 

try {
    final result = api_instance.getCategoryConfigCategoriesCategoryIdGet(categoryId);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->getCategoryConfigCategoriesCategoryIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 

### Return type

[**CategorySchema**](CategorySchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getStatusConfigStatusesStatusIdGet**
> StatusSchema getStatusConfigStatusesStatusIdGet(statusId)

Get Status

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final statusId = statusId_example; // String | 

try {
    final result = api_instance.getStatusConfigStatusesStatusIdGet(statusId);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->getStatusConfigStatusesStatusIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusId** | **String**|  | 

### Return type

[**StatusSchema**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listActionTypesConfigActionTypesGet**
> List<ActionTypeSchema> listActionTypesConfigActionTypesGet()

List Action Types

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();

try {
    final result = api_instance.listActionTypesConfigActionTypesGet();
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->listActionTypesConfigActionTypesGet: $e\n');
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

# **listCategoriesConfigCategoriesGet**
> List<CategorySchema> listCategoriesConfigCategoriesGet()

List Categories

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();

try {
    final result = api_instance.listCategoriesConfigCategoriesGet();
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->listCategoriesConfigCategoriesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<CategorySchema>**](CategorySchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listStatusesConfigStatusesGet**
> List<StatusSchema> listStatusesConfigStatusesGet()

List Statuses

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();

try {
    final result = api_instance.listStatusesConfigStatusesGet();
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->listStatusesConfigStatusesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<StatusSchema>**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateActionTypeConfigActionTypesActionTypeIdPut**
> ActionTypeSchema updateActionTypeConfigActionTypesActionTypeIdPut(actionTypeId, actionTypeCreate)

Update Action Type

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final actionTypeId = actionTypeId_example; // String | 
final actionTypeCreate = ActionTypeCreate(); // ActionTypeCreate | 

try {
    final result = api_instance.updateActionTypeConfigActionTypesActionTypeIdPut(actionTypeId, actionTypeCreate);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->updateActionTypeConfigActionTypesActionTypeIdPut: $e\n');
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

# **updateCategoryConfigCategoriesCategoryIdPut**
> CategorySchema updateCategoryConfigCategoriesCategoryIdPut(categoryId, categoryCreate)

Update Category

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final categoryId = categoryId_example; // String | 
final categoryCreate = CategoryCreate(); // CategoryCreate | 

try {
    final result = api_instance.updateCategoryConfigCategoriesCategoryIdPut(categoryId, categoryCreate);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->updateCategoryConfigCategoriesCategoryIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 
 **categoryCreate** | [**CategoryCreate**](CategoryCreate.md)|  | 

### Return type

[**CategorySchema**](CategorySchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateStatusConfigStatusesStatusIdPut**
> StatusSchema updateStatusConfigStatusesStatusIdPut(statusId, statusCreate)

Update Status

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ConfigApi();
final statusId = statusId_example; // String | 
final statusCreate = StatusCreate(); // StatusCreate | 

try {
    final result = api_instance.updateStatusConfigStatusesStatusIdPut(statusId, statusCreate);
    print(result);
} catch (e) {
    print('Exception when calling ConfigApi->updateStatusConfigStatusesStatusIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statusId** | **String**|  | 
 **statusCreate** | [**StatusCreate**](StatusCreate.md)|  | 

### Return type

[**StatusSchema**](StatusSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

