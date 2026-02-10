import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';

class ProjectsService {
  late final ProjectsApi _api;

  ProjectsService({String? baseUrl}) {
    final client = ApiClient(basePath: baseUrl ?? AppConstants.backendBaseUrl);
    _api = ProjectsApi(client);
  }

  Future<List<ProjectSchema>> listActiveProjects() async {
    try {
      final result = await _api.listActiveProjectsProjectsActiveGet();
      return result ?? [];
    } catch (e) {
      throw Exception('Failed to fetch active projects: $e');
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
      return await _api.updateProjectProjectsProjectIdPatch(projectId, body);
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
}
