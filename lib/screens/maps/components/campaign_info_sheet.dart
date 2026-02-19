import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/providers/map_events_provider.dart';
import 'package:collective_action_frontend/providers/map_zoom_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:collective_action_frontend/components/photo_thumbnail_strip.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'photo_viewer_dialog.dart';

/// Filter for the submissions list.
enum _SubmissionFilter { all, cleanups, trashReports }

/// Campaign info panel: campaign details + your submissions with
/// filter (All / Cleanups / Trash reports), view full event data, delete, and locate on map.
/// When [onClose] is provided, used as a persistent drawer (Locate does not close; Close calls onClose).
/// When [onClose] is null, used as a modal (Close and Locate both dismiss).
class CampaignInfoSheet extends ConsumerStatefulWidget {
  const CampaignInfoSheet({
    super.key,
    required this.campaigns,
    required this.scrollController,
    this.onClose,
  });

  final List<MapCampaignSchema> campaigns;
  final ScrollController scrollController;

  /// If set, panel is in "drawer" mode: Close calls this, Locate does not dismiss.
  final VoidCallback? onClose;

  @override
  ConsumerState<CampaignInfoSheet> createState() => _CampaignInfoSheetState();
}

class _CampaignInfoSheetState extends ConsumerState<CampaignInfoSheet> {
  _SubmissionFilter _filter = _SubmissionFilter.all;
  ActionSchema? _selectedAction;

