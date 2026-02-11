import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/screens/projects/project_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectActionCard extends ConsumerWidget {
  final ProjectSchema project;
  final bool expandToFullWidth;

  const ProjectActionCard({
    super.key,
    required this.project,
    this.expandToFullWidth = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = AppConstants.isMobile(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final accentColor = AppColors.errorRed;
    final subtleAccent = AppColors.errorRed.withAlpha(isDark ? 150 : 255);

    // Calculate project progress
    final steps = project.steps;
    final totalSteps = steps.length;
    final completedSteps = steps.where((step) => step.completed).length;
    final progressPercent = totalSteps > 0
        ? (completedSteps / totalSteps * 100).round()
        : 0;

    Widget card = Tooltip(
      message: 'Click to view ${project.name}',
      child: GestureDetector(
        onTap: () => ProjectDetailDialog.show(context, project.id),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: expandToFullWidth ? (isMobile ? double.infinity : 180) : 180,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppColors.black.withAlpha(110)
                      : AppColors.black.withAlpha(40),
                  blurRadius: 7,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header section with gradient
                  Container(
                    padding: EdgeInsets.all(isMobile ? 8 : 10),
                    color: subtleAccent,
                    child: Row(
                      children: [
                        // Creator avatar
                        Tooltip(
                          message: 'Project Creator',
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: UserAvatar(
                              userId: project.creatorId,
                              showTooltip: true,
                              enableHero: true,
                              heroTagSuffix: project.id,
                              showProfileOnTap: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Project name
                        Expanded(
                          child: Tooltip(
                            message: project.name,
                            child: Text(
                              project.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                                fontSize: isMobile ? 12 : 13,
                                height: 1.2,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content section
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 8 : 10,
                      isMobile ? 7 : 9,
                      isMobile ? 8 : 10,
                      isMobile ? 8 : 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Tooltip(
                              message: 'Project',
                              child: Icon(
                                Icons.assignment_outlined,
                                color: accentColor,
                                size: isMobile ? 16 : 18,
                              ),
                            ),
                            // Progress indicator
                            if (totalSteps > 0) ...[
                              Tooltip(
                                message:
                                    '$completedSteps of $totalSteps steps complete',
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: progressPercent == 100
                                        ? AppColors.successGreen
                                        : accentColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (progressPercent == 100
                                                    ? AppColors.successGreen
                                                    : accentColor)
                                                .withAlpha(40),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        '$progressPercent%',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: isMobile ? 10 : 11,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            // Time indicator
                            Tooltip(
                              message:
                                  'Last Updated ${_formatTimeAgo(project.updatedAt)}',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.white.withAlpha(13)
                                      : AppColors.silver,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: isMobile ? 10 : 12,
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(128),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatTimeAgo(project.updatedAt),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withAlpha(153),
                                            fontSize: isMobile ? 9 : 10,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.1,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Stats section
                        if (_getTotalMemberCount() > 0 || totalSteps > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Members count - only show if there are members
                              if (_getTotalMemberCount() > 0)
                                _StatBadge(
                                  icon: Icons.people_outline,
                                  count: _getTotalMemberCount(),
                                  label: 'Members',
                                  theme: theme,
                                  isMobile: isMobile,
                                ),
                              // Steps count - only show if there are steps
                              if (totalSteps > 0)
                                _StatBadge(
                                  icon: Icons.list_alt,
                                  count: totalSteps,
                                  label: 'Steps',
                                  theme: theme,
                                  isMobile: isMobile,
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return card;
  }

  int _getTotalMemberCount() {
    final members = project.members;
    if (members == null) return 0;

    return members.owners.length +
        members.developers.length +
        members.members.length;
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final ThemeData theme;
  final bool isMobile;

  const _StatBadge({
    required this.icon,
    required this.count,
    required this.label,
    required this.theme,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isMobile ? 12 : 14,
              color: theme.colorScheme.onSurface.withAlpha(180),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 10 : 11,
                color: theme.colorScheme.onSurface.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
