# collective_action_api.api.UsersApi

## Load the API package
```dart
import 'package:collective_action_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createUserUsersPost**](UsersApi.md#createuseruserspost) | **POST** /users/ | Create User
[**deleteUserUsersUserIdDelete**](UsersApi.md#deleteuserusersuseriddelete) | **DELETE** /users/{user_id} | Delete User
[**getUserByFirebaseIdUsersFirebaseIdGet**](UsersApi.md#getuserbyfirebaseidusersfirebaseidget) | **GET** /users/{firebase_id} | Get User By Firebase Id
[**getUserByUserIdUsersUserIdGet**](UsersApi.md#getuserbyuseridusersuseridget) | **GET** /users/{user_id} | Get User By User Id
[**listUsersUsersGet**](UsersApi.md#listusersusersget) | **GET** /users/ | List Users
[**updateUserUsersUserIdPatch**](UsersApi.md#updateuserusersuseridpatch) | **PATCH** /users/{user_id} | Update User


# **createUserUsersPost**
> UserSchema createUserUsersPost(userCreate)

Create User

Create a new user in the database. Validates required fields and checks for duplicate emails.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = UsersApi();
final userCreate = UserCreate(); // UserCreate | 

try {
    final result = api_instance.createUserUsersPost(userCreate);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->createUserUsersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userCreate** | [**UserCreate**](UserCreate.md)|  | 

### Return type

[**UserSchema**](UserSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUserUsersUserIdDelete**
> deleteUserUsersUserIdDelete(userId)

Delete User

Delete a user by their unique ID. Raises 404 if the user is not found.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = UsersApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.deleteUserUsersUserIdDelete(userId);
} catch (e) {
    print('Exception when calling UsersApi->deleteUserUsersUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserByFirebaseIdUsersFirebaseIdGet**
> UserSchema getUserByFirebaseIdUsersFirebaseIdGet(firebaseId)

Get User By Firebase Id

Retrieve a user by their unique ID. Raises 404 if the user is not found.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = UsersApi();
final firebaseId = firebaseId_example; // String | 

try {
    final result = api_instance.getUserByFirebaseIdUsersFirebaseIdGet(firebaseId);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->getUserByFirebaseIdUsersFirebaseIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **firebaseId** | **String**|  | 

### Return type

[**UserSchema**](UserSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserByUserIdUsersUserIdGet**
> UserSchema getUserByUserIdUsersUserIdGet(userId)

Get User By User Id

Retrieve a user by their unique ID. Raises 404 if the user is not found.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = UsersApi();
final userId = userId_example; // String | 

try {
    final result = api_instance.getUserByUserIdUsersUserIdGet(userId);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->getUserByUserIdUsersUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**UserSchema**](UserSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listUsersUsersGet**
> List<UserSchema> listUsersUsersGet()

List Users

Retrieve a list of all users from the database.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = UsersApi();

try {
    final result = api_instance.listUsersUsersGet();
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->listUsersUsersGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<UserSchema>**](UserSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserUsersUserIdPatch**
> UserSchema updateUserUsersUserIdPatch(userId, userCreate)

Update User

Update an existing user's information. Checks for email uniqueness and applies partial updates. Raises 404 if the user is not found.

### Example
```dart
import 'package:collective_action_api/api.dart';

final api_instance = UsersApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final userCreate = UserCreate(); // UserCreate | 

try {
    final result = api_instance.updateUserUsersUserIdPatch(userId, userCreate);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->updateUserUsersUserIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **userCreate** | [**UserCreate**](UserCreate.md)|  | 

### Return type

[**UserSchema**](UserSchema.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

