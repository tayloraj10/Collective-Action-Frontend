import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:flutter/material.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';

class InitiativeActionCard extends ConsumerWidget {
  final ActionSchema action;
  final InitiativeSchema? initiative;
  const InitiativeActionCard({
    super.key,
    required this.action,
    this.initiative,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isOwner = currentUser != null && currentUser.id == action.userId;
    final isMobile = AppConstants.isMobile(context);
    final date = action.date;
    final timeString = _formatTimeAgo(date);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use AppColors from theme.dart
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final accentColor = AppColors.lightBlue;
    final subtleAccent = AppColors.lightBlue.withAlpha(isDark ? 150 : 255);

    InitiativeSchema? linkedInitiative = initiative;

    Widget card = Container(
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
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: UserAvatar(
                      userId: action.userId,
                      showTooltip: true,
                      enableHero: true,
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

    if (isOwner) {
      card = Badge(
        alignment: Alignment.topLeft,
        offset: Offset(-5, 1),
        backgroundColor: Colors.transparent,
        label: GestureDetector(
          onTap: () async {
            // Store ScaffoldMessenger before showing dialog to ensure it's available after
            final scaffoldMessenger = ScaffoldMessenger.of(context);

            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: 'Delete Action',
                content: 'Are you sure you want to delete this action?',
                confirmColor: Colors.redAccent,
              ),
            );
            if (confirm == true) {
              // Capture references upfront (before async operations) to avoid ref issues
              final actionNotifier = ref.read(activeActionProvider.notifier);
              final featuredInitiativesNotifier = ref.read(
                featuredInitiativeProvider.notifier,
              );

              try {
                // Delete the action (this already refreshes activeActionProvider)
                await actionNotifier.deleteAction(action);

                // Refresh featured initiatives provider to update initiative totals
                await featuredInitiativesNotifier.refresh();

                // Show success snackbar using stored ScaffoldMessenger
                scaffoldMessenger.showSnackBar(
                  CustomSnackBar.info('Action deleted!'),
                );
              } catch (e) {
                // Handle any errors gracefully
                scaffoldMessenger.showSnackBar(
                  CustomSnackBar.error('Error deleting action'),
                );
              }
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.delete, color: Colors.white, size: 12),
            ),
          ),
        ),
        child: card,
      );
    }
    return card;
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
