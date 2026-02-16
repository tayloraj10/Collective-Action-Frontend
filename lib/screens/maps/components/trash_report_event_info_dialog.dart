import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/map_events_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:collective_action_frontend/components/photo_thumbnail_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final size = MediaQuery.sizeOf(context);
    final maxH = (size.height * 0.7).clamp(200.0, 500.0);
    final maxW = (size.width * 0.95).clamp(280.0, 400.0);
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxW,
          maxHeight: maxH,
          minWidth: 280,
          minHeight: 200,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Trash Report',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Details',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (eventData?.location != null &&
                          eventData!.location.isNotEmpty)
                        _InfoRow(
                          label: 'Location',
                          value: eventData!.location,
                          icon: Icons.location_on_outlined,
                        ),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      _InfoRow(
                        label: 'Date',
                        value: _formatDate(action.date),
                        icon: Icons.calendar_today_outlined,
                      ),
                      if (_imageUrls(action, eventData).isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Image${_imageUrls(action, eventData).length > 1 ? 's' : ''}',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        PhotoThumbnailStrip(
                          urls: _imageUrls(action, eventData),
                          thumbSize: 48,
                          showArrows: false,
                          onTap: (index) {
                            PhotoViewerDialog.show(
                              context,
                              urls: _imageUrls(action, eventData),
                              initialIndex: index,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isOwner) ...[
                      TextButton.icon(
                        onPressed: () => _confirmAndDelete(context, ref, action, campaignId),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
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
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.info('Map submission deleted!'),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Error deleting map submission'),
        );
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _InfoRow({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: icon != null ? 90 : 100,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
