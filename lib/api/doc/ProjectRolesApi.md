# collective_action_api.api.ProjectRolesApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createProjectRoleProjectRolesPost**](ProjectRolesApi.md#createprojectroleprojectrolespost) | **POST** /project-roles/ | Create Project Role
[**deleteProjectRoleProjectRolesRoleIdDelete**](ProjectRolesApi.md#deleteprojectroleprojectrolesroleiddelete) | **DELETE** /project-roles/{role_id} | Delete Project Role
[**getProjectRoleProjectRolesRoleIdGet**](ProjectRolesApi.md#getprojectroleprojectrolesroleidget) | **GET** /project-roles/{role_id} | Get Project Role
[**listProjectRolesProjectRolesGet**](ProjectRolesApi.md#listprojectrolesprojectrolesget) | **GET** /project-roles/ | List Project Roles
[**updateProjectRoleProjectRolesRoleIdPatch**](ProjectRolesApi.md#updateprojectroleprojectrolesroleidpatch) | **PATCH** /project-roles/{role_id} | Update Project Role


# **createProjectRoleProjectRolesPost**
> ProjectRoleSchema createProjectRoleProjectRolesPost(projectRoleCreateSchema)

Create Project Role

Create a new project role.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectRolesApi();
final projectRoleCreateSchema = ProjectRoleCreateSchema(); // ProjectRoleCreateSchema | 

try {
    final result = api_instance.createProjectRoleProjectRolesPost(projectRoleCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ProjectRolesApi->createProjectRoleProjectRolesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectRoleCreateSchema** | [**ProjectRoleCreateSchema**](ProjectRoleCreateSchema.md)|  | 

### Return type

[**ProjectRoleSchema**](ProjectRoleSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProjectRoleProjectRolesRoleIdDelete**
> ProjectRoleSchema deleteProjectRoleProjectRolesRoleIdDelete(roleId)

Delete Project Role

Delete a project role.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectRolesApi();
final roleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.deleteProjectRoleProjectRolesRoleIdDelete(roleId);
    print(result);
} catch (e) {
    print('Exception when calling ProjectRolesApi->deleteProjectRoleProjectRolesRoleIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  | 

### Return type

[**ProjectRoleSchema**](ProjectRoleSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProjectRoleProjectRolesRoleIdGet**
> ProjectRoleSchema getProjectRoleProjectRolesRoleIdGet(roleId)

Get Project Role

Get a specific project role.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectRolesApi();
final roleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getProjectRoleProjectRolesRoleIdGet(roleId);
    print(result);
} catch (e) {
    print('Exception when calling ProjectRolesApi->getProjectRoleProjectRolesRoleIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  | 

### Return type

[**ProjectRoleSchema**](ProjectRoleSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProjectRolesProjectRolesGet**
> List<ProjectRoleSchema> listProjectRolesProjectRolesGet()

List Project Roles

List all project roles.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectRolesApi();

try {
    final result = api_instance.listProjectRolesProjectRolesGet();
    print(result);
} catch (e) {
    print('Exception when calling ProjectRolesApi->listProjectRolesProjectRolesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ProjectRoleSchema>**](ProjectRoleSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProjectRoleProjectRolesRoleIdPatch**
> ProjectRoleSchema updateProjectRoleProjectRolesRoleIdPatch(roleId, projectRoleUpdateSchema)

Update Project Role

Update a project role.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectRolesApi();
final roleId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final projectRoleUpdateSchema = ProjectRoleUpdateSchema(); // ProjectRoleUpdateSchema | 

try {
    final result = api_instance.updateProjectRoleProjectRolesRoleIdPatch(roleId, projectRoleUpdateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ProjectRolesApi->updateProjectRoleProjectRolesRoleIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  | 
 **projectRoleUpdateSchema** | [**ProjectRoleUpdateSchema**](ProjectRoleUpdateSchema.md)|  | 

### Return type

[**ProjectRoleSchema**](ProjectRoleSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

