# collective_action_api.api.ProjectsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createProjectProjectsPost**](ProjectsApi.md#createprojectprojectspost) | **POST** /projects/ | Create Project
[**deleteProjectProjectsProjectIdDelete**](ProjectsApi.md#deleteprojectprojectsprojectiddelete) | **DELETE** /projects/{project_id} | Delete Project
[**getProjectProjectsProjectIdGet**](ProjectsApi.md#getprojectprojectsprojectidget) | **GET** /projects/{project_id} | Get Project
[**listActiveProjectsProjectsActiveGet**](ProjectsApi.md#listactiveprojectsprojectsactiveget) | **GET** /projects/active | List Active Projects
[**listProjectsProjectsGet**](ProjectsApi.md#listprojectsprojectsget) | **GET** /projects/ | List Projects
[**updateProjectProjectsProjectIdPatch**](ProjectsApi.md#updateprojectprojectsprojectidpatch) | **PATCH** /projects/{project_id} | Update Project


# **createProjectProjectsPost**
> ProjectSchema createProjectProjectsPost(projectCreateSchema)

Create Project

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectCreateSchema = ProjectCreateSchema(); // ProjectCreateSchema | 

try {
    final result = api_instance.createProjectProjectsPost(projectCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->createProjectProjectsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectCreateSchema** | [**ProjectCreateSchema**](ProjectCreateSchema.md)|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProjectProjectsProjectIdDelete**
> ProjectSchema deleteProjectProjectsProjectIdDelete(projectId)

Delete Project

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.deleteProjectProjectsProjectIdDelete(projectId);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->deleteProjectProjectsProjectIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProjectProjectsProjectIdGet**
> ProjectSchema getProjectProjectsProjectIdGet(projectId)

Get Project

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getProjectProjectsProjectIdGet(projectId);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->getProjectProjectsProjectIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listActiveProjectsProjectsActiveGet**
> List<ProjectSchema> listActiveProjectsProjectsActiveGet()

List Active Projects

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();

try {
    final result = api_instance.listActiveProjectsProjectsActiveGet();
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->listActiveProjectsProjectsActiveGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ProjectSchema>**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProjectsProjectsGet**
> List<ProjectSchema> listProjectsProjectsGet()

List Projects

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();

try {
    final result = api_instance.listProjectsProjectsGet();
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->listProjectsProjectsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ProjectSchema>**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProjectProjectsProjectIdPatch**
> ProjectSchema updateProjectProjectsProjectIdPatch(projectId, projectUpdateSchema)

Update Project

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final projectUpdateSchema = ProjectUpdateSchema(); // ProjectUpdateSchema | 

try {
    final result = api_instance.updateProjectProjectsProjectIdPatch(projectId, projectUpdateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->updateProjectProjectsProjectIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **projectUpdateSchema** | [**ProjectUpdateSchema**](ProjectUpdateSchema.md)|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

