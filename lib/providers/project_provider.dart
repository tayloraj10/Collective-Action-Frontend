import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/projects_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final projectsServiceProvider = Provider<ProjectsService>((ref) {
  return ProjectsService();
});

final activeProjectsProvider =
    AsyncNotifierProvider<ActiveProjectsNotifier, List<ProjectSchema>>(
      ActiveProjectsNotifier.new,
    );

final projectsByCreatorProvider =
    AsyncNotifierProvider<ProjectsByCreatorNotifier, List<ProjectSchema>>(
      ProjectsByCreatorNotifier.new,
    );

final projectByIdProvider =
    FutureProvider.family<ProjectSchema?, String>((ref, projectId) async {
  final service = ref.watch(projectsServiceProvider);
  return service.getProject(projectId);
});

class ActiveProjectsNotifier extends AsyncNotifier<List<ProjectSchema>> {
  @override
  Future<List<ProjectSchema>> build() async {
    return ref.read(projectsServiceProvider).listActiveProjects();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(projectsServiceProvider).listActiveProjects();
    });
  }
}

class ProjectsByCreatorNotifier extends AsyncNotifier<List<ProjectSchema>> {
  @override
  Future<List<ProjectSchema>> build() async {
    // Get the current user from the user provider
    final currentUser = ref.watch(currentUserProvider).value;
    final userId = currentUser?.id;
    if (userId == null) {
      return [];
    }
    return ref.read(projectsServiceProvider).listProjectsByCreator(userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(currentUserProvider).value;
      final userId = currentUser?.id;
      if (userId == null) {
        return [];
      }
      return ref.read(projectsServiceProvider).listProjectsByCreator(userId);
    });
  }
}