  static const _monthNames = [
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

  static String _formatDate(DateTime d) {
    return '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';
  }

  static String _titleForAction(ActionSchema action) {
    final eventData = action.eventData;
    if (eventData == null || eventData.isEmpty) return 'Map Submission';
    final type = eventData['type']?.toString();
    if (type == EventDataType.cleanup.value) {
      final name = eventData['name']?.toString().trim();
      final location = eventData['location']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
      if (location != null && location.isNotEmpty) return location;
      return 'Cleanup';
    }
    if (type == EventDataType.trashReport.value) {
      final location = eventData['location']?.toString().trim();
      if (location != null && location.isNotEmpty) return location;
      return 'Trash Report';
    }
    return type ?? 'Map Submission';
  }

  static bool _isCleanup(ActionSchema a) =>
      a.eventData?['type']?.toString() == EventDataType.cleanup.value;
  static bool _isTrashReport(ActionSchema a) =>
      a.eventData?['type']?.toString() == EventDataType.trashReport.value;

  void _locateOnMap(ActionSchema action) {
    final lat = action.latitude;
    final lng = action.longitude;
    if (lat != null && lng != null) {
      ref
          .read(mapZoomToLocationProvider.notifier)
          .setLocation(LatLng(lat.toDouble(), lng.toDouble()));
    }
    if (widget.onClose == null) Navigator.of(context).pop();
  }

  Future<void> _deleteAction(ActionSchema action) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Delete Map Submission',
        content: 'Are you sure? This cannot be undone.',
        confirmColor: Colors.redAccent,
      ),
    );
    if (confirm != true) return;
    final notifier = ref.read(activeActionProvider.notifier);
    try {
      await PhotosService().deleteAllSubmissionPhotos(action.id);
      await notifier.deleteAction(action);
      if (mounted) {
        for (final c in widget.campaigns) {
          ref.invalidate(mapEventsForCampaignProvider(c.id));
        }
        setState(() => _selectedAction = null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.info('Map submission deleted.'));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.error('Error deleting.'));
      }
    }
  }

  List<ActionSchema> _filtered(List<ActionSchema> mine) {
    switch (_filter) {
      case _SubmissionFilter.cleanups:
        return mine.where(_isCleanup).toList();
      case _SubmissionFilter.trashReports:
        return mine.where(_isTrashReport).toList();
      case _SubmissionFilter.all:
        return mine;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final campaign = widget.campaigns.isNotEmpty
        ? widget.campaigns.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (campaign != null) ...[
                        Text(
                          campaign.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (campaign.description != null &&
                            campaign.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            campaign.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (widget.onClose != null) {
                      widget.onClose!();
                    } else {
                      safePop(context);
                    }
                  },
                  tooltip: 'Close',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: _selectedAction != null
                ? _buildDetailView(context, _selectedAction!)
                : _buildList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider).value;
    final actionsAsync = ref.watch(activeActionProvider);

    if (currentUser == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Sign in to see your submissions',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return actionsAsync.when(
      data: (all) {
        final mine =
            all
                .where(
                  (a) =>
                      a.actionType ==
                          ActionTypeValuesEnum.mapSubmission.value &&
                      a.userId == currentUser.id,
                )
                .toList()
              ..sort((a, b) => b.date.compareTo(a.date));
        final list = _filtered(mine);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: SegmentedButton<_SubmissionFilter>(
                segments: const [
                  ButtonSegment(
                    value: _SubmissionFilter.all,
                    label: Text('All'),
                    icon: Icon(Icons.list, size: 18),
                  ),
                  ButtonSegment(
                    value: _SubmissionFilter.cleanups,
                    label: Text('Cleanups'),
                    icon: Icon(Icons.cleaning_services, size: 18),
                  ),
                  ButtonSegment(
                    value: _SubmissionFilter.trashReports,
                    label: Text('Trash Reports'),
                    icon: Icon(Icons.delete_outline, size: 18),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (s) => setState(() => _filter = s.first),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ),
            if (list.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No submissions in this category.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final action = list[index];
                    final isCleanup = _isCleanup(action);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => setState(() => _selectedAction = action),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isCleanup
                                    ? Colors.green.shade100
                                    : Colors.orange.shade100,
                                child: Icon(
                                  isCleanup
                                      ? Icons.cleaning_services
                                      : Icons.delete_outline,
                                  color: isCleanup
                                      ? Colors.green.shade800
                                      : Colors.orange.shade800,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _titleForAction(action),
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDate(action.date),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.my_location),
                                tooltip: 'Locate on map',
                                onPressed: () => _locateOnMap(action),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error loading submissions',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, ActionSchema action) {
    final theme = Theme.of(context);
    final eventData = action.eventData ?? {};
    final type = eventData['type']?.toString();
    final isCleanup = type == EventDataType.cleanup.value;

    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedAction = null),
                tooltip: 'Back',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCleanup ? 'Cleanup details' : 'Trash report details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.my_location),
                tooltip: 'Locate on map',
                onPressed: () => _locateOnMap(action),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit (coming soon)',
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                tooltip: 'Delete',
                onPressed: () => _deleteAction(action),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            title: 'Details',
            icon: Icons.info_outline,
            children: [
              if (eventData['name'] != null &&
                  eventData['name'].toString().trim().isNotEmpty)
                _DetailRow(
                  label: 'Name',
                  value: eventData['name'].toString(),
                  icon: Icons.person_outline,
                ),
              if (eventData['location'] != null &&
                  eventData['location'].toString().trim().isNotEmpty)
                _DetailRow(
                  label: 'Location',
                  value: eventData['location'].toString(),
                  icon: Icons.location_on_outlined,
                ),
              _DetailRow(
                label: 'Date',
                value: _formatDate(action.date),
                icon: Icons.calendar_today_outlined,
              ),
            ],
          ),
          if (isCleanup &&
              (eventData['small_bags'] != null ||
                  eventData['large_bags'] != null ||
                  eventData['pounds'] != null)) ...[
            const SizedBox(height: 20),
            _DetailSection(
              title: 'Cleanup amounts',
              icon: Icons.inventory_2_outlined,
              children: [
                if (eventData['small_bags'] != null)
                  _DetailRow(
                    label: 'Small bags',
                    value: '${eventData['small_bags']}',
                    icon: Icons.shopping_bag_outlined,
                  ),
                if (eventData['large_bags'] != null)
                  _DetailRow(
                    label: 'Large bags',
                    value: '${eventData['large_bags']}',
                    icon: Icons.delete_outline,
                  ),
                if (eventData['pounds'] != null)
                  _DetailRow(
                    label: 'Pounds',
                    value: '${eventData['pounds']}',
                    icon: Icons.scale_outlined,
                  ),
              ],
            ),
          ],
          if (_imageUrls(action).isNotEmpty) ...[
            const SizedBox(height: 20),
            _DetailSection(
              title: 'Image${_imageUrls(action).length > 1 ? 's' : ''}',
              icon: Icons.image_outlined,
              children: [
                const SizedBox(height: 8),
                PhotoThumbnailStrip(
                  urls: _imageUrls(action),
                  thumbSize: 48,
                  showArrows: false,
                  onTap: (i) => PhotoViewerDialog.show(
                    context,
                    urls: _imageUrls(action),
                    initialIndex: i,
                  ),
                  theme: theme,
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static List<String> _imageUrls(ActionSchema action) {
    final urls = <String>[];
    final eventData = action.eventData;
    if (eventData != null) {
      final imageUrl = eventData['image_url'] ?? eventData['imageUrl'];
      if (imageUrl != null && imageUrl.toString().trim().isNotEmpty) {
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
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 10),
          ],
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
