//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library collective_action_api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/action_types_api.dart';
part 'api/actions_api.dart';
part 'api/categories_api.dart';
part 'api/default_api.dart';
part 'api/initiatives_api.dart';
part 'api/links_api.dart';
part 'api/photos_api.dart';
part 'api/project_roles_api.dart';
part 'api/projects_api.dart';
part 'api/quotes_api.dart';
part 'api/statuses_api.dart';
part 'api/users_api.dart';

part 'model/action_create_schema.dart';
part 'model/action_photos_update.dart';
part 'model/action_schema.dart';
part 'model/action_type_create.dart';
part 'model/action_type_schema.dart';
part 'model/action_type_values_enum.dart';
part 'model/add_project_member_schema.dart';
part 'model/category_create.dart';
part 'model/category_schema.dart';
part 'model/initiative_create_schema.dart';
part 'model/initiative_schema.dart';
part 'model/link_create_schema.dart';
part 'model/link_schema.dart';
part 'model/link_update_schema.dart';
part 'model/location_schema.dart';
part 'model/member_ids_by_role.dart';
part 'model/project_create_schema.dart';
part 'model/project_link_schema.dart';
part 'model/project_role_create_schema.dart';
part 'model/project_role_schema.dart';
part 'model/project_role_update_schema.dart';
part 'model/project_schema.dart';
part 'model/project_step_create_schema.dart';
part 'model/project_step_schema.dart';
part 'model/project_step_update_schema.dart';
part 'model/project_update_schema.dart';
part 'model/quote_create_schema.dart';
part 'model/quote_schema.dart';
part 'model/social_links_schema.dart';
part 'model/status_create.dart';
part 'model/status_schema.dart';
part 'model/status_type_enum.dart';
part 'model/status_values_enum.dart';
part 'model/user_create.dart';
part 'model/user_photo_update.dart';
part 'model/user_schema.dart';
part 'model/user_type.dart';
part 'model/user_update.dart';


/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) => pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
