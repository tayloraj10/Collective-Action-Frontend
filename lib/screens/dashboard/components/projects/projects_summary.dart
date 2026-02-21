import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/providers/project_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/projects/project_action_card.dart';
import 'package:collective_action_frontend/screens/dashboard/components/summary_count.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectsSummary extends ConsumerWidget {
  final IconData icon;
  final Color color;

  const ProjectsSummary({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = AppConstants.isMobile(context);
    final double cardPaddingHeight = isMobile ? 4 : 6;
    final double cardPaddingWidth = isMobile ? 6 : 10;
    final projectsAsync = ref.watch(activeProjectsProvider);
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: cardPaddingWidth,
          vertical: cardPaddingHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => safeGo(context, '/projects'),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: isMobile ? 2 : 0),
                      child: Icon(icon, color: color, size: isMobile ? 20 : 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: isMobile ? () => safeGo(context, '/projects') : null,
                    splashColor: isMobile
                        ? theme.colorScheme.primary.withAlpha(30)
                        : null,
                    highlightColor: isMobile
                        ? theme.colorScheme.primary.withAlpha(20)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Tooltip(
                                message:
                                    'Active projects you can contribute to',
                                child: Text(
                                  'Projects',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isMobile) ...[
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    18,
                                  ),
                                  border: Border.all(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(38),
                                  ),
                                ),
                                child: Icon(
                                  Icons.open_in_new,
                                  size: 14,
                                  color: theme.textTheme.titleLarge?.color
                                      ?.withAlpha(210),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Projects list
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    'Failed to load projects',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                data: (projects) {
                  if (projects.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: isMobile ? 40 : 56,
                            color: theme.colorScheme.onSurface.withAlpha(100),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No active projects',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () => safeGo(context, '/projects'),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create a project'),
                          ),
                        ],
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 0,
                                  runSpacing: 0,
                                  children: projects.map((project) {
                                    return ProjectActionCard(
                                      project: project,
                                      expandToFullWidth: false,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SummaryCount(count: projects.length),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
