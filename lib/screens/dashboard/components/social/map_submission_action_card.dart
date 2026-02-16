import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_event_info_dialog.dart';
import 'package:collective_action_frontend/components/photo_thumbnail_strip.dart';
import 'package:collective_action_frontend/screens/maps/components/photo_viewer_dialog.dart';
import 'package:collective_action_frontend/screens/maps/components/trash_report_event_info_dialog.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Card for Map Submission actions (cleanup, trash report, route) in the social feed.
class MapSubmissionActionCard extends ConsumerWidget {
  final ActionSchema action;

  /// When true (default), the card expands to full width on mobile.
  final bool expandToFullWidth;

  const MapSubmissionActionCard({
    super.key,
    required this.action,
    this.expandToFullWidth = true,
  });

  static String _titleFromEventData(ActionSchema action) {
    final eventType = action.eventData?['type'];
    if (eventType == null) return 'Map Submission';
    final s = eventType.toString();
    if (s == EventDataType.cleanup.value) return 'Cleanup';
    if (s == EventDataType.trashReport.value) return 'Trash Report';
    if (s == EventDataType.cleanupRoute.value) return 'Cleanup Route';
    if (s == EventDataType.zipCodeSubmission.value) return 'Zip Code';
    return s;
  }

  static List<String> _imageUrls(ActionSchema action) {
    final urls = <String>[];
    final eventData = action.eventData;
    if (eventData != null) {
      final imageUrl = eventData['image_url'];
      if (imageUrl != null && imageUrl.toString().isNotEmpty) {
        final u = PhotosService.normalizePhotoUrl(imageUrl.toString());
        if (u.isNotEmpty && !urls.contains(u)) urls.add(u);
      }
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

  Future<void> _showInfoDialog(BuildContext context) async {
    final eventData = action.eventData;
    if (eventData == null) return;
    final eventDataMap = Map<String, dynamic>.from(eventData);
    final eventType = EventDataType.fromJson(eventDataMap['type']);

    if (eventType == EventDataType.cleanup) {
      final data = CleanupEventData(
        type: eventType ?? EventDataType.cleanup,
        name: eventDataMap['name'] as String? ?? '',
        location: eventDataMap['location'] as String? ?? '',
        smallBags: eventDataMap['small_bags'] as int?,
        largeBags: eventDataMap['large_bags'] as int?,
        pounds: eventDataMap['pounds'] != null
            ? num.parse('${eventDataMap['pounds']}')
            : null,
        imageUrl: eventDataMap['image_url'] as String?,
      );
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (c) =>
              CleanupEventInfoDialog(action: action, eventData: data),
        );
      }
    } else if (eventType == EventDataType.trashReport) {
      final data = TrashReportEventData(
        type: eventType ?? EventDataType.trashReport,
        location: eventDataMap['location'] as String? ?? '',
        imageUrl: eventDataMap['image_url'] as String?,
      );
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (c) =>
              TrashReportEventInfoDialog(action: action, eventData: data),
        );
      }
    }
    // Cleanup Route / Zip Code: no detail dialog for now
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
    final imageUrls = _imageUrls(action);

    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final accentColor = AppColors.successGreen;
    final subtleAccent = AppColors.successGreen.withAlpha(isDark ? 150 : 255);

    final canShowInfoDialog =
        action.eventData != null &&
        (EventDataType.fromJson(action.eventData!['type']) ==
                EventDataType.cleanup ||
            EventDataType.fromJson(action.eventData!['type']) ==
                EventDataType.trashReport);

    Widget card = Container(
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
                  padding: EdgeInsets.all(isMobile ? 8 : 10),
                  color: subtleAccent,
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
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
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
                            message: 'Map Submission',
                            child: Icon(
                              Icons.map_outlined,
                              color: accentColor,
                              size: isMobile ? 16 : 18,
                            ),
                          ),
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
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    128,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  timeString,
                                  style: theme.textTheme.bodySmall?.copyWith(
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
                        ],
                      ),
                      if (imageUrls.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        PhotoThumbnailStrip(
                          urls: imageUrls,
                          onTap: (index) => PhotoViewerDialog.show(
                            context,
                            urls: imageUrls,
                            initialIndex: index,
                          ),
                          theme: theme,
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
    );

    if (isOwner) {
      card = Badge(
        alignment: Alignment.topLeft,
        offset: const Offset(-5, 1),
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
}
