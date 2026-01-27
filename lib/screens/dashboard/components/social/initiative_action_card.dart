import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';

class InitiativeActionCard extends StatelessWidget {
  final ActionSchema action;
  final InitiativeSchema? initiative;
  const InitiativeActionCard({
    super.key,
    required this.action,
    this.initiative,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppConstants.isMobile(context);
    final date = action.date;
    final timeString = _formatTimeAgo(date);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use AppColors from theme.dart
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final accentColor = AppColors.lightBlue;
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
        // border: Border.all(color: AppColors.darkBackground, width: .75),
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
                  // User avatar
                  UserAvatar(userId: action.userId),
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
                  Tooltip(
                    message: 'Initiative Action',
                    child: Icon(
                      Icons.trending_up,
                      color: accentColor,
                      size: isMobile ? 16 : 18,
                    ),
                  ),
                  // Amount badge (if exists)
                  if (action.amount != null) ...[
                    Tooltip(
                      message: 'Amount Completed',
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withAlpha(40),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                  size: isMobile ? 10 : 11,
                                ),
                                Text(
                                  '${action.amount}',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isMobile ? 10 : 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

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
