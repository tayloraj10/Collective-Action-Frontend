import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/directory_focus_text.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/action_like_row.dart';
import 'package:collective_action_frontend/screens/social/directory_of_good_entry_details.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DirectoryOfGoodActionCard extends ConsumerWidget {
  final ActionSchema action;
  final DirectoryOfGoodSchema? entry;
  final bool expandToFullWidth;

  /// Full-width timeline layout for the /social page feed.
  /// When false (default), uses the compact grid card for the dashboard.
  final bool feedMode;

  const DirectoryOfGoodActionCard({
    super.key,
    required this.action,
    this.entry,
    this.expandToFullWidth = true,
    this.feedMode = false,
  });

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

  void _openEntry(BuildContext context) {
    final entry = this.entry;
    if (entry == null) {
      safeGo(context, '/social');
      return;
    }
    DirectoryOfGoodEntryDetails.showEntryDialog(context, entry);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = AppConstants.isMobile(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timeString = _formatTimeAgo(action.date);
    const accentColor = AppColors.warningOrange;

    if (feedMode) {
      return _buildFeedCard(
        context,
        theme,
        isDark,
        timeString,
        accentColor,
        isMobile,
      );
    }
    return _buildCompactCard(
      context,
      theme,
      isDark,
      timeString,
      accentColor,
      isMobile,
    );
  }

  // Feed card: left accent border via BoxDecoration — avoids IntrinsicHeight which
  // forces a double layout pass and causes scroll freezes on long lists.
  Widget _buildFeedCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String timeString,
    Color accentColor,
    bool isMobile,
  ) {
    final title = entry?.name ?? 'Directory of Good';
    final focus = entry?.focus;
    final isFeatured = entry?.featured == true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isFeatured
            ? Border.all(color: accentColor.withAlpha(160), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.black.withAlpha(100)
                : AppColors.black.withAlpha(22),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
          if (isFeatured)
            BoxShadow(
              color: accentColor.withAlpha(isDark ? 80 : 100),
              blurRadius: 12,
              spreadRadius: 0,
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
              onTap: () => _openEntry(context),
              splashColor: accentColor.withAlpha(15),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEntryThumbnail(
                          context,
                          action.id,
                          entry?.imageUrl,
                          accentColor,
                          isDark,
                          isMobile,
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
                              _buildTypeBadge(
                                Icons.menu_book_rounded,
                                'Directory of Good',
                                accentColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildFeedTimeChip(theme, isDark, timeString),
                      ],
                    ),
                    if (focus != null && focus.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      DirectoryFocusText(
                        text: focus,
                        isMobile: isMobile,
                        compact: false,
                        truncateOnDesktop: true,
                        maxLinesCollapsed: 3,
                        minCharsForExpand: 100,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(170),
                          fontSize: 13,
                          height: 1.4,
                        ),
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
    Color accentColor,
    bool isMobile,
  ) {
    final title = entry?.name ?? 'Directory of Good';
    final focus = entry?.focus;
    final isFeatured = entry?.featured == true;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final headerGradient = LinearGradient(
      colors: isDark
          ? [
              const Color(0xFF7C2D12).withAlpha(220),
              AppColors.warningOrange.withAlpha(180),
            ]
          : [const Color(0xFF7C2D12), AppColors.warningOrange],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );

    return Container(
      width: expandToFullWidth ? (isMobile ? double.infinity : 180) : 180,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: isFeatured ? Border.all(color: accentColor, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.black.withAlpha(110)
                : AppColors.black.withAlpha(40),
            blurRadius: 7,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openEntry(context),
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
                      _buildEntryThumbnail(
                        context,
                        action.id,
                        entry?.imageUrl,
                        accentColor,
                        isDark,
                        isMobile,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Directory of Good',
                              style: TextStyle(
                                color: Colors.white.withAlpha(200),
                                fontSize: isMobile ? 9 : 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.2,
                                letterSpacing: -0.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                          Icon(
                            Icons.menu_book_rounded,
                            color: accentColor,
                            size: isMobile ? 16 : 18,
                          ),
                          _buildCompactTimeChip(
                            theme,
                            isDark,
                            timeString,
                            isMobile,
                          ),
                        ],
                      ),
                      if (focus != null && focus.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        DirectoryFocusText(
                          text: focus,
                          isMobile: isMobile,
                          compact: true,
                          truncateOnDesktop: true,
                          maxLinesCollapsed: 2,
                          minCharsForExpand: 80,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(153),
                            fontSize: isMobile ? 10 : 11,
                            height: 1.3,
                          ),
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

  Widget _buildEntryThumbnail(
    BuildContext context,
    String actionId,
    String? imageUrl,
    Color accentColor,
    bool isDark,
    bool isMobile,
  ) {
    const size = 42.0;
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;
    Widget content;
    if (hasImage) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExternalOrDataImage(
          key: ValueKey<String>('dog-thumb-$actionId-${imageUrl.hashCode}'),
          url: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              _placeholderIcon(theme, accentColor, isDark, size),
        ),
      );
    } else {
      content = _placeholderIcon(theme, accentColor, isDark, size);
    }
    return SizedBox(width: size, height: size, child: content);
  }

  Widget _placeholderIcon(
    ThemeData theme,
    Color accentColor,
    bool isDark,
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accentColor.withAlpha(isDark ? 80 : 60),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: accentColor.withAlpha(isDark ? 220 : 255),
        size: size * 0.55,
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
