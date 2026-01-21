# collective_action_api.api.CategoriesApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createCategoryCategoriesPost**](CategoriesApi.md#createcategorycategoriespost) | **POST** /categories/ | Create Category
[**deleteCategoryCategoriesCategoryIdDelete**](CategoriesApi.md#deletecategorycategoriescategoryiddelete) | **DELETE** /categories/{category_id} | Delete Category
[**getCategoryCategoriesCategoryIdGet**](CategoriesApi.md#getcategorycategoriescategoryidget) | **GET** /categories/{category_id} | Get Category
[**listCategoriesCategoriesGet**](CategoriesApi.md#listcategoriescategoriesget) | **GET** /categories/ | List Categories
[**updateCategoryCategoriesCategoryIdPut**](CategoriesApi.md#updatecategorycategoriescategoryidput) | **PUT** /categories/{category_id} | Update Category


# **createCategoryCategoriesPost**
> CategorySchema createCategoryCategoriesPost(categoryCreate)

Create Category

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = CategoriesApi();
final categoryCreate = CategoryCreate(); // CategoryCreate | 

try {
    final result = api_instance.createCategoryCategoriesPost(categoryCreate);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->createCategoryCategoriesPost: $e\n');
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

# **deleteCategoryCategoriesCategoryIdDelete**
> Object deleteCategoryCategoriesCategoryIdDelete(categoryId)

Delete Category

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = CategoriesApi();
final categoryId = categoryId_example; // String | 

try {
    final result = api_instance.deleteCategoryCategoriesCategoryIdDelete(categoryId);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->deleteCategoryCategoriesCategoryIdDelete: $e\n');
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

# **getCategoryCategoriesCategoryIdGet**
> CategorySchema getCategoryCategoriesCategoryIdGet(categoryId)

Get Category

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = CategoriesApi();
final categoryId = categoryId_example; // String | 

try {
    final result = api_instance.getCategoryCategoriesCategoryIdGet(categoryId);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->getCategoryCategoriesCategoryIdGet: $e\n');
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

# **listCategoriesCategoriesGet**
> List<CategorySchema> listCategoriesCategoriesGet()

List Categories

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = CategoriesApi();

try {
    final result = api_instance.listCategoriesCategoriesGet();
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->listCategoriesCategoriesGet: $e\n');
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

# **updateCategoryCategoriesCategoryIdPut**
> CategorySchema updateCategoryCategoriesCategoryIdPut(categoryId, categoryCreate)

Update Category

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = CategoriesApi();
final categoryId = categoryId_example; // String | 
final categoryCreate = CategoryCreate(); // CategoryCreate | 

try {
    final result = api_instance.updateCategoryCategoriesCategoryIdPut(categoryId, categoryCreate);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->updateCategoryCategoriesCategoryIdPut: $e\n');
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

