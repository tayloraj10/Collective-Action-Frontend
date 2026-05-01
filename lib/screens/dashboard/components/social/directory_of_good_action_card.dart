import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/directory_focus_text.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/action_like_row.dart';
import 'package:collective_action_frontend/utils/external_network_image.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Compact card for "Directory of Good Addition" actions in the dashboard social feed.
class DirectoryOfGoodActionCard extends ConsumerWidget {
  final ActionSchema action;
  final DirectoryOfGoodSchema? entry;

  /// When true (default), the card expands to full width on mobile.
  final bool expandToFullWidth;

  const DirectoryOfGoodActionCard({
    super.key,
    required this.action,
    this.entry,
    this.expandToFullWidth = true,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = AppConstants.isMobile(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timeString = _formatTimeAgo(action.date);
    final title = entry?.name ?? 'Directory of Good';
    final focus = entry?.focus;
    final isFeatured = entry?.featured == true;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final accentColor = AppColors.warningOrange;
    final headerGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF7C2D12).withAlpha(220), AppColors.warningOrange.withAlpha(180)]
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
            onTap: () => safeGo(context, '/social'),
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
    const size = 40.0;
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
