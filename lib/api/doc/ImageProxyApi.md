# collective_action_api.api.ImageProxyApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**proxyImageImageProxyGet**](ImageProxyApi.md#proxyimageimageproxyget) | **GET** /image-proxy/ | Proxy Image


# **proxyImageImageProxyGet**
> Object proxyImageImageProxyGet(url)

Proxy Image

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ImageProxyApi();
final url = url_example; // String | Absolute image URL to proxy

try {
    final result = api_instance.proxyImageImageProxyGet(url);
    print(result);
} catch (e) {
    print('Exception when calling ImageProxyApi->proxyImageImageProxyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **url** | **String**| Absolute image URL to proxy | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

