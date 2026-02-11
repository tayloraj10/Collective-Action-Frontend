import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/config_provider.dart';
import 'package:collective_action_frontend/providers/project_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/projects/project_card.dart';
import 'package:collective_action_frontend/screens/projects/project_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectListScreen extends ConsumerStatefulWidget {
  const ProjectListScreen({super.key});

  @override
  ConsumerState<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends ConsumerState<ProjectListScreen> {
  bool _showOnlyMyProjects = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final projectsAsync = ref.watch(
      _showOnlyMyProjects ? projectsByCreatorProvider : activeProjectsProvider,
    );
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

    // Check if user already has a project
    final myProjectsAsync = ref.watch(projectsByCreatorProvider);
    final hasProject = myProjectsAsync.asData?.value.isNotEmpty ?? false;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isMobile, projectsAsync, hasProject),
              SizedBox(height: isMobile ? 16 : 20),
              _buildFilterToggle(isMobile),
              SizedBox(height: isMobile ? 20 : 28),
              Expanded(
                child: projectsAsync.when(
                  loading: () {
                    if (previousData != null && previousData.isNotEmpty) {
                      return _buildProjectList(
                        projects: previousData,
                        isMobile: isMobile,
                        palette: palette,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (err, _) => _buildError(err),
                  data: (projects) {
                    if (projects.isEmpty) {
                      return _buildEmpty();
                    }
                    return _buildProjectList(
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
    bool isMobile,
    AsyncValue<List<ProjectSchema>> projectsAsync,
    bool hasProject,
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
        if (!hasProject) ...[
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: _showCreateProjectDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Project'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilterToggle(bool isMobile) {
    final theme = Theme.of(context);
    return Row(
      children: [
        ChoiceChip(
          label: const Text('All Projects'),
          selected: !_showOnlyMyProjects,
          onSelected: (selected) {
            if (selected) {
              setState(() => _showOnlyMyProjects = false);
            }
          },
          selectedColor: theme.colorScheme.primary,
          labelStyle: TextStyle(
            color: !_showOnlyMyProjects
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: !_showOnlyMyProjects
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text('My Projects'),
          selected: _showOnlyMyProjects,
          onSelected: (selected) {
            if (selected) {
              setState(() => _showOnlyMyProjects = true);
            }
          },
          selectedColor: theme.colorScheme.primary,
          labelStyle: TextStyle(
            color: _showOnlyMyProjects
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: _showOnlyMyProjects ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList({
    required List<ProjectSchema> projects,
    required bool isMobile,
    required List<Color> palette,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        if (_showOnlyMyProjects) {
          await ref.read(projectsByCreatorProvider.notifier).refresh();
        } else {
          await ref.read(activeProjectsProvider.notifier).refresh();
        }
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

  Widget _buildError(Object err) {
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
                if (_showOnlyMyProjects) {
                  ref.read(projectsByCreatorProvider.notifier).refresh();
                } else {
                  ref.read(activeProjectsProvider.notifier).refresh();
                }
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

  Widget _buildEmpty() {
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
            _showOnlyMyProjects
                ? 'Projects you create will appear here'
                : 'Active projects will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => const _CreateProjectDialog(),
    );
  }
}

class _CreateProjectDialog extends ConsumerStatefulWidget {
  const _CreateProjectDialog();

  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedStatusId;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = AppConstants.isMobile(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final statusesAsync = ref.watch(statusesProvider);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          const Text('Create New Project'),
        ],
      ),
      content: SizedBox(
        width: isMobile ? double.maxFinite : 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    hintText: 'Enter project name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a project name';
                    }
                    return null;
                  },
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter project description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  enabled: !_isSaving,
                ),
                const SizedBox(height: 16),
                categoriesAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text(
                    'Failed to load categories',
                    style: TextStyle(color: AppColors.errorRed),
                  ),
                  data: (categories) {
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('None'),
                        ),
                        ...categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }),
                      ],
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              setState(() => _selectedCategoryId = value);
                            },
                    );
                  },
                ),
                const SizedBox(height: 16),
                statusesAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text(
                    'Failed to load statuses',
                    style: TextStyle(color: AppColors.errorRed),
                  ),
                  data: (statuses) {
                    // Filter to only project statuses
                    final projectStatuses = statuses
                        .where(
                          (s) => s.statusType == StatusTypeEnum.projectStatus,
                        )
                        .toList();

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedStatusId,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('None'),
                        ),
                        ...projectStatuses.map((status) {
                          return DropdownMenuItem(
                            value: status.id,
                            child: Text(status.name.value),
                          );
                        }),
                      ],
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              setState(() => _selectedStatusId = value);
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSaving ? null : _createProject,
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check_rounded),
          label: Text(_isSaving ? 'Creating...' : 'Create'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.primaryBlue),
        ),
      ],
    );
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    // Store context references before async gap
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser?.id == null) {
        throw Exception('User not authenticated');
      }

      final service = ref.read(projectsServiceProvider);
      final project = await service.createProject(
        ProjectCreateSchema(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          categoryId: _selectedCategoryId,
          statusId: _selectedStatusId,
          creatorId: currentUser!.id!,
          active: true,
          members: MemberIdsByRole(
            owners: [currentUser.id!],
            developers: [],
            members: [],
          ),
        ),
      );

      if (project == null) {
        throw Exception('Failed to create project');
      }

      // Refresh both providers
      ref.invalidate(activeProjectsProvider);
      ref.invalidate(projectsByCreatorProvider);

      if (!mounted) return;

      navigator.pop();
      messenger.showSnackBar(
        CustomSnackBar.success('Project created successfully'),
      );

      // Navigate to the new project
      if (mounted) {
        ProjectDetailDialog.show(context, project.id);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSaving = false);
      messenger.showSnackBar(CustomSnackBar.error('Failed to create project'));
    }
  }
}
