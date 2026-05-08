import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/photo_thumbnail_strip.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:flutter/material.dart';

import 'photo_viewer_dialog.dart';

class PlantingEventInfoDialog extends StatelessWidget {
  const PlantingEventInfoDialog({super.key, required this.action});

  final ActionSchema action;

  dynamic _eventValue(String key) {
    final eventData = (action as dynamic).eventData;
    if (eventData is! Map) return null;
    try {
      return eventData[key];
    } catch (_) {
      return null;
    }
  }

  static List<String> _imageUrls(ActionSchema action) {
    final urls = <String>[];
    final eventData = (action as dynamic).eventData;
    if (eventData is Map) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const accentColor = AppColors.successGreen;
    final surfaceVariant = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerLow;
    final size = MediaQuery.sizeOf(context);
    final maxH = (size.height * 0.7).clamp(200.0, 500.0);
    final maxW = (size.width * 0.95).clamp(280.0, 400.0);
    final imageUrls = _imageUrls(action);

    final eventType = EventDataType.fromJson(_eventValue('type'));
    final location = _eventValue('location')?.toString() ?? '';
    final name = _eventValue('name')?.toString() ?? '';
    final species = _eventValue('species')?.toString() ?? '';
    final notes = _eventValue('notes')?.toString() ?? '';
    final quantity = '${_eventValue('quantity') ?? 1}';

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
                        child: Icon(
                          eventType == EventDataType.wildflowerPlanting
                              ? Icons.local_florist
                              : Icons.park,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        eventType == EventDataType.wildflowerPlanting
                            ? 'Wildflower Planting'
                            : 'Tree Planting',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
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
                            const Icon(
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DetailSectionCard(
                          surfaceVariant: surfaceVariant,
                          accentColor: accentColor,
                          icon: Icons.info_outline,
                          title: 'Details',
                          children: [
                            if (name.trim().isNotEmpty)
                              _DetailInfoRow(
                                label: 'Name',
                                value: name,
                                icon: Icons.person_outline,
                                accentColor: accentColor,
                              ),
                            if (location.trim().isNotEmpty)
                              _DetailInfoRow(
                                label: 'Location',
                                value: location,
                                icon: Icons.location_on_outlined,
                                accentColor: accentColor,
                              ),
                            if (species.trim().isNotEmpty)
                              _DetailInfoRow(
                                label: 'Species',
                                value: species,
                                icon: Icons.eco_outlined,
                                accentColor: accentColor,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _DetailSectionCard(
                          surfaceVariant: surfaceVariant,
                          accentColor: accentColor,
                          icon: Icons.format_list_numbered,
                          title: 'Planting amount',
                          children: [
                            _DetailInfoRow(
                              label: 'Quantity',
                              value: quantity,
                              icon: Icons.format_list_numbered,
                              accentColor: accentColor,
                            ),
                          ],
                        ),
                        if (notes.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _DetailSectionCard(
                            surfaceVariant: surfaceVariant,
                            accentColor: accentColor,
                            icon: Icons.notes_outlined,
                            title: 'Notes',
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  notes,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailSectionCard extends StatelessWidget {
  const _DetailSectionCard({
    required this.surfaceVariant,
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.children,
  });

  final Color surfaceVariant;
  final Color accentColor;
  final IconData icon;
  final String title;
  final List<Widget> children;

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

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({
    required this.label,
    required this.value,
    required this.accentColor,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color accentColor;

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
