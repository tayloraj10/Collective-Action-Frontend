import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/screens/projects/project_members_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectCard extends ConsumerWidget {
  final ProjectSchema project;
  final Color accentColor;
  final bool isMobile;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.accentColor,
    this.isMobile = true,
    this.onTap,
  });

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardRadius = isMobile ? 12.0 : 16.0;
    final stepCount = project.steps.length;
    final userAsync = ref.watch(userProvider(project.creatorId));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardRadius),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 14 : 18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(
              color: isDark
                  ? AppColors.darkSurfaceVariant.withAlpha(100)
                  : accentColor.withAlpha(80),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.black.withAlpha(60)
                    : accentColor.withAlpha(25),
                blurRadius: isMobile ? 8 : 12,
                offset: const Offset(0, 3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(isDark ? 60 : 40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.topic_rounded,
                      color: accentColor,
                      size: isMobile ? 22 : 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                            fontSize: isMobile ? 15 : 17,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        userAsync.when(
                          loading: () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    120,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'by...',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    120,
                                  ),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          error: (_, _) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UserAvatar(
                                userId: project.creatorId,
                                radius: 8,
                                showProfileOnTap: true,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'by Unknown',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    120,
                                  ),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          data: (user) {
                            final displayName =
                                user?.name ?? user?.email ?? 'Unknown';
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                UserAvatar(
                                  userId: project.creatorId,
                                  radius: 8,
                                  showProfileOnTap: true,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'by $displayName',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(120),
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        if (project.description != null &&
                            project.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            project.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(180),
                              fontSize: isMobile ? 12 : 13,
                              height: 1.35,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 10 : 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: project.active
                          ? AppColors.successGreen.withAlpha(isDark ? 60 : 45)
                          : (isDark
                                ? theme.colorScheme.onSurface.withAlpha(25)
                                : AppColors.silver),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          project.active
                              ? Icons.check_circle_rounded
                              : Icons.remove_circle_outline_rounded,
                          size: 14,
                          color: project.active
                              ? AppColors.successGreen
                              : theme.colorScheme.onSurface.withAlpha(150),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          project.active ? 'Active' : 'Inactive',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: project.active
                                ? AppColors.successGreen
                                : theme.colorScheme.onSurface.withAlpha(150),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (stepCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(isDark ? 35 : 25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.format_list_numbered_rounded,
                            size: 14,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$stepCount step${stepCount == 1 ? '' : 's'}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (ProjectMembersSummary.hasMembers(project.members))
                    ProjectMembersSummary(
                      members: project.members,
                      isMobile: isMobile,
                      accentColor: accentColor,
                    ),
                  Text(
                    'Updated ${_formatDate(project.updatedAt)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
