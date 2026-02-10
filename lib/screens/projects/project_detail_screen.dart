import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/project_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/screens/projects/project_members_section.dart';
import 'package:collective_action_frontend/screens/projects/project_membership_button.dart';
import 'package:collective_action_frontend/screens/projects/project_steps_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(projectId));
    final isMobile = AppConstants.isMobile(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: projectAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load project',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => ref.refresh(projectByIdProvider(projectId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (project) {
          if (project == null) {
            return Center(
              child: Text(
                'Project not found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.visible,
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    _ProjectCreator(
                      creatorId: project.creatorId,
                      isMobile: isMobile,
                    ),
                    if (project.description != null &&
                        project.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        project.description!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                    if (project.steps.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      ProjectStepsSection(
                        steps: project.steps,
                        isMobile: isMobile,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ProjectMembersByRole(
                      members: project.members,
                      avatarSize: isMobile ? 36 : 40,
                      trailing: ProjectMembershipButton(
                        project: project,
                        isMobile: isMobile,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Dialog showing project detail. Use when a project card is tapped.
/// Provides "Open in full page" which closes the dialog and navigates to /projects/:id.
class ProjectDetailDialog extends ConsumerWidget {
  final String projectId;

  const ProjectDetailDialog({super.key, required this.projectId});

  static void show(BuildContext context, String projectId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => ProjectDetailDialog(projectId: projectId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(projectId));
    final isMobile = AppConstants.isMobile(context);
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? AppColors.darkSurfaceVariant.withAlpha(120)
                : AppColors.silverDark.withAlpha(180),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 80 : 40),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: icon, title (no duplicate in body), actions
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
              decoration: BoxDecoration(
                color:
                    (isDark ? AppColors.darkSurfaceVariant : AppColors.silver)
                        .withAlpha(isDark ? 80 : 120),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue.withAlpha(isDark ? 60 : 40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: AppColors.lightBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: projectAsync.when(
                      loading: () => Text(
                        'Project',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      error: (_, _) => Text(
                        'Project',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      data: (p) => Text(
                        p?.name ?? 'Project',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.visible,
                        maxLines: null,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      final router = GoRouter.of(context);
                      Navigator.of(context).pop();
                      router.go('/projects/$projectId');
                    },
                    icon: const Icon(Icons.open_in_full_rounded, size: 18),
                    label: const Text('Project Page'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.onSurface.withAlpha(
                        25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 20 : 24,
                  20,
                  isMobile ? 20 : 24,
                  24,
                ),
                child: projectAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: AppColors.errorRed.withAlpha(200),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load project',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          err.toString(),
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () =>
                              ref.refresh(projectByIdProvider(projectId)),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (project) {
                    if (project == null) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Project not found',
                          style: theme.textTheme.titleMedium,
                        ),
                      );
                    }
                    // No duplicate name – it's in the header
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ProjectCreator(
                          creatorId: project.creatorId,
                          isMobile: isMobile,
                        ),
                        if (project.description != null &&
                            project.description!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            project.description!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                              color: theme.colorScheme.onSurface.withAlpha(220),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (project.steps.isNotEmpty) ...[
                          ProjectStepsSection(
                            steps: project.steps,
                            isMobile: isMobile,
                          ),
                          const SizedBox(height: 24),
                        ],
                        ProjectMembersByRole(
                          members: project.members,
                          avatarSize: isMobile ? 36 : 40,
                          trailing: ProjectMembershipButton(
                            project: project,
                            isMobile: isMobile,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays the project creator's avatar and name.
class _ProjectCreator extends ConsumerWidget {
  final String creatorId;
  final bool isMobile;

  const _ProjectCreator({required this.creatorId, this.isMobile = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider(creatorId));

    return userAsync.when(
      loading: () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: isMobile ? 20 : 24,
            height: isMobile ? 20 : 24,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(
            'Created by...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
              fontSize: isMobile ? 13 : 14,
            ),
          ),
        ],
      ),
      error: (_, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(
            userId: creatorId,
            radius: isMobile ? 10 : 12,
            showProfileOnTap: true,
          ),
          const SizedBox(width: 8),
          Text(
            'Created by Unknown',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
              fontSize: isMobile ? 13 : 14,
            ),
          ),
        ],
      ),
      data: (user) {
        final displayName = user?.name ?? user?.email ?? 'Unknown';
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(
              userId: creatorId,
              radius: isMobile ? 10 : 12,
              showProfileOnTap: true,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Created by $displayName',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                  fontSize: isMobile ? 13 : 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
