import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/components/photo_thumbnail_strip.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/map_events_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/maps/components/cleanup_event_dialog.dart';
import 'package:collective_action_frontend/services/actions_service.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_action_id_badge.dart';
import 'photo_viewer_dialog.dart';

/// Dialog to display trash report event information when a trash report pin is clicked.
/// If the current user owns this submission, shows a Delete button (removes action + photos).
class TrashReportEventInfoDialog extends ConsumerWidget {
  final ActionSchema action;
  final TrashReportEventData? eventData;

  /// Campaign id for invalidating map events after delete (so pin disappears).
  final String? campaignId;

  const TrashReportEventInfoDialog({
    super.key,
    required this.action,
    this.eventData,
    this.campaignId,
  });

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime d) {
    return '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';
  }

  /// Prefer event_data image_url, then action.imageUrls. Normalize so relative or quoted URLs load.
  static List<String> _imageUrls(
    ActionSchema action,
    TrashReportEventData? eventData,
  ) {
    final urls = <String>[];
    if (eventData?.imageUrl != null && eventData!.imageUrl!.isNotEmpty) {
      final u = PhotosService.normalizePhotoUrl(eventData.imageUrl!);
      if (u.isNotEmpty && !urls.contains(u)) urls.add(u);
    }
    if (action.imageUrls.isNotEmpty) {
      for (final url in action.imageUrls) {
        if (url.isEmpty) continue;
        final u = PhotosService.normalizePhotoUrl(url);
        if (u.isNotEmpty && !urls.contains(u)) urls.add(u);
      }
    }
    return urls;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isOwner = currentUser != null && currentUser.id == action.userId;
    final isResolved = action.resolvedAt != null;
    final size = MediaQuery.sizeOf(context);
    final maxH = (size.height * 0.7).clamp(200.0, 500.0);
    final maxW = (size.width * 0.95).clamp(280.0, 400.0);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = AppColors.warningOrange;
    final surfaceVariant = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerLow;
    final imageUrls = _imageUrls(action, eventData);

    return Dialog(
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxW,
          maxHeight: maxH,
          minWidth: 280,
          minHeight: 200,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Accent header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accentColor,
                        accentColor.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Trash Report',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      MapActionIdBadge(actionId: action.id),
                    ],
                  ),
                ),
                if (imageUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 18,
                              color: accentColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Photos',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        PhotoThumbnailStrip(
                          urls: imageUrls,
                          thumbSize: 52,
                          showArrows: false,
                          onTap: (index) {
                            PhotoViewerDialog.show(
                              context,
                              urls: imageUrls,
                              initialIndex: index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...() {
                          final cards = <Widget>[];

                          final hasLocation =
                              eventData?.location != null &&
                              eventData!.location.isNotEmpty;
                          if (hasLocation) {
                            cards.add(
                              _SectionCard(
                                surfaceVariant: surfaceVariant,
                                accentColor: accentColor,
                                icon: Icons.info_outline,
                                title: 'Details',
                                children: [
                                  _InfoRow(
                                    label: 'Location',
                                    value: eventData!.location,
                                    icon: Icons.location_on_outlined,
                                    accentColor: accentColor,
                                  ),
                                ],
                              ),
                            );
                          }

                          cards.add(
                            _SectionCard(
                              surfaceVariant: surfaceVariant,
                              accentColor: accentColor,
                              icon: Icons.calendar_today_outlined,
                              title: 'Date',
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    _formatDate(action.date),
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          );

                          return [
                            for (var i = 0; i < cards.length; i++) ...[
                              if (i > 0) const SizedBox(height: 8),
                              cards[i],
                            ],
                          ];
                        }(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isResolved)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.successGreen.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: AppColors.successGreen,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'This area was marked cleaned.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.successGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        FilledButton.icon(
                          onPressed: () => _claimCleaned(
                            context,
                            ref,
                            action,
                            eventData,
                            campaignId,
                          ),
                          icon: const Icon(Icons.cleaning_services, size: 20),
                          label: const Text(
                            'Mark as Cleaned',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.successGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            minimumSize: const Size(double.infinity, 48),
                            elevation: 2,
                            shadowColor: AppColors.successGreen.withValues(
                              alpha: 0.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isOwner) ...[
                            OutlinedButton.icon(
                              onPressed: () => _confirmAndDelete(
                                context,
                                ref,
                                action,
                                campaignId,
                              ),
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text('Delete'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.error,
                                side: BorderSide(
                                  color: theme.colorScheme.error,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          FilledButton(
                            onPressed: () => safePop(context),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            child: const Text('Close'),
                          ),
                        ],
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

  static Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    ActionSchema action, [
    String? campaignId,
  ]) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Delete Map Submission',
        content:
            'Are you sure you want to delete this trash report? This cannot be undone.',
        confirmColor: Colors.redAccent,
      ),
    );
    if (confirm != true) return;
    final actionNotifier = ref.read(activeActionProvider.notifier);
    try {
      await PhotosService().deleteAllSubmissionPhotos(action.id);
      await actionNotifier.deleteAction(action);
      if (context.mounted) {
        if (campaignId != null) {
          ref.invalidate(mapEventsForCampaignProvider(campaignId));
        }
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.info('Map submission deleted!'));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Error deleting map submission'));
      }
    }
  }

  static Future<void> _claimCleaned(
    BuildContext context,
    WidgetRef ref,
    ActionSchema action,
    TrashReportEventData? trashReportData, [
    String? campaignId,
  ]) async {
    final currentUser = ref.read(currentUserProvider).value;
    final userId = currentUser?.id;
    final lat = action.latitude?.toDouble();
    final lng = action.longitude?.toDouble();
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.error('This trash report is missing a location.'),
      );
      return;
    }

    final result = await showDialog<CleanupEventDialogResult>(
      context: context,
      builder: (dialogContext) => CleanupEventDialog(
        routeContext: dialogContext,
        position: LatLng(lat, lng),
        initialName: currentUser?.name,
        initialEventData: CleanupEventData(
          location: trashReportData?.location ?? '',
        ),
        organizerUserId: userId,
        enableScheduling: false,
        title: 'Mark Area Cleaned',
        submitLabel: 'Mark Cleaned',
      ),
    );
    if (result == null || !context.mounted) return;

    try {
      final actionsService = ActionsService();
      final created = await actionsService.claimTrashReportCleaned(
        trashReportId: action.id,
        userId: userId,
        eventData: ActionsService.cleanupEventDataToJson(result.eventData),
        latitude: lat,
        longitude: lng,
        date: DateTime.now(),
      );
      if (created != null && result.photos.isNotEmpty) {
        final uploaded = await PhotosService().uploadSubmissionPhotosBatch(
          created.id,
          result.photos,
        );
        if (uploaded != null && uploaded.isNotEmpty) {
          await actionsService.updateActionPhotos(created.id, uploaded);
        }
      }
      if (!context.mounted) return;
      if (campaignId != null) {
        ref.invalidate(mapEventsForCampaignProvider(campaignId));
        ref.invalidate(actionsByLinkedProvider((campaignId, null)));
        ref.invalidate(actionsByLinkedProvider((campaignId, 7)));
      }
      ref.read(activeActionProvider.notifier).refresh();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.success('Trash report marked cleaned.'));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Failed to mark cleaned: $e'));
      }
    }
  }
}

class _SectionCard extends StatelessWidget {
  final Color surfaceVariant;
  final Color accentColor;
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.surfaceVariant,
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (children.isNotEmpty) ...[const SizedBox(height: 10), ...children],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color accentColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.accentColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.62);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: accentColor),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
