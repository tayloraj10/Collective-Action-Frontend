# collective_action_api.api.QuotesApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createQuoteQuotesPost**](QuotesApi.md#createquotequotespost) | **POST** /quotes/ | Create Quote
[**deleteQuoteQuotesQuoteIdDelete**](QuotesApi.md#deletequotequotesquoteiddelete) | **DELETE** /quotes/{quote_id} | Delete Quote
[**getQuoteQuotesQuoteIdGet**](QuotesApi.md#getquotequotesquoteidget) | **GET** /quotes/{quote_id} | Get Quote
[**getRandomQuoteQuotesRandomGet**](QuotesApi.md#getrandomquotequotesrandomget) | **GET** /quotes/random | Get Random Quote
[**listQuotesQuotesGet**](QuotesApi.md#listquotesquotesget) | **GET** /quotes/ | List Quotes
[**updateQuoteQuotesQuoteIdPatch**](QuotesApi.md#updatequotequotesquoteidpatch) | **PATCH** /quotes/{quote_id} | Update Quote


# **createQuoteQuotesPost**
> QuoteSchema createQuoteQuotesPost(quoteCreateSchema)

Create Quote

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = QuotesApi();
final quoteCreateSchema = QuoteCreateSchema(); // QuoteCreateSchema | 

try {
    final result = api_instance.createQuoteQuotesPost(quoteCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling QuotesApi->createQuoteQuotesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **quoteCreateSchema** | [**QuoteCreateSchema**](QuoteCreateSchema.md)|  | 

### Return type

[**QuoteSchema**](QuoteSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteQuoteQuotesQuoteIdDelete**
> deleteQuoteQuotesQuoteIdDelete(quoteId)

Delete Quote

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = QuotesApi();
final quoteId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.deleteQuoteQuotesQuoteIdDelete(quoteId);
} catch (e) {
    print('Exception when calling QuotesApi->deleteQuoteQuotesQuoteIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **quoteId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getQuoteQuotesQuoteIdGet**
> QuoteSchema getQuoteQuotesQuoteIdGet(quoteId)

Get Quote

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = QuotesApi();
final quoteId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getQuoteQuotesQuoteIdGet(quoteId);
    print(result);
} catch (e) {
    print('Exception when calling QuotesApi->getQuoteQuotesQuoteIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **quoteId** | **String**|  | 

### Return type

[**QuoteSchema**](QuoteSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRandomQuoteQuotesRandomGet**
> QuoteSchema getRandomQuoteQuotesRandomGet()

Get Random Quote

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = QuotesApi();

try {
    final result = api_instance.getRandomQuoteQuotesRandomGet();
    print(result);
} catch (e) {
    print('Exception when calling QuotesApi->getRandomQuoteQuotesRandomGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**QuoteSchema**](QuoteSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listQuotesQuotesGet**
> List<QuoteSchema> listQuotesQuotesGet()

List Quotes

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = QuotesApi();

try {
    final result = api_instance.listQuotesQuotesGet();
    print(result);
} catch (e) {
    print('Exception when calling QuotesApi->listQuotesQuotesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<QuoteSchema>**](QuoteSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateQuoteQuotesQuoteIdPatch**
> QuoteSchema updateQuoteQuotesQuoteIdPatch(quoteId, quoteCreateSchema)

Update Quote

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = QuotesApi();
final quoteId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final quoteCreateSchema = QuoteCreateSchema(); // QuoteCreateSchema | 

try {
    final result = api_instance.updateQuoteQuotesQuoteIdPatch(quoteId, quoteCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling QuotesApi->updateQuoteQuotesQuoteIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **quoteId** | **String**|  | 
 **quoteCreateSchema** | [**QuoteCreateSchema**](QuoteCreateSchema.md)|  | 

### Return type

[**QuoteSchema**](QuoteSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

