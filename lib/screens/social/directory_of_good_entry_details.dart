import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/components/directory_focus_text.dart';
import 'package:collective_action_frontend/providers/directory_of_good_provider.dart';
import 'package:collective_action_frontend/screens/maps/components/photo_viewer_dialog.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DirectoryOfGoodEntryPage extends ConsumerWidget {
  final String entryId;

  const DirectoryOfGoodEntryPage({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(directoryOfGoodEntryByIdProvider(entryId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: entryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Could not load Directory of Good entry',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          data: (entry) {
            if (entry == null) {
              return Center(
                child: Text(
                  'Directory of Good entry not found',
                  style: theme.textTheme.titleMedium,
                ),
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: DirectoryOfGoodEntryDetails(
                    entry: entry,
                    showCloseButton: false,
                    showOpenFullPageButton: false,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DirectoryOfGoodEntryDetails extends StatelessWidget {
  final DirectoryOfGoodSchema entry;
  final bool showCloseButton;
  final bool showOpenFullPageButton;

  const DirectoryOfGoodEntryDetails({
    super.key,
    required this.entry,
    this.showCloseButton = true,
    this.showOpenFullPageButton = true,
  });

  static void showEntryDialog(
    BuildContext context,
    DirectoryOfGoodSchema entry,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: DirectoryOfGoodEntryDetails(entry: entry),
          ),
        );
      },
    );
  }

  static bool _hasValue(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _normalizeUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://$trimmed';
  }

  static String _socialUrl(String platform, String value) {
    final trimmed = value.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    switch (platform) {
      case 'youtube':
        return 'https://youtube.com/@$trimmed';
      case 'instagram':
        return 'https://instagram.com/$trimmed';
      case 'tiktok':
        return 'https://tiktok.com/@$trimmed';
      case 'website':
      default:
        return _normalizeUrl(trimmed);
    }
  }

  static String _locationString(LocationSchema? loc) {
    if (loc == null) return '';
    return [
      loc.city,
      loc.state,
      loc.country,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).join(', ');
  }

  static String _dateString(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    return '${local.month}/${local.day}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = AppConstants.isMobile(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = AppColors.warningOrange;
    final location = _locationString(entry.location);
    final imageUrl = entry.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final createdAt = _dateString(entry.createdAt);
    final updatedAt = _dateString(entry.updatedAt);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        color: isDark ? AppColors.darkSurface : theme.colorScheme.surface,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroImage(context, hasImage ? imageUrl : null),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildTypeChip(context),
                              if (entry.featured)
                                _buildFeaturedChip(context, accentColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (showCloseButton)
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                  ],
                ),
                if (showOpenFullPageButton && _hasValue(entry.id)) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        safeGo(context, '/social/directory/${entry.id}');
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text('Open full page'),
                    ),
                  ),
                ],
                if (entry.categoryIds.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.categoryIds
                        .map(
                          (id) => CategoryChip(categoryId: id, compact: true),
                        )
                        .toList(),
                  ),
                ],
                if (_hasValue(entry.focus)) ...[
                  const SizedBox(height: 22),
                  _buildSectionTitle(context, 'Focus'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: AppColors.lightBlue.withAlpha(180),
                          width: 3,
                        ),
                      ),
                    ),
                    child: DirectoryFocusText(
                      text: entry.focus!,
                      isMobile: isMobile,
                      compact: false,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(
                          isDark ? 210 : 185,
                        ),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  _buildSectionTitle(context, 'Location'),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    icon: Icons.location_on_outlined,
                    label: location,
                  ),
                ],
                if (_socialButtons(context).isNotEmpty) ...[
                  const SizedBox(height: 22),
                  _buildSectionTitle(context, 'Links'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _socialButtons(context),
                  ),
                ],
                if (createdAt.isNotEmpty || updatedAt.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Divider(color: theme.dividerColor.withAlpha(120)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (createdAt.isNotEmpty)
                        _buildMetadataChip(context, 'Added $createdAt'),
                      if (updatedAt.isNotEmpty)
                        _buildMetadataChip(context, 'Updated $updatedAt'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, String? imageUrl) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const size = 72.0;

    Widget fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withAlpha(isDark ? 70 : 45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: AppColors.warningOrange,
        size: 34,
      ),
    );

    if (imageUrl == null) return fallback;

    return GestureDetector(
      onTap: () => PhotoViewerDialog.show(context, urls: [imageUrl]),
      child: MouseRegion(
        cursor: SystemMouseCursors.zoomIn,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ExternalOrDataImage(
            key: ValueKey(
              'dog-detail-img-${entry.id ?? entry.name}-${imageUrl.hashCode}',
            ),
            url: imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withAlpha(28),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.warningOrange.withAlpha(120)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 14,
            color: AppColors.warningOrange,
          ),
          const SizedBox(width: 6),
          Text(
            'Directory of Good',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.warningOrange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedChip(BuildContext context, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Featured',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurface.withAlpha(135)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(190),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _socialButtons(BuildContext context) {
    final links = entry.socialLinks;
    if (links == null) return [];

    final buttons = <Widget>[];
    if (_hasValue(links.website)) {
      buttons.add(
        _LinkButton(
          label: 'Website',
          value: links.website!.trim(),
          url: _socialUrl('website', links.website!),
          icon: Icons.language_rounded,
          color: AppColors.lightBlue,
        ),
      );
    }
    if (_hasValue(links.youtube)) {
      buttons.add(
        _LinkButton(
          label: 'YouTube',
          value: links.youtube!.trim(),
          url: _socialUrl('youtube', links.youtube!),
          iconWidget: const FaIcon(
            FontAwesomeIcons.youtube,
            size: 16,
            color: Color(0xFFFF0000),
          ),
          color: const Color(0xFFFF0000),
        ),
      );
    }
    if (_hasValue(links.instagram)) {
      buttons.add(
        _LinkButton(
          label: 'Instagram',
          value: links.instagram!.trim(),
          url: _socialUrl('instagram', links.instagram!),
          iconWidget: const FaIcon(
            FontAwesomeIcons.instagram,
            size: 16,
            color: Color(0xFFE1306C),
          ),
          color: const Color(0xFFE1306C),
        ),
      );
    }
    if (_hasValue(links.tiktok)) {
      final color = Theme.of(context).colorScheme.onSurface.withAlpha(210);
      buttons.add(
        _LinkButton(
          label: 'TikTok',
          value: links.tiktok!.trim(),
          url: _socialUrl('tiktok', links.tiktok!),
          iconWidget: FaIcon(FontAwesomeIcons.tiktok, size: 16, color: color),
          color: color,
        ),
      );
    }

    return buttons;
  }

  Widget _buildMetadataChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(45)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(150),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final String value;
  final String url;
  final IconData? icon;
  final Widget? iconWidget;
  final Color color;

  const _LinkButton({
    required this.label,
    required this.value,
    required this.url,
    required this.color,
    this.icon,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => AppConstants.openUrl(url),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 250),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withAlpha(24),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(120)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget ?? Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.open_in_new_rounded, size: 14, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
