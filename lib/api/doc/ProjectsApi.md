# collective_action_api.api.ProjectsApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addMemberToProjectProjectsProjectIdMembersPost**](ProjectsApi.md#addmembertoprojectprojectsprojectidmemberspost) | **POST** /projects/{project_id}/members | Add Member To Project
[**addStepToProjectProjectsProjectIdStepsPost**](ProjectsApi.md#addsteptoprojectprojectsprojectidstepspost) | **POST** /projects/{project_id}/steps | Add Step To Project
[**createProjectProjectsPost**](ProjectsApi.md#createprojectprojectspost) | **POST** /projects/ | Create Project
[**deleteProjectProjectsProjectIdDelete**](ProjectsApi.md#deleteprojectprojectsprojectiddelete) | **DELETE** /projects/{project_id} | Delete Project
[**deleteProjectStepProjectsProjectIdStepsStepIdDelete**](ProjectsApi.md#deleteprojectstepprojectsprojectidstepsstepiddelete) | **DELETE** /projects/{project_id}/steps/{step_id} | Delete Project Step
[**getProjectProjectsProjectIdGet**](ProjectsApi.md#getprojectprojectsprojectidget) | **GET** /projects/{project_id} | Get Project
[**listActiveProjectsProjectsActiveGet**](ProjectsApi.md#listactiveprojectsprojectsactiveget) | **GET** /projects/active | List Active Projects
[**listProjectsProjectsGet**](ProjectsApi.md#listprojectsprojectsget) | **GET** /projects/ | List Projects
[**removeMemberFromProjectProjectsProjectIdMembersUserIdDelete**](ProjectsApi.md#removememberfromprojectprojectsprojectidmembersuseriddelete) | **DELETE** /projects/{project_id}/members/{user_id} | Remove Member From Project
[**updateProjectProjectsProjectIdPatch**](ProjectsApi.md#updateprojectprojectsprojectidpatch) | **PATCH** /projects/{project_id} | Update Project
[**updateProjectStepProjectsProjectIdStepsStepIdPatch**](ProjectsApi.md#updateprojectstepprojectsprojectidstepsstepidpatch) | **PATCH** /projects/{project_id}/steps/{step_id} | Update Project Step


# **addMemberToProjectProjectsProjectIdMembersPost**
> ProjectSchema addMemberToProjectProjectsProjectIdMembersPost(projectId, addProjectMemberSchema)

Add Member To Project

Add a user to a project in the given role (members, owners, or developers).

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final addProjectMemberSchema = AddProjectMemberSchema(); // AddProjectMemberSchema | 

try {
    final result = api_instance.addMemberToProjectProjectsProjectIdMembersPost(projectId, addProjectMemberSchema);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->addMemberToProjectProjectsProjectIdMembersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **addProjectMemberSchema** | [**AddProjectMemberSchema**](AddProjectMemberSchema.md)|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addStepToProjectProjectsProjectIdStepsPost**
> ProjectSchema addStepToProjectProjectsProjectIdStepsPost(projectId, projectStepCreateSchema)

Add Step To Project

Add a step to a project.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final projectStepCreateSchema = ProjectStepCreateSchema(); // ProjectStepCreateSchema | 

try {
    final result = api_instance.addStepToProjectProjectsProjectIdStepsPost(projectId, projectStepCreateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->addStepToProjectProjectsProjectIdStepsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **projectStepCreateSchema** | [**ProjectStepCreateSchema**](ProjectStepCreateSchema.md)|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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

# **deleteProjectStepProjectsProjectIdStepsStepIdDelete**
> ProjectSchema deleteProjectStepProjectsProjectIdStepsStepIdDelete(projectId, stepId)

Delete Project Step

Delete a specific step from a project.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final stepId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.deleteProjectStepProjectsProjectIdStepsStepIdDelete(projectId, stepId);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->deleteProjectStepProjectsProjectIdStepsStepIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **stepId** | **String**|  | 

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

# **removeMemberFromProjectProjectsProjectIdMembersUserIdDelete**
> ProjectSchema removeMemberFromProjectProjectsProjectIdMembersUserIdDelete(projectId, userId)

Remove Member From Project

Remove a user from a project.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.removeMemberFromProjectProjectsProjectIdMembersUserIdDelete(projectId, userId);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->removeMemberFromProjectProjectsProjectIdMembersUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **userId** | **String**|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

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

# **updateProjectStepProjectsProjectIdStepsStepIdPatch**
> ProjectSchema updateProjectStepProjectsProjectIdStepsStepIdPatch(projectId, stepId, projectStepUpdateSchema)

Update Project Step

Update a specific step in a project.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = ProjectsApi();
final projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final stepId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final projectStepUpdateSchema = ProjectStepUpdateSchema(); // ProjectStepUpdateSchema | 

try {
    final result = api_instance.updateProjectStepProjectsProjectIdStepsStepIdPatch(projectId, stepId, projectStepUpdateSchema);
    print(result);
} catch (e) {
    print('Exception when calling ProjectsApi->updateProjectStepProjectsProjectIdStepsStepIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  | 
 **stepId** | **String**|  | 
 **projectStepUpdateSchema** | [**ProjectStepUpdateSchema**](ProjectStepUpdateSchema.md)|  | 

### Return type

[**ProjectSchema**](ProjectSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

