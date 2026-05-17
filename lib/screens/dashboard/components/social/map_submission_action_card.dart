import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/action_like_row.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_event_info_dialog.dart';
import 'package:collective_action_frontend/components/photo_thumbnail_strip.dart';
import 'package:collective_action_frontend/screens/maps/components/photo_viewer_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/planting_event_info_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/trash_report_event_info_dialog.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapSubmissionActionCard extends ConsumerWidget {
  final ActionSchema action;
  final bool expandToFullWidth;

  /// Full-width timeline layout for the /social page feed.
  /// When false (default), uses the compact grid card for the dashboard.
  final bool feedMode;

  const MapSubmissionActionCard({
    super.key,
    required this.action,
    this.expandToFullWidth = true,
    this.feedMode = false,
  });

  static dynamic _eventValue(ActionSchema action, String key) {
    final rawEventData = (action as dynamic).eventData;
    if (rawEventData is! Map) return null;
    try {
      return rawEventData[key];
    } catch (_) {
      return null;
    }
  }

  static bool _isResolvedTrashReport(ActionSchema action) {
    final eventType = EventDataType.fromJson(_eventValue(action, 'type'));
    return eventType == EventDataType.trashReport && action.resolvedAt != null;
  }

  static String _titleFromEventData(ActionSchema action) {
    final eventType = _eventValue(action, 'type');
    if (eventType == null) return 'Map Submission';
    final s = eventType.toString();
    if (s == EventDataType.cleanup.value) return 'Cleanup';
    if (s == EventDataType.trashReport.value) return 'Trash Report';
    if (s == EventDataType.cleanupRoute.value) return 'Cleanup Route';
    if (s == EventDataType.zipCodeSubmission.value) return 'Zip Code';
    if (s == EventDataType.treePlanting.value) return 'Tree Planting';
    if (s == EventDataType.wildflowerPlanting.value) {
      return 'Wildflower Planting';
    }
    return s;
  }

  static List<String> _imageUrls(ActionSchema action) {
    final urls = <String>[];
    final imageUrl = _eventValue(action, 'image_url');
    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      final u = PhotosService.normalizePhotoUrl(imageUrl.toString());
      if (u.isNotEmpty && !urls.contains(u)) urls.add(u);
    }
    for (final url in action.imageUrls) {
      if (url.isEmpty) continue;
      final u = PhotosService.normalizePhotoUrl(url);
      if (u.isNotEmpty && !urls.contains(u)) urls.add(u);
    }
    return urls;
  }

  static String _formatTimeAgo(DateTime date) {
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

  static List<(IconData, String, String)> _eventStatsFromAction(
    ActionSchema action,
  ) {
    final parts = <(IconData, String, String)>[];
    final smallBags = _eventValue(action, 'small_bags');
    if (smallBags != null) {
      final n = smallBags is int ? smallBags : int.tryParse('$smallBags');
      if (n != null && n > 0) {
        parts.add((
          Icons.shopping_bag_outlined,
          '$n',
          '$n small bag${n == 1 ? '' : 's'} (about a shopping bag)',
        ));
      }
    }
    final largeBags = _eventValue(action, 'large_bags');
    if (largeBags != null) {
      final n = largeBags is int ? largeBags : int.tryParse('$largeBags');
      if (n != null && n > 0) {
        parts.add((
          Icons.delete_outline,
          '$n',
          '$n large bag${n == 1 ? '' : 's'} (about a garbage bag)',
        ));
      }
    }
    final pounds = _eventValue(action, 'pounds');
    if (pounds != null) {
      final n = pounds is num ? pounds : num.tryParse('$pounds');
      if (n != null && n > 0) {
        final s = n == n.toInt() ? '${n.toInt()}' : '$n';
        parts.add((Icons.scale_outlined, s, '$s lb${n == 1 ? '' : 's'}'));
      }
    }
    final type = _eventValue(action, 'type')?.toString();
    if (type == EventDataType.treePlanting.value ||
        type == EventDataType.wildflowerPlanting.value) {
      final rawQuantity = _eventValue(action, 'quantity');
      final quantity = rawQuantity is int
          ? rawQuantity
          : int.tryParse('${rawQuantity ?? 1}') ?? 1;
      parts.add((
        type == EventDataType.treePlanting.value
            ? Icons.park
            : Icons.local_florist,
        '$quantity',
        '$quantity planting${quantity == 1 ? '' : 's'}',
      ));
    }
    return parts;
  }

  Future<void> _showInfoDialog(BuildContext context) async {
    final eventType = EventDataType.fromJson(_eventValue(action, 'type'));
    if (eventType == null) return;

    if (eventType == EventDataType.cleanup) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (c) => CleanupEventInfoDialog(
            action: action,
            eventData: CleanupEventInfoDialog.eventDataFromAction(action),
            campaignId: action.linkedId,
          ),
        );
      }
    } else if (eventType == EventDataType.trashReport) {
      final data = TrashReportEventData(
        type: eventType,
        location: _eventValue(action, 'location')?.toString() ?? '',
        imageUrl: _eventValue(action, 'image_url')?.toString(),
      );
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (c) =>
              TrashReportEventInfoDialog(action: action, eventData: data),
        );
      }
    } else if (eventType == EventDataType.treePlanting ||
        eventType == EventDataType.wildflowerPlanting) {
      await _showPlantingInfoDialog(context);
    }
  }

  Future<void> _showPlantingInfoDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => PlantingEventInfoDialog(action: action),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isOwner = currentUser != null && currentUser.id == action.userId;
    final isMobile = AppConstants.isMobile(context);
    final timeString = _formatTimeAgo(action.date);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final title = _titleFromEventData(action);
    final isResolvedTrash = _isResolvedTrashReport(action);
    final imageUrls = _imageUrls(action);
    final eventStats = _eventStatsFromAction(action);
    final accentColor = isResolvedTrash
        ? AppColors.warningOrange
        : AppColors.successGreen;

    final canShowInfoDialog =
        (EventDataType.fromJson(_eventValue(action, 'type')) ==
                EventDataType.cleanup ||
            EventDataType.fromJson(_eventValue(action, 'type')) ==
                EventDataType.trashReport ||
            EventDataType.fromJson(_eventValue(action, 'type')) ==
                EventDataType.treePlanting ||
            EventDataType.fromJson(_eventValue(action, 'type')) ==
                EventDataType.wildflowerPlanting);

    Widget card = feedMode
        ? _buildFeedCard(
            context,
            theme,
            isDark,
            timeString,
            title,
            imageUrls,
            eventStats,
            accentColor,
            isMobile,
            canShowInfoDialog,
            isResolvedTrash,
          )
        : _buildCompactCard(
            context,
            theme,
            isDark,
            timeString,
            title,
            imageUrls,
            eventStats,
            accentColor,
            isMobile,
            canShowInfoDialog,
            isResolvedTrash,
          );

    if (isOwner) {
      card = Badge(
        alignment: Alignment.topLeft,
        offset: const Offset(-2, 1),
        backgroundColor: Colors.transparent,
        label: GestureDetector(
          onTap: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: 'Delete Map Submission',
                content: 'Are you sure you want to delete this map submission?',
                confirmColor: Colors.redAccent,
              ),
            );
            if (confirm == true) {
              final actionNotifier = ref.read(activeActionProvider.notifier);
              try {
                await PhotosService().deleteAllSubmissionPhotos(action.id);
                await actionNotifier.deleteAction(action);
                if (context.mounted) {
                  scaffoldMessenger.showSnackBar(
                    CustomSnackBar.info('Map submission deleted!'),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  scaffoldMessenger.showSnackBar(
                    CustomSnackBar.error('Error deleting map submission'),
                  );
                }
              }
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
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
    String title,
    List<String> imageUrls,
    List<(IconData, String, String)> eventStats,
    Color accentColor,
    bool isMobile,
    bool canShowInfoDialog,
    bool isResolvedTrash,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.black.withAlpha(100)
                : AppColors.black.withAlpha(22),
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
              onTap: canShowInfoDialog ? () => _showInfoDialog(context) : null,
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
                          cursor: canShowInfoDialog
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
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
                                title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  _buildTypeBadge(
                                    Icons.map_outlined,
                                    'Map Submission',
                                    accentColor,
                                  ),
                                  if (isResolvedTrash)
                                    _buildTypeBadge(
                                      Icons.check_circle_outline,
                                      'Cleaned',
                                      AppColors.successGreen,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildFeedTimeChip(theme, isDark, timeString),
                      ],
                    ),
                    if (eventStats.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          for (final stat in eventStats)
                            Tooltip(
                              message: stat.$3,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(stat.$1, size: 16, color: accentColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    stat.$2,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(200),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (imageUrls.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      PhotoThumbnailStrip(
                        urls: imageUrls,
                        onTap: (i) => PhotoViewerDialog.show(
                          context,
                          urls: imageUrls,
                          initialIndex: i,
                        ),
                        theme: theme,
                      ),
                    ],
                    const SizedBox(height: 10),
                    ActionLikeRow(
                      action: action,
                      isMobile: isMobile,
                      iconColor: accentColor,
                    ),
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
    String title,
    List<String> imageUrls,
    List<(IconData, String, String)> eventStats,
    Color accentColor,
    bool isMobile,
    bool canShowInfoDialog,
    bool isResolvedTrash,
  ) {
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final headerGradient = LinearGradient(
      colors: isDark
          ? [
              const Color(0xFF14532D).withAlpha(220),
              AppColors.successGreen.withAlpha(180),
            ]
          : [const Color(0xFF14532D), AppColors.successGreen],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Container(
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canShowInfoDialog ? () => _showInfoDialog(context) : null,
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 8 : 10,
                    isMobile ? 9 : 11,
                    isMobile ? 8 : 10,
                    isMobile ? 9 : 11,
                  ),
                  decoration: BoxDecoration(gradient: headerGradient),
                  child: Row(
                    children: [
                      MouseRegion(
                        cursor: canShowInfoDialog
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic,
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
                          title,
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message: 'Map Submission',
                                child: Icon(
                                  Icons.map_outlined,
                                  color: accentColor,
                                  size: isMobile ? 16 : 18,
                                ),
                              ),
                              if (isResolvedTrash) ...[
                                const SizedBox(width: 6),
                                Tooltip(
                                  message: 'Marked cleaned',
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    color: AppColors.successGreen,
                                    size: isMobile ? 16 : 18,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          _buildCompactTimeChip(
                            theme,
                            isDark,
                            timeString,
                            isMobile,
                          ),
                        ],
                      ),
                      if (eventStats.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (final stat in eventStats) ...[
                              if (stat != eventStats.first)
                                SizedBox(width: isMobile ? 8 : 10),
                              Tooltip(
                                message: stat.$3,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      stat.$1,
                                      size: isMobile ? 14 : 16,
                                      color: accentColor,
                                    ),
                                    SizedBox(width: isMobile ? 2 : 3),
                                    Text(
                                      stat.$2,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withAlpha(200),
                                            fontSize: isMobile ? 10 : 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      if (imageUrls.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        PhotoThumbnailStrip(
                          urls: imageUrls,
                          onTap: (i) => PhotoViewerDialog.show(
                            context,
                            urls: imageUrls,
                            initialIndex: i,
                          ),
                          theme: theme,
                        ),
                      ],
                      ActionLikeRow(
                        action: action,
                        isMobile: isMobile,
                        iconColor: accentColor,
                      ),
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
        Icon(
          Icons.schedule_rounded,
          size: 12,
          color: theme.colorScheme.onSurface.withAlpha(120),
        ),
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

Widget _buildCompactTimeChip(
  ThemeData theme,
  bool isDark,
  String timeString,
  bool isMobile,
) {
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
