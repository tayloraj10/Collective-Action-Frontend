import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/project_provider.dart';
import 'package:collective_action_frontend/screens/projects/project_card.dart';
import 'package:collective_action_frontend/screens/projects/project_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = AppConstants.isMobile(context);
    final projectsAsync = ref.watch(activeProjectsProvider);
    final previousData = projectsAsync.asData?.value;

    final List<Color> palette = [
      AppColors.lightBlue,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.purple,
      AppColors.primaryBlue,
      Colors.cyan,
      Colors.deepPurple,
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref, isMobile, projectsAsync),
              SizedBox(height: isMobile ? 20 : 28),
              Expanded(
                child: projectsAsync.when(
                  loading: () {
                    if (previousData != null && previousData.isNotEmpty) {
                      return _buildProjectList(
                        context,
                        ref,
                        projects: previousData,
                        isMobile: isMobile,
                        palette: palette,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (err, _) => _buildError(context, ref, err),
                  data: (projects) {
                    if (projects.isEmpty) {
                      return _buildEmpty(context);
                    }
                    return _buildProjectList(
                      context,
                      ref,
                      projects: projects,
                      isMobile: isMobile,
                      palette: palette,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool isMobile,
    AsyncValue<List<ProjectSchema>> projectsAsync,
  ) {
    final theme = Theme.of(context);
    final count = projectsAsync.asData?.value.length ?? 0;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.assignment_rounded,
            color: theme.colorScheme.primary,
            size: isMobile ? 28 : 36,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Projects',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count == 1 ? '1 project' : '$count projects',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList(
    BuildContext context,
    WidgetRef ref, {
    required List<ProjectSchema> projects,
    required bool isMobile,
    required List<Color> palette,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(activeProjectsProvider.notifier).refresh();
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: projects.length,
        separatorBuilder: (_, _) => SizedBox(height: isMobile ? 12 : 16),
        itemBuilder: (context, idx) {
          final project = projects[idx];
          final accentColor = palette[idx % palette.length];
          return ProjectCard(
            project: project,
            accentColor: accentColor,
            isMobile: isMobile,
            onTap: () => ProjectDetailDialog.show(context, project.id),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.errorRed.withAlpha(200),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load projects',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              err.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.errorRed),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                ref.read(activeProjectsProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.lightBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 80,
            color: theme.colorScheme.onSurface.withAlpha(100),
          ),
          const SizedBox(height: 20),
          Text(
            'No projects yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Active projects will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}
