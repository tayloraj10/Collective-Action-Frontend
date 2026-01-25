import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final ActionSchema action;
  final InitiativeSchema? initiative;
  const ActionCard({super.key, required this.action, this.initiative});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final date = action.date;
    final timeString = _formatTimeAgo(date);
    final theme = Theme.of(context);
    final avatarUrl = action.imageUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    final isDark = theme.brightness == Brightness.dark;

    // Use AppColors from theme.dart
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final accentColor = isDark ? AppColors.lightBlue : AppColors.primaryBlue;
    final subtleAccent = isDark
        ? AppColors.lightBlue.withAlpha(130)
        : AppColors.primaryBlue.withAlpha(130);

    InitiativeSchema? linkedInitiative = initiative;

    return Container(
      width: isMobile ? 150 : 180,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.black.withAlpha(60)
                : AppColors.black.withAlpha(12),
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
                  // Enhanced Avatar with ring
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor.withAlpha(153)],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: isMobile ? 14 : 16,
                      backgroundColor: cardColor,
                      backgroundImage: hasAvatar
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: !hasAvatar
                          ? Icon(
                              Icons.person_rounded,
                              color: accentColor,
                              size: isMobile ? 16 : 18,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  Expanded(
                    child: Text(
                      linkedInitiative?.title ?? _titleForAction(action),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Amount badge (if exists)
                  if (action.amount != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentColor, accentColor.withAlpha(204)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withAlpha(40),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        '${action.amount}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: isMobile ? 10 : 11,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                  // Time indicator
                  Container(
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
                          color: theme.colorScheme.onSurface.withAlpha(128),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeString,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(153),
                            fontSize: isMobile ? 9 : 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _titleForAction(ActionSchema action) {
    if (action.actionType.isNotEmpty) return action.actionType;
    return 'Action';
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
