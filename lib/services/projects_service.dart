import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectsService {
  late final ProjectsApi _api;
  late final ApiClient _client;

  ProjectsService({String? baseUrl}) {
    _client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = ProjectsApi(_client);
  }

  Future<List<ProjectSchema>> listActiveProjects() async {
    try {
      final result = await _api.listActiveProjectsProjectsActiveGet();
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to fetch active projects: $e');
    }
  }

  Future<List<ProjectSchema>> listProjectsByCreator(String creatorId) async {
    try {
      final result = await _api.listProjectsByCreatorProjectsCreatorCreatorIdGet(creatorId);
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to fetch projects by creator: $e');
    }
  }

  Future<ProjectSchema?> getProject(String projectId) async {
    try {
      return await _api.getProjectProjectsProjectIdGet(projectId);
    } catch (e) {
      throw Exception('Failed to fetch project: $e');
    }
  }

  Future<ProjectSchema?> createProject(ProjectCreateSchema body) async {
    try {
      return await _api.createProjectProjectsPost(body);
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  Future<ProjectSchema?> updateProject(
    String projectId,
    ProjectUpdateSchema body,
  ) async {
    try {
      // Get the JSON representation and remove null fields
      // This prevents sending fields we don't want to update
      final json = body.toJson();
      json.removeWhere((key, value) => value == null);

      // Make the PATCH request directly with the filtered JSON
      final path = '/projects/$projectId';
      final url = Uri.parse('${_client.basePath}$path');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          ..._client.defaultHeaderMap,
        },
        body: jsonEncode(json),
      );

      if (response.statusCode == 200) {
        return ProjectSchema.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  Future<ProjectSchema?> deleteProject(String projectId) async {
    try {
      return await _api.deleteProjectProjectsProjectIdDelete(projectId);
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  Future<ProjectSchema?> addMemberToProject(
    String projectId,
    AddProjectMemberSchema body,
  ) async {
    try {
      return await _api.addMemberToProjectProjectsProjectIdMembersPost(
        projectId,
        body,
      );
    } catch (e) {
      throw Exception('Failed to add member to project: $e');
    }
  }

  Future<ProjectSchema?> removeMemberFromProject(
    String projectId,
    String userId,
  ) async {
    try {
      return await _api
          .removeMemberFromProjectProjectsProjectIdMembersUserIdDelete(
            projectId,
            userId,
          );
    } catch (e) {
      throw Exception('Failed to remove member from project: $e');
    }
  }

  Future<ProjectSchema?> addStepToProject(
    String projectId,
    ProjectStepCreateSchema body,
  ) async {
    try {
      return await _api.addStepToProjectProjectsProjectIdStepsPost(
        projectId,
        body,
      );
    } catch (e) {
      throw Exception('Failed to add step to project: $e');
    }
  }

  Future<ProjectSchema?> updateProjectStep(
    String projectId,
    String stepId,
    ProjectStepUpdateSchema body,
  ) async {
    try {
      return await _api.updateProjectStepProjectsProjectIdStepsStepIdPatch(
        projectId,
        stepId,
        body,
      );
    } catch (e) {
      throw Exception('Failed to update project step: $e');
    }
  }

  Future<ProjectSchema?> deleteProjectStep(
    String projectId,
    String stepId,
  ) async {
    try {
      return await _api.deleteProjectStepProjectsProjectIdStepsStepIdDelete(
        projectId,
        stepId,
      );
    } catch (e) {
      throw Exception('Failed to delete project step: $e');
    }
  }
}
