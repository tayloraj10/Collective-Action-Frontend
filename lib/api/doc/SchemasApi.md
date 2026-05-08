# collective_action_api.api.SchemasApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCleanupEventDataSchemaSchemasEventDataCleanupGet**](SchemasApi.md#getcleanupeventdataschemaschemaseventdatacleanupget) | **GET** /schemas/event-data/cleanup | CleanupEventData schema
[**getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGet**](SchemasApi.md#getcleanuprouteeventdataschemaschemaseventdatacleanuprouteget) | **GET** /schemas/event-data/cleanup_route | CleanupRouteEventData schema
[**getEventDataBaseSchemaSchemasEventDataBaseGet**](SchemasApi.md#geteventdatabaseschemaschemaseventdatabaseget) | **GET** /schemas/event-data/base | EventDataBase schema
[**getTrashReportEventDataSchemaSchemasEventDataTrashReportGet**](SchemasApi.md#gettrashreporteventdataschemaschemaseventdatatrashreportget) | **GET** /schemas/event-data/trash_report | TrashReportEventData schema
[**getTreePlantingEventDataSchemaSchemasEventDataTreePlantingGet**](SchemasApi.md#gettreeplantingeventdataschemaschemaseventdatatreeplantingget) | **GET** /schemas/event-data/tree_planting | TreePlantingEventData schema
[**getWildflowerPlantingEventDataSchemaSchemasEventDataWildflowerPlantingGet**](SchemasApi.md#getwildflowerplantingeventdataschemaschemaseventdatawildflowerplantingget) | **GET** /schemas/event-data/wildflower_planting | WildflowerPlantingEventData schema
[**getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGet**](SchemasApi.md#getzipcodesubmissioneventdataschemaschemaseventdatazipcodesubmissionget) | **GET** /schemas/event-data/zip_code_submission | ZipCodeSubmissionEventData schema


# **getCleanupEventDataSchemaSchemasEventDataCleanupGet**
> CleanupEventData getCleanupEventDataSchemaSchemasEventDataCleanupGet()

CleanupEventData schema

Schema for event_data when action_type is 'cleanup'. Exposed for OpenAPI/codegen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = SchemasApi();

try {
    final result = api_instance.getCleanupEventDataSchemaSchemasEventDataCleanupGet();
    print(result);
} catch (e) {
    print('Exception when calling SchemasApi->getCleanupEventDataSchemaSchemasEventDataCleanupGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CleanupEventData**](CleanupEventData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGet**
> CleanupRouteEventData getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGet()

CleanupRouteEventData schema

Schema for event_data when action_type is 'cleanup_route'. Exposed for OpenAPI/codegen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = SchemasApi();

try {
    final result = api_instance.getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGet();
    print(result);
} catch (e) {
    print('Exception when calling SchemasApi->getCleanupRouteEventDataSchemaSchemasEventDataCleanupRouteGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CleanupRouteEventData**](CleanupRouteEventData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEventDataBaseSchemaSchemasEventDataBaseGet**
> EventDataBase getEventDataBaseSchemaSchemasEventDataBaseGet()

EventDataBase schema

Shared base fields for all event_data types. Exposed for OpenAPI/codegen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = SchemasApi();

try {
    final result = api_instance.getEventDataBaseSchemaSchemasEventDataBaseGet();
    print(result);
} catch (e) {
    print('Exception when calling SchemasApi->getEventDataBaseSchemaSchemasEventDataBaseGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**EventDataBase**](EventDataBase.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTrashReportEventDataSchemaSchemasEventDataTrashReportGet**
> TrashReportEventData getTrashReportEventDataSchemaSchemasEventDataTrashReportGet()

TrashReportEventData schema

Schema for event_data when action_type is 'trash_report'. Exposed for OpenAPI/codegen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = SchemasApi();

try {
    final result = api_instance.getTrashReportEventDataSchemaSchemasEventDataTrashReportGet();
    print(result);
} catch (e) {
    print('Exception when calling SchemasApi->getTrashReportEventDataSchemaSchemasEventDataTrashReportGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**TrashReportEventData**](TrashReportEventData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTreePlantingEventDataSchemaSchemasEventDataTreePlantingGet**
> TreePlantingEventData getTreePlantingEventDataSchemaSchemasEventDataTreePlantingGet()

TreePlantingEventData schema

Schema for event_data when action_type is 'tree_planting'. Exposed for OpenAPI/codegen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = SchemasApi();

try {
    final result = api_instance.getTreePlantingEventDataSchemaSchemasEventDataTreePlantingGet();
    print(result);
} catch (e) {
    print('Exception when calling SchemasApi->getTreePlantingEventDataSchemaSchemasEventDataTreePlantingGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**TreePlantingEventData**](TreePlantingEventData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWildflowerPlantingEventDataSchemaSchemasEventDataWildflowerPlantingGet**
> WildflowerPlantingEventData getWildflowerPlantingEventDataSchemaSchemasEventDataWildflowerPlantingGet()

WildflowerPlantingEventData schema

Schema for event_data when action_type is 'wildflower_planting'. Exposed for OpenAPI/codegen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = SchemasApi();

try {
    final result = api_instance.getWildflowerPlantingEventDataSchemaSchemasEventDataWildflowerPlantingGet();
    print(result);
} catch (e) {
    print('Exception when calling SchemasApi->getWildflowerPlantingEventDataSchemaSchemasEventDataWildflowerPlantingGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**WildflowerPlantingEventData**](WildflowerPlantingEventData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGet**
> ZipCodeSubmissionEventData getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGet()

ZipCodeSubmissionEventData schema

Schema for event_data when action_type is 'zip_code_submission'. Exposed for OpenAPI/codegen.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = SchemasApi();

try {
    final result = api_instance.getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGet();
    print(result);
} catch (e) {
    print('Exception when calling SchemasApi->getZipCodeSubmissionEventDataSchemaSchemasEventDataZipCodeSubmissionGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ZipCodeSubmissionEventData**](ZipCodeSubmissionEventData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

