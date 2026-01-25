import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
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
    final cardColor = Color.alphaBlend(
      theme.colorScheme.surfaceContainerHighest.withAlpha(179),
      theme.colorScheme.surface,
    );
    final borderColor = theme.brightness == Brightness.dark
        ? Colors.white.withAlpha(33)
        : Colors.black.withAlpha(33);

    // Use initiative if provided
    InitiativeSchema? linkedInitiative = initiative;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 18,
          vertical: isMobile ? 10 : 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: isMobile ? 22 : 28,
              backgroundColor: Color.alphaBlend(
                theme.colorScheme.primary.withAlpha(25),
                theme.colorScheme.surface,
              ),
              backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
              child: !hasAvatar
                  ? Icon(
                      Icons.person,
                      color: theme.colorScheme.primary,
                      size: isMobile ? 26 : 32,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          linkedInitiative?.title ?? _titleForAction(action),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (timeString.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: isMobile ? 13 : 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeString,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade500,
                                fontSize: isMobile ? 11 : 13,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (action.amount != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Amount: ${action.amount}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: isMobile ? 13 : 15,
                        ),
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
