import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DirectoryOfGoodEntryCard extends ConsumerWidget {
  final DirectoryOfGoodSchema entry;
  final bool isMobile;

  const DirectoryOfGoodEntryCard({
    super.key,
    required this.entry,
    this.isMobile = true,
  });

  static String _locationString(LocationSchema? loc) {
    if (loc == null) return '';
    final parts = <String>[
      if (loc.city != null && loc.city!.isNotEmpty) loc.city!,
      if (loc.state != null && loc.state!.isNotEmpty) loc.state!,
      if (loc.country != null && loc.country!.isNotEmpty) loc.country!,
    ];
    return parts.join(', ');
  }

  static String _normalizeUrl(String url) {
    final s = url.trim();
    if (s.isEmpty) return s;
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    return 'https://$s';
  }

  static bool _hasValue(String? s) => s != null && s.trim().isNotEmpty;

  /// Builds the URL to open for a social link (supports full URL or handle).
  static String _socialUrl(String platform, String value) {
    final t = value.trim();
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    switch (platform) {
      case 'youtube':
        return 'https://youtube.com/@$t';
      case 'instagram':
        return 'https://instagram.com/$t';
      case 'tiktok':
        return 'https://tiktok.com/@$t';
      case 'website':
      default:
        return _normalizeUrl(t);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardRadius = isMobile ? 16.0 : 20.0;
    final padding = isMobile ? 16.0 : 20.0;
    final locStr = _locationString(entry.location);
    final website = entry.socialLinks?.website?.trim();
    final hasWebsite = _hasValue(entry.socialLinks?.website);
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.white;
    final isFeatured = entry.featured;
    final accentColor = AppColors.warningOrange;
    final borderColor = isFeatured
        ? accentColor
        : (isDark
            ? AppColors.darkSurfaceVariant.withAlpha(80)
            : AppColors.silverDark.withAlpha(100));

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: borderColor,
            width: isFeatured ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColors.black.withAlpha(80)
                  : AppColors.black.withAlpha(18),
              blurRadius: isMobile ? 12 : 20,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: isDark
                  ? AppColors.black.withAlpha(40)
                  : AppColors.lightBlue.withAlpha(12),
              blurRadius: isMobile ? 6 : 10,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
            if (isFeatured)
              BoxShadow(
                color: accentColor.withAlpha(isDark ? 90 : 140),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: isMobile ? 72 : 80,
                  child: entry.imageUrl != null && entry.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            entry.imageUrl!,
                            width: isMobile ? 72 : 80,
                            height: isMobile ? 72 : 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _buildIcon(theme, isDark),
                          ),
                        )
                      : _buildIcon(theme, isDark),
                ),
                SizedBox(width: isMobile ? 16 : 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          fontSize: isMobile ? 16 : 18,
                          height: 1.3,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (entry.categoryId != null &&
                          entry.categoryId!.isNotEmpty) ...[
                        SizedBox(height: isMobile ? 6 : 8),
                        CategoryChip(
                          categoryId: entry.categoryId,
                          compact: true,
                        ),
                      ],
                      if (entry.focus != null && entry.focus!.isNotEmpty) ...[
                        SizedBox(height: isMobile ? 8 : 10),
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
                          child: Text(
                            entry.focus!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(
                                isDark ? 200 : 170,
                              ),
                              fontSize: isMobile ? 13 : 14,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                      if (hasWebsite) ...[
                        SizedBox(height: isMobile ? 10 : 12),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => AppConstants.openUrl(
                              _socialUrl('website', website),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.lightBlue.withAlpha(100),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.open_in_new_rounded,
                                    size: 14,
                                    color: AppColors.lightBlue,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      website!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppColors.lightBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (locStr.isNotEmpty) ...[
                        SizedBox(height: isMobile ? 10 : 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: theme.colorScheme.onSurface.withAlpha(
                                isDark ? 150 : 130,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                locStr,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    isDark ? 170 : 150,
                                  ),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                _buildSocialLinksRow(theme, isDark, vertical: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinksRow(
    ThemeData theme,
    bool isDark, {
    bool vertical = false,
  }) {
    final links = entry.socialLinks;
    if (links == null) return const SizedBox.shrink();

    final items = <Widget>[];
    final iconSize = vertical
        ? (isMobile ? 18.0 : 22.0)
        : (isMobile ? 18.0 : 20.0);
    final chipPadding = vertical ? (isMobile ? 8.0 : 10.0) : 12.0;

    if (_hasValue(links.youtube)) {
      const color = Color(0xFFFF0000);
      items.add(
        _SocialLinkChip(
          icon: FontAwesomeIcons.youtube,
          iconSize: iconSize,
          padding: chipPadding,
          url: _socialUrl('youtube', links.youtube!),
          tooltip: links.youtube!.trim(),
          backgroundColor: color.withAlpha(26),
          borderColor: color.withAlpha(130),
          iconColor: color,
        ),
      );
    }
    if (_hasValue(links.instagram)) {
      const color = Color(0xFFE1306C);
      items.add(
        _SocialLinkChip(
          icon: FontAwesomeIcons.instagram,
          iconSize: iconSize,
          padding: chipPadding,
          url: _socialUrl('instagram', links.instagram!),
          tooltip: links.instagram!.trim(),
          backgroundColor: color.withAlpha(26),
          borderColor: color.withAlpha(130),
          iconColor: color,
        ),
      );
    }
    if (_hasValue(links.tiktok)) {
      final color = Colors.black87;
      items.add(
        _SocialLinkChip(
          icon: FontAwesomeIcons.tiktok,
          iconSize: iconSize,
          padding: chipPadding,
          url: _socialUrl('tiktok', links.tiktok!),
          tooltip: links.tiktok!.trim(),
          backgroundColor: color.withAlpha(26),
          borderColor: color.withAlpha(130),
          iconColor: color,
        ),
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    if (vertical) {
      return Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              items[i],
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(spacing: 10, runSpacing: 10, children: items),
    );
  }

  Widget _buildIcon(ThemeData theme, bool isDark) {
    final size = isMobile ? 72.0 : 80.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightBlue.withAlpha(isDark ? 80 : 60),
            AppColors.primaryBlue.withAlpha(isDark ? 60 : 40),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: AppColors.lightBlue.withAlpha(isDark ? 220 : 255),
        size: isMobile ? 32 : 36,
      ),
    );
  }
}

class _SocialLinkChip extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double padding;
  final String url;
  final String tooltip;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  const _SocialLinkChip({
    required this.icon,
    required this.iconSize,
    this.padding = 12,
    required this.url,
    required this.tooltip,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => AppConstants.openUrl(url),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: FaIcon(icon, size: iconSize, color: iconColor),
          ),
        ),
      ),
    );
  }
}
