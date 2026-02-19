import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/utils/step_status_utils.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:collective_action_frontend/providers/project_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/screens/projects/project_members_section.dart';
import 'package:collective_action_frontend/screens/projects/project_membership_button.dart';
import 'package:collective_action_frontend/screens/projects/project_steps_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:collective_action_frontend/utils/safe_navigation.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync = ref.watch(projectByIdProvider(widget.projectId));
    final isMobile = AppConstants.isMobile(context);
    final currentUser = ref.watch(currentUserProvider).value;
    final currentUserId = currentUser?.id;

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
                  onPressed: () =>
                      ref.refresh(projectByIdProvider(widget.projectId)),
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

          final isCreator =
              currentUserId != null && currentUserId == project.creatorId;

          // Initialize controllers when entering edit mode
          if (_isEditing &&
              (_nameController.text.isEmpty ||
                  _nameController.text != project.name)) {
            _nameController.text = project.name;
            _descriptionController.text = project.description ?? '';
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
                    // Back button
                    TextButton.icon(
                      onPressed: () => safeGo(context, '/projects'),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('Back to Projects'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProjectHeader(context, project, isMobile, isCreator),
                    if (_isEditing) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.lightBlue.withAlpha(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: AppColors.lightBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Editing Mode - Make your changes and click Save',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: AppColors.lightBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    _ProjectCreator(
                      creatorId: project.creatorId,
                      isMobile: isMobile,
                    ),
                    if (_isEditing ||
                        (project.description != null &&
                            project.description!.isNotEmpty)) ...[
                      const SizedBox(height: 12),
                      _buildDescription(context, project),
                    ],
                    if (_isEditing || project.steps.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildStepsSection(context, project, isMobile),
                    ],
                    const SizedBox(height: 24),
                    _buildMembersSection(context, project, isMobile, isCreator),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectHeader(
    BuildContext context,
    ProjectSchema project,
    bool isMobile,
    bool isCreator,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _isEditing
              ? TextField(
                  controller: _nameController,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: null,
                )
              : Text(
                  project.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: null,
                ),
        ),
        if (isCreator) ...[
          const SizedBox(width: 16),
          if (_isEditing && !_isSaving) ...[
            // Show cancel button when editing (not saving)
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  // Reset form values
                  _nameController.clear();
                  _descriptionController.clear();
                });
              },
              icon: Icon(Icons.close, size: isMobile ? 18 : 20),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (!_isEditing && !_isSaving) ...[
            // Show delete button when not editing
            IconButton(
              onPressed: () => _deleteProject(context, project),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete Project',
              color: AppColors.errorRed,
              iconSize: isMobile ? 20 : 24,
            ),
            const SizedBox(width: 8),
          ],
          if (_isSaving)
            FilledButton.icon(
              onPressed: null,
              icon: SizedBox(
                width: isMobile ? 16 : 18,
                height: isMobile ? 16 : 18,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              label: const Text('Saving...'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.lightBlue,
                disabledBackgroundColor: AppColors.lightBlue.withAlpha(150),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 12,
                ),
              ),
            )
          else
            FilledButton.icon(
              onPressed: () async {
                if (_isEditing) {
                  await _saveChanges();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
              icon: Icon(
                _isEditing ? Icons.save : Icons.edit,
                size: isMobile ? 18 : 20,
              ),
              label: Text(_isEditing ? 'Save' : 'Edit'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.lightBlue,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 12,
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildDescription(BuildContext context, ProjectSchema project) {
    if (_isEditing) {
      return TextField(
        controller: _descriptionController,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        maxLines: null,
        minLines: 3,
      );
    }
    return Text(
      project.description ?? '',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildStepsSection(
    BuildContext context,
    ProjectSchema project,
    bool isMobile,
  ) {
    if (_isEditing) {
      return _EditableProjectStepsSection(
        projectId: widget.projectId,
        steps: project.steps,
        isMobile: isMobile,
        onUpdate: () {
          ref.invalidate(projectByIdProvider(widget.projectId));
          ref.invalidate(activeProjectsProvider);
          ref.invalidate(projectsByCreatorProvider);
        },
      );
    }
    return ProjectStepsSection(steps: project.steps, isMobile: isMobile);
  }

  Widget _buildMembersSection(
    BuildContext context,
    ProjectSchema project,
    bool isMobile,
    bool isCreator,
  ) {
    if (_isEditing && isCreator) {
      return _EditableProjectMembersSection(
        projectId: widget.projectId,
        members: project.members,
        avatarSize: isMobile ? 36 : 40,
        onUpdate: () {
          ref.invalidate(projectByIdProvider(widget.projectId));
          ref.invalidate(activeProjectsProvider);
          ref.invalidate(projectsByCreatorProvider);
        },
      );
    }
    return ProjectMembersByRole(
      members: project.members,
      avatarSize: isMobile ? 36 : 40,
      trailing: ProjectMembershipButton(project: project, isMobile: isMobile),
    );
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final service = ref.read(projectsServiceProvider);

      await service.updateProject(
        widget.projectId,
        ProjectUpdateSchema(
          name: _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : null,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          steps: null, // Will be removed from JSON by service
        ),
      );

      // Refresh all project-related providers to get fresh data
      ref.invalidate(projectByIdProvider(widget.projectId));
      ref.invalidate(activeProjectsProvider);
      ref.invalidate(projectsByCreatorProvider);

      if (mounted) {
        setState(() {
          _isSaving = false;
          _isEditing = false; // Exit editing mode after successful save
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.success('Project updated successfully'));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Failed to update project'));
      }
    }
  }

  Future<void> _deleteProject(
    BuildContext context,
    ProjectSchema project,
  ) async {
    // Store context references before any async operations
    final navigator = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text(
          'Are you sure you want to delete "${project.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;

      try {
        final service = ref.read(projectsServiceProvider);
        await service.deleteProject(widget.projectId);

        // Refresh the project lists
        ref.invalidate(activeProjectsProvider);
        ref.invalidate(projectsByCreatorProvider);

        if (!mounted) return;

        // Navigate back to projects list
        navigator.go('/projects');

        // Show success message
        messenger.showSnackBar(
          CustomSnackBar.success('Project deleted successfully'),
        );
      } catch (e) {
        if (!mounted) return;

        messenger.showSnackBar(
          CustomSnackBar.error('Failed to delete project: $e'),
        );
      }
    }
  }
}

/// Dialog showing project detail. Use when a project card is tapped.
/// Provides "Open in full page" which closes the dialog and navigates to /projects/:id.
class ProjectDetailDialog extends ConsumerWidget {
  final String projectId;

  const ProjectDetailDialog({super.key, required this.projectId});

  /// Same opening style as initiative submission: showDialog with Dialog(child: content).
  /// Opens after the current tap to reduce mobile Chrome crashes.
  static void show(BuildContext context, String projectId) {
    scheduleAfterTap(context, () {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 48,
          ),
          backgroundColor: Colors.transparent,
          child: ProjectDetailDialog(projectId: projectId),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(projectId));
    final isMobile = AppConstants.isMobile(context);
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
              color: (isDark ? AppColors.darkSurfaceVariant : AppColors.silver)
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
                    final route = '/projects/$projectId';
                    // Pop then go in separate ticks to avoid mobile Chrome crash.
                    scheduleAfterTap(context, () {
                      if (!context.mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                      Future.microtask(() => router.go(route));
                    });
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
                  onPressed: () => safePop(context, rootNavigator: true),
                  tooltip: 'Close',
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface.withAlpha(25),
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
    );
  }
}

/// Editable steps section for project creators
class _EditableProjectStepsSection extends ConsumerStatefulWidget {
  final String projectId;
  final List<ProjectStepSchema> steps;
  final bool isMobile;
  final VoidCallback onUpdate;

  const _EditableProjectStepsSection({
    required this.projectId,
    required this.steps,
    required this.isMobile,
    required this.onUpdate,
  });

  @override
  ConsumerState<_EditableProjectStepsSection> createState() =>
      _EditableProjectStepsSectionState();
}

class _EditableProjectStepsSectionState
    extends ConsumerState<_EditableProjectStepsSection> {
  List<ProjectStepSchema>? _localSteps;

  @override
  void didUpdateWidget(_EditableProjectStepsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.steps != widget.steps) {
      _localSteps = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use local steps if reordering, otherwise use widget steps
    final steps = _localSteps ?? widget.steps;
    final sorted = List<ProjectStepSchema>.from(steps)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.format_list_numbered_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Steps',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            IconButton.filled(
              onPressed: () => _addStep(context),
              icon: const Icon(Icons.add, size: 20),
              tooltip: 'Add Step',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.lightBlue,
                minimumSize: const Size(36, 36),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorder: _onReorder,
          children: sorted.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return ReorderableDragStartListener(
              key: ValueKey(step.id),
              index: index,
              child: _EditableStepTile(
                projectId: widget.projectId,
                step: step,
                onUpdate: widget.onUpdate,
                isDark: isDark,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      // Adjust the index if moving down
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // Create a mutable copy of the sorted list
      final sorted = List<ProjectStepSchema>.from(_localSteps ?? widget.steps)
        ..sort((a, b) => a.order.compareTo(b.order));

      // Move the item
      final item = sorted.removeAt(oldIndex);
      sorted.insert(newIndex, item);

      // Update orders
      _localSteps = sorted.asMap().entries.map((entry) {
        return ProjectStepSchema(
          id: entry.value.id,
          projectId: entry.value.projectId,
          order: entry.key,
          title: entry.value.title,
          description: entry.value.description,
          completed: entry.value.completed,
          statusId: entry.value.statusId,
        );
      }).toList();
    });

    // Update the backend
    await _updateStepOrders();
  }

  Future<void> _updateStepOrders() async {
    if (_localSteps == null) return;

    try {
      final service = ref.read(projectsServiceProvider);

      // Update each step's order in the backend
      for (final step in _localSteps!) {
        await service.updateProjectStep(
          widget.projectId,
          step.id,
          ProjectStepUpdateSchema(
            order: step.order,
            title: step.title,
            description: step.description,
            completed: step.completed,
            statusId: step.statusId,
          ),
        );
      }

      widget.onUpdate();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Failed to reorder steps: $e'));
      }
    }
  }

  void _addStep(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _StepDialog(
        projectId: widget.projectId,
        onSave: widget.onUpdate,
        order: widget.steps.length,
      ),
    );
  }
}

class _EditableStepTile extends ConsumerWidget {
  final String projectId;
  final ProjectStepSchema step;
  final VoidCallback onUpdate;
  final bool isDark;

  const _EditableStepTile({
    required this.projectId,
    required this.step,
    required this.onUpdate,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Load statuses for status badge display
    final statusesAsync = ref.watch(statusesProvider);
    final statuses = statusesAsync.asData?.value ?? [];

    // Look up status by ID
    StatusSchema? status;
    if (step.statusId != null) {
      status = statuses.cast<StatusSchema?>().firstWhere(
        (s) => s?.id == step.statusId,
        orElse: () => null,
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                Icons.drag_handle,
                size: 20,
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    step.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (step.description != null &&
                      step.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(step.description!, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            if (status != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(
                    status.name,
                    theme,
                  ).withAlpha(isDark ? 50 : 35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.name.value,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _statusColor(status.name, theme),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _editStep(context),
              icon: const Icon(Icons.edit, size: 20),
              tooltip: 'Edit',
            ),
            IconButton(
              onPressed: () => _deleteStep(context, ref),
              icon: const Icon(Icons.delete, size: 20),
              tooltip: 'Delete',
              color: AppColors.errorRed,
            ),
          ],
        ),
      ),
    );
  }

  static Color _statusColor(StatusValuesEnum statusName, ThemeData theme) =>
      stepStatusColor(statusName.value, theme);

  void _editStep(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) =>
          _StepDialog(projectId: projectId, step: step, onSave: onUpdate),
    );
  }

  Future<void> _deleteStep(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Step'),
        content: const Text('Are you sure you want to delete this step?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = ref.read(projectsServiceProvider);
        await service.deleteProjectStep(projectId, step.id);
        onUpdate();
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(CustomSnackBar.success('Step deleted successfully'));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(CustomSnackBar.error('Failed to delete step: $e'));
        }
      }
    }
  }
}

class _StepDialog extends ConsumerStatefulWidget {
  final String projectId;
  final ProjectStepSchema? step;
  final VoidCallback onSave;
  final int? order;

  const _StepDialog({
    required this.projectId,
    this.step,
    required this.onSave,
    this.order,
  });

  @override
  ConsumerState<_StepDialog> createState() => _StepDialogState();
}

class _StepDialogState extends ConsumerState<_StepDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String? _selectedStatusId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.step?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.step?.description ?? '',
    );
    _selectedStatusId = widget.step?.statusId;

    // Set default status after this initState completes (avoid setState during build)
    Future.microtask(() {
      if (!mounted || _selectedStatusId != null) return;
      final statusesAsync = ref.read(statusesProvider);
      final allStatuses = statusesAsync.asData?.value ?? [];
      final stepStatuses = sortStepStatusesByOrder(
        allStatuses
            .where((status) => status.statusType == StatusTypeEnum.stepStatus)
            .toList(),
      );

      if (stepStatuses.isNotEmpty) {
        setState(() {
          _selectedStatusId = stepStatuses.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusesAsync = ref.watch(statusesProvider);
    final allStatuses = statusesAsync.asData?.value ?? [];

    // Filter to only show "Step Status" type statuses, then sort in logical order
    final stepStatuses = sortStepStatusesByOrder(
      allStatuses
          .where((status) => status.statusType == StatusTypeEnum.stepStatus)
          .toList(),
    );
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.step == null ? 'Add Step' : 'Edit Step'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatusId,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: stepStatuses.map((status) {
                final color = stepStatusColor(status.name.value, theme);
                return DropdownMenuItem<String>(
                  value: status.id,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(status.name.value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatusId = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.error('Title is required'));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(projectsServiceProvider);

      // Get the selected status to check if it's "Completed"
      final statusesAsync = ref.read(statusesProvider);
      final allStatuses = statusesAsync.asData?.value ?? [];
      final selectedStatus = allStatuses.firstWhere(
        (s) => s.id == _selectedStatusId,
        orElse: () => allStatuses.first,
      );

      // Set completed to true if status is "Completed"
      final isCompleted = selectedStatus.name == StatusValuesEnum.completed;

      if (widget.step == null) {
        // Create new step
        final createBody = ProjectStepCreateSchema(
          title: title,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          order: widget.order ?? 0,
          completed: isCompleted,
          statusId: _selectedStatusId,
        );
        await service.addStepToProject(widget.projectId, createBody);
      } else {
        // Update existing step
        final updateBody = ProjectStepUpdateSchema(
          title: title,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          order: widget.step!.order,
          completed: isCompleted,
          statusId: _selectedStatusId,
        );
        await service.updateProjectStep(
          widget.projectId,
          widget.step!.id,
          updateBody,
        );
      }

      widget.onSave();
      if (!mounted) return;

      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      navigator.pop();
      messenger.showSnackBar(
        CustomSnackBar.success(
          widget.step == null
              ? 'Step added successfully'
              : 'Step updated successfully',
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.error('Failed to save step: $e'));
    }
  }
}

/// Editable members section for project creators
class _EditableProjectMembersSection extends ConsumerWidget {
  final String projectId;
  final MemberIdsByRole? members;
  final double avatarSize;
  final VoidCallback onUpdate;

  const _EditableProjectMembersSection({
    required this.projectId,
    required this.members,
    required this.avatarSize,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.people_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Team',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (members != null) ...[
          if (members!.owners.isNotEmpty) ...[
            _EditableRoleSection(
              label: 'Owners',
              color: AppColors.warningOrange,
              ids: members!.owners,
              projectId: projectId,
              avatarSize: avatarSize,
              isDark: isDark,
              onUpdate: onUpdate,
            ),
            const SizedBox(height: 14),
          ],
          if (members!.developers.isNotEmpty) ...[
            _EditableRoleSection(
              label: 'Developers',
              color: AppColors.lightBlue,
              ids: members!.developers,
              projectId: projectId,
              avatarSize: avatarSize,
              isDark: isDark,
              onUpdate: onUpdate,
            ),
            const SizedBox(height: 14),
          ],
          if (members!.members.isNotEmpty)
            _EditableRoleSection(
              label: 'Members',
              color: theme.colorScheme.onSurface.withAlpha(isDark ? 160 : 140),
              ids: members!.members,
              projectId: projectId,
              avatarSize: avatarSize,
              isDark: isDark,
              onUpdate: onUpdate,
            ),
        ],
      ],
    );
  }
}

class _EditableRoleSection extends StatelessWidget {
  final String label;
  final Color color;
  final List<String> ids;
  final String projectId;
  final double avatarSize;
  final bool isDark;
  final VoidCallback onUpdate;

  const _EditableRoleSection({
    required this.label,
    required this.color,
    required this.ids,
    required this.projectId,
    required this.avatarSize,
    required this.isDark,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${ids.length})',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ids
              .map(
                (userId) => _EditableMemberChip(
                  userId: userId,
                  projectId: projectId,
                  currentRole: _roleFromLabel(label),
                  avatarSize: avatarSize,
                  isDark: isDark,
                  onUpdate: onUpdate,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  String _roleFromLabel(String label) {
    switch (label) {
      case 'Owners':
        return 'owners';
      case 'Developers':
        return 'developers';
      default:
        return 'members';
    }
  }
}

class _EditableMemberChip extends ConsumerWidget {
  final String userId;
  final String projectId;
  final String currentRole;
  final double avatarSize;
  final bool isDark;
  final VoidCallback onUpdate;

  const _EditableMemberChip({
    required this.userId,
    required this.projectId,
    required this.currentRole,
    required this.avatarSize,
    required this.isDark,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      loading: () => Chip(
        avatar: SizedBox(
          width: avatarSize,
          height: avatarSize,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
        label: const Text('Loading...'),
      ),
      error: (_, _) => _buildChip(
        context,
        avatar: UserAvatar(
          userId: userId,
          radius: avatarSize / 2,
          showProfileOnTap: true,
        ),
        name: 'Unknown',
        theme: theme,
      ),
      data: (user) => _buildChip(
        context,
        avatar: UserAvatar(
          userId: userId,
          radius: avatarSize / 2,
          showProfileOnTap: true,
        ),
        name: user?.name ?? user?.email ?? 'Unknown',
        theme: theme,
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required Widget avatar,
    required String name,
    required ThemeData theme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showRoleOptions(context),
        borderRadius: BorderRadius.circular(avatarSize / 2 + 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.onSurface.withAlpha(20)
                : AppColors.silver.withAlpha(200),
            borderRadius: BorderRadius.circular(avatarSize / 2 + 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              avatar,
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Text(
                  name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoleOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star, color: AppColors.warningOrange),
              title: const Text('Add as Owner'),
              enabled: currentRole != 'owners',
              onTap: currentRole != 'owners'
                  ? () {
                      Navigator.pop(ctx);
                      _changeRole(context, 'owners');
                    }
                  : null,
            ),
            ListTile(
              leading: const Icon(Icons.code, color: AppColors.lightBlue),
              title: const Text('Add as Developer'),
              enabled: currentRole != 'developers',
              onTap: currentRole != 'developers'
                  ? () {
                      Navigator.pop(ctx);
                      _changeRole(context, 'developers');
                    }
                  : null,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Set as Member'),
              enabled: currentRole != 'members',
              onTap: currentRole != 'members'
                  ? () {
                      Navigator.pop(ctx);
                      _changeRole(context, 'members');
                    }
                  : null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.remove_circle,
                color: AppColors.errorRed,
              ),
              title: const Text('Remove from Project'),
              onTap: () {
                Navigator.pop(ctx);
                _removeMember(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeRole(BuildContext context, String newRole) async {
    try {
      final ref = ProviderScope.containerOf(context);
      final service = ref.read(projectsServiceProvider);
      final messenger = ScaffoldMessenger.of(context);

      // Convert string role to enum
      final roleEnum = _roleToEnum(newRole);

      // Remove from current role and add to new role
      await service.removeMemberFromProject(projectId, userId);
      await service.addMemberToProject(
        projectId,
        AddProjectMemberSchema(userId: userId, role: roleEnum),
      );

      onUpdate();
      if (context.mounted) {
        messenger.showSnackBar(
          CustomSnackBar.success('Member role updated successfully'),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Failed to update role: $e'));
      }
    }
  }

  AddProjectMemberSchemaRoleEnum _roleToEnum(String role) {
    switch (role) {
      case 'owners':
        return AddProjectMemberSchemaRoleEnum.owners;
      case 'developers':
        return AddProjectMemberSchemaRoleEnum.developers;
      default:
        return AddProjectMemberSchemaRoleEnum.members;
    }
  }

  Future<void> _removeMember(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Member'),
        content: const Text(
          'Are you sure you want to remove this member from the project?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final ref = ProviderScope.containerOf(context);
        final service = ref.read(projectsServiceProvider);
        final messenger = ScaffoldMessenger.of(context);

        await service.removeMemberFromProject(projectId, userId);
        onUpdate();
        if (context.mounted) {
          messenger.showSnackBar(
            CustomSnackBar.success('Member removed successfully'),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(CustomSnackBar.error('Failed to remove member: $e'));
        }
      }
    }
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
