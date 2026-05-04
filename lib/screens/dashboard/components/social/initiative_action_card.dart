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
import 'package:collective_action_frontend/components/photo_thumbnail_strip.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/action_like_row.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:collective_action_frontend/screens/maps/components/photo_viewer_dialog.dart';
import 'package:collective_action_frontend/services/photos_service.dart';

class InitiativeActionCard extends ConsumerWidget {
  final ActionSchema action;
  final InitiativeSchema? initiative;
  final bool expandToFullWidth;

  /// Full-width timeline layout for the /social page feed.
  /// When false (default), uses the compact grid card for the dashboard.
  final bool feedMode;

  final void Function(String initiativeId)? onActionDeleted;

  const InitiativeActionCard({
    super.key,
    required this.action,
    this.initiative,
    this.expandToFullWidth = true,
    this.feedMode = false,
    this.onActionDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isOwner = currentUser != null && currentUser.id == action.userId;
    final isMobile = AppConstants.isMobile(context);
    final timeString = _formatTimeAgo(action.date);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const accentColor = AppColors.lightBlue;
    final linkedInitiative = initiative;

    Widget card = feedMode
        ? _buildFeedCard(context, theme, isDark, timeString, linkedInitiative, accentColor, isMobile)
        : _buildCompactCard(context, theme, isDark, timeString, linkedInitiative, accentColor, isMobile);

    if (isOwner) {
      card = Badge(
        alignment: Alignment.topLeft,
        offset: const Offset(-2, 1),
        backgroundColor: Colors.transparent,
        label: GestureDetector(
          onTap: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final linkedId = linkedInitiative?.id;
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: 'Delete Action',
                content: 'Are you sure you want to delete this action?',
                confirmColor: Colors.redAccent,
              ),
            );
            if (confirm == true) {
              final actionNotifier = ref.read(activeActionProvider.notifier);
              final featuredInitiativesNotifier = ref.read(featuredInitiativeProvider.notifier);
              final activeInitiativesNotifier = ref.read(activeInitiativeProvider.notifier);
              try {
                await PhotosService().deleteAllSubmissionPhotos(action.id);
                await actionNotifier.deleteAction(action);
                await featuredInitiativesNotifier.refresh();
                await activeInitiativesNotifier.refresh();
                Future.microtask(() {
                  if (!context.mounted) return;
                  if (linkedId != null) {
                    onActionDeleted?.call(linkedId);
                    ref.invalidate(actionsByLinkedProvider((linkedId, 7)));
                  }
                  scaffoldMessenger.showSnackBar(CustomSnackBar.info('Action deleted!'));
                });
              } catch (e) {
                Future.microtask(() {
                  if (context.mounted) {
                    scaffoldMessenger.showSnackBar(CustomSnackBar.error('Error deleting action'));
                  }
                });
              }
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(Icons.delete, color: Colors.white, size: 12),
            ),
          ),
        ),
        child: card,
      );
    }
    return card;
  }

  // Feed card: left accent border via BoxDecoration — avoids IntrinsicHeight which
  // forces a double layout pass and causes scroll freezes on long lists.
  Widget _buildFeedCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String timeString,
    InitiativeSchema? linkedInitiative,
    Color accentColor,
    bool isMobile,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.black.withAlpha(100) : AppColors.black.withAlpha(22),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: accentColor, width: 4)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => safeGo(context, '/initiatives'),
              splashColor: accentColor.withAlpha(15),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: UserAvatar(
                            userId: action.userId,
                            showTooltip: true,
                            enableHero: true,
                            heroTagSuffix: action.id,
                            showProfileOnTap: true,
                            accentColorOverride: accentColor.withAlpha(160),
                            borderWidth: 1.5,
                            radius: isMobile ? 18.0 : 20.0,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                linkedInitiative?.title ?? _titleForAction(action),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              _buildTypeBadge(Icons.trending_up, 'Initiative', accentColor),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildFeedTimeChip(theme, isDark, timeString),
                      ],
                    ),
                    if (action.amount != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add, color: Colors.white, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  '${action.amount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'completed',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (action.imageUrls.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      PhotoThumbnailStrip(
                        urls: action.imageUrls,
                        onTap: (i) => PhotoViewerDialog.show(
                          context,
                          urls: action.imageUrls,
                          initialIndex: i,
                        ),
                        theme: theme,
                      ),
                    ],
                    const SizedBox(height: 10),
                    ActionLikeRow(action: action, isMobile: isMobile, iconColor: accentColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String timeString,
    InitiativeSchema? linkedInitiative,
    Color accentColor,
    bool isMobile,
  ) {
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final headerGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF1E3A8A).withAlpha(220), AppColors.lightBlue.withAlpha(180)]
          : [const Color(0xFF1E3A8A), AppColors.lightBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: expandToFullWidth ? (isMobile ? double.infinity : 180) : 180,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.black.withAlpha(110) : AppColors.black.withAlpha(40),
            blurRadius: 7,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => safeGo(context, '/initiatives'),
            borderRadius: BorderRadius.circular(14),
            splashColor: AppColors.lightBlue.withAlpha(30),
            highlightColor: AppColors.lightBlue.withAlpha(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 8 : 10, isMobile ? 9 : 11,
                    isMobile ? 8 : 10, isMobile ? 9 : 11,
                  ),
                  decoration: BoxDecoration(gradient: headerGradient),
                  child: Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: UserAvatar(
                          userId: action.userId,
                          showTooltip: true,
                          enableHero: true,
                          heroTagSuffix: action.id,
                          showProfileOnTap: true,
                          accentColorOverride: Colors.white.withAlpha(180),
                          borderWidth: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          linkedInitiative?.title ?? _titleForAction(action),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.25,
                            letterSpacing: -0.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 8 : 10, isMobile ? 7 : 9,
                    isMobile ? 8 : 10, isMobile ? 8 : 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tooltip(
                            message: 'Initiative Action',
                            child: Icon(Icons.trending_up, color: accentColor, size: isMobile ? 16 : 18),
                          ),
                          if (action.amount != null)
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
                                        Icon(Icons.add, color: AppColors.white, size: isMobile ? 10 : 11),
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
                          _buildCompactTimeChip(theme, isDark, timeString, isMobile),
                        ],
                      ),
                      if (action.imageUrls.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        PhotoThumbnailStrip(
                          urls: action.imageUrls,
                          onTap: (i) => PhotoViewerDialog.show(
                            context,
                            urls: action.imageUrls,
                            initialIndex: i,
                          ),
                          theme: theme,
                        ),
                      ],
                      ActionLikeRow(action: action, isMobile: isMobile, iconColor: accentColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}

Widget _buildTypeBadge(IconData icon, String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withAlpha(25),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFeedTimeChip(ThemeData theme, bool isDark, String timeString) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isDark ? AppColors.white.withAlpha(13) : AppColors.silver,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule_rounded, size: 12, color: theme.colorScheme.onSurface.withAlpha(120)),
        const SizedBox(width: 4),
        Text(
          timeString,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildCompactTimeChip(ThemeData theme, bool isDark, String timeString, bool isMobile) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: isDark ? AppColors.white.withAlpha(13) : AppColors.silver,
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
  );
}
