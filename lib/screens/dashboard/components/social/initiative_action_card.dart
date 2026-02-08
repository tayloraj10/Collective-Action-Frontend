import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:flutter/material.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:collective_action_frontend/components/confirmation_dialog.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/services/photos_service.dart';

class InitiativeActionCard extends ConsumerWidget {
  final ActionSchema action;
  final InitiativeSchema? initiative;

  /// When true (default), the card expands to full width on mobile.
  /// When false, the card uses its intrinsic width (important for
  /// horizontally scrolling lists to avoid infinite width constraints).
  final bool expandToFullWidth;

  /// Called after an action is successfully deleted, with the linked initiative id.
  /// Use this to invalidate linked-action lists (e.g. [actionsByLinkedProvider])
  /// from a parent that stays mounted (e.g. initiative list screen).
  final void Function(String initiativeId)? onActionDeleted;

  const InitiativeActionCard({
    super.key,
    required this.action,
    this.initiative,
    this.expandToFullWidth = true,
    this.onActionDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isOwner = currentUser != null && currentUser.id == action.userId;
    final isMobile = AppConstants.isMobile(context);
    final date = action.date;
    final timeString = _formatTimeAgo(date);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use AppColors from theme.dart
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final accentColor = AppColors.lightBlue;
    final subtleAccent = AppColors.lightBlue.withAlpha(isDark ? 150 : 255);

    InitiativeSchema? linkedInitiative = initiative;

    // When expandToFullWidth is false (e.g. horizontal list), always use finite width
    // so the card gets bounded width and Row/Expanded inside don't get unbounded constraints.
    Widget card = Container(
      width: expandToFullWidth ? (isMobile ? double.infinity : 180) : 180,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        // border: Border.all(color: AppColors.darkBackground, width: .75),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header section with gradient
            Container(
              padding: EdgeInsets.all(isMobile ? 8 : 10),
              color: subtleAccent,
              child: Row(
                children: [
                  // User avatar
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: UserAvatar(
                      userId: action.userId,
                      showTooltip: true,
                      enableHero: true,
                      heroTagSuffix:
                          action.id, // Use action ID to make hero tag unique
                      showProfileOnTap: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  Expanded(
                    child: Text(
                      linkedInitiative?.title ?? _titleForAction(action),
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

            // Content section
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
                        message: 'Initiative Action',
                        child: Icon(
                          Icons.trending_up,
                          color: accentColor,
                          size: isMobile ? 16 : 18,
                        ),
                      ),
                      // Amount badge (if exists)
                      if (action.amount != null) ...[
                        Tooltip(
                          message: 'Amount Completed',
                          child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withAlpha(40),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppColors.white,
                                      size: isMobile ? 10 : 11,
                                    ),
                                    Text(
                                      '${action.amount}',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: isMobile ? 10 : 11,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      // Time indicator
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
                              color: theme.colorScheme.onSurface.withAlpha(128),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeString,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  153,
                                ),
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
                  // Photo carousel (when action has imageUrls)
                  if (action.imageUrls.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _PhotoCarousel(
                      urls: action.imageUrls,
                      onTap: (index) => _showPhotoViewer(
                        context,
                        urls: action.imageUrls,
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
    );

    if (isOwner) {
      card = Badge(
        alignment: Alignment.topLeft,
        offset: Offset(-5, 1),
        backgroundColor: Colors.transparent,
        label: GestureDetector(
          onTap: () async {
            // Capture before any async work so we can safely invalidate after delete
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final linkedId = linkedInitiative?.id;

            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => ConfirmationDialog(
                title: 'Delete Action',
                content: 'Are you sure you want to delete this action?',
                confirmColor: Colors.redAccent,
              ),
            );
            if (confirm == true) {
              // Capture references upfront (before async operations) to avoid ref issues
              final actionNotifier = ref.read(activeActionProvider.notifier);
              final featuredInitiativesNotifier = ref.read(
                featuredInitiativeProvider.notifier,
              );
              final activeInitiativesNotifier = ref.read(
                activeInitiativeProvider.notifier,
              );

              try {
                // Wipe photos from storage (action id is the submission id)
                await PhotosService().deleteAllSubmissionPhotos(action.id);

                // Delete the action (this already refreshes activeActionProvider)
                await actionNotifier.deleteAction(action);

                // Refresh featured initiatives provider to update initiative totals
                await featuredInitiativesNotifier.refresh();
                await activeInitiativesNotifier.refresh();

                // Notify parent so it can invalidate linked-actions (keeps Recent Actions in sync).
                if (linkedId != null) {
                  onActionDeleted?.call(linkedId);
                  ref.invalidate(actionsByLinkedProvider((linkedId, 7)));
                }

                // Show success snackbar using stored ScaffoldMessenger
                scaffoldMessenger.showSnackBar(
                  CustomSnackBar.info('Action deleted!'),
                );
              } catch (e) {
                // Handle any errors gracefully
                scaffoldMessenger.showSnackBar(
                  CustomSnackBar.error('Error deleting action'),
                );
              }
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.delete, color: Colors.white, size: 12),
            ),
          ),
        ),
        child: card,
      );
    }
    return card;
  }

  static void _showPhotoViewer(
    BuildContext context, {
    required List<String> urls,
    required int initialIndex,
  }) {
    if (urls.isEmpty) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      builder: (context) =>
          _PhotoViewerDialog(urls: urls, initialIndex: initialIndex),
    );
  }

  String _titleForAction(ActionSchema action) {
    if (action.actionType.isNotEmpty) return action.actionType;
    return 'Action';
  }

  String _formatTimeAgo(DateTime date) {
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
}

class _PhotoCarousel extends StatefulWidget {
  final List<String> urls;
  final void Function(int index) onTap;
  final ThemeData theme;

  const _PhotoCarousel({
    required this.urls,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<_PhotoCarousel> {
  static const double _thumbSize = 36;
  static const double _gap = 12;
  late ScrollController _scrollController;
  void _onScroll() {
    if (!mounted) return;
    setState(() {});
  }

  double get _itemWidth => _thumbSize + _gap;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  bool get _canGoPrev =>
      _scrollController.hasClients && _scrollController.offset > 0.5;

  bool get _canGoNext =>
      _scrollController.hasClients &&
      _scrollController.offset <
          _scrollController.position.maxScrollExtent - 0.5;

  void _goToPrev() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final target = (pos.pixels - _itemWidth).clamp(0.0, pos.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _goToNext() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final target = (pos.pixels + _itemWidth).clamp(0.0, pos.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.urls.length > 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        return SizedBox(
          width: width,
          height: _thumbSize + 4,
          child: Row(
            children: [
              if (hasMultiple)
                SizedBox(
                  width: 28,
                  height: _thumbSize + 4,
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      iconSize: 20,
                      icon: Icon(
                        Icons.chevron_left,
                        color: widget.theme.colorScheme.onSurface.withAlpha(
                          180,
                        ),
                      ),
                      onPressed: _goToPrev,
                    ),
                  ),
                ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: hasMultiple
                      ? (DragEndDetails d) {
                          final v = d.velocity.pixelsPerSecond.dx;
                          if (v < -100 && _canGoNext) _goToNext();
                          if (v > 100 && _canGoPrev) _goToPrev();
                        }
                      : null,
                  behavior: HitTestBehavior.translucent,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemExtent: _itemWidth,
                    itemCount: widget.urls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < widget.urls.length - 1 ? _gap : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => widget.onTap(index),
                          behavior: HitTestBehavior.opaque,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: _thumbSize,
                              height: _thumbSize,
                              child: Image(
                                image: NetworkImage(
                                  widget.urls[index],
                                  webHtmlElementStrategy:
                                      WebHtmlElementStrategy.prefer,
                                ),
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: widget
                                      .theme
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: widget.theme.colorScheme.onSurface
                                        .withAlpha(128),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (hasMultiple)
                SizedBox(
                  width: 28,
                  height: _thumbSize + 4,
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      iconSize: 20,
                      icon: Icon(
                        Icons.chevron_right,
                        color: widget.theme.colorScheme.onSurface.withAlpha(
                          180,
                        ),
                      ),
                      onPressed: _goToNext,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PhotoViewerDialog extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const _PhotoViewerDialog({required this.urls, required this.initialIndex});

  @override
  State<_PhotoViewerDialog> createState() => _PhotoViewerDialogState();
}

class _PhotoViewerDialogState extends State<_PhotoViewerDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMultiple = widget.urls.length > 1;
    final size = MediaQuery.sizeOf(context);
    final contentConstraints = BoxConstraints(
      maxWidth: size.width - 32,
      maxHeight: size.height * 0.85,
    );
    final imageHeight = size.height * 0.55;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Tap outside content to close
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          // Content (tap here does not close)
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // absorb tap so backdrop doesn't get it
              child: ConstrainedBox(
                constraints: contentConstraints,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close left; page number always centered
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = AppConstants.isMobile(context);
                          if (isMobile) {
                            // On mobile: close icon far left, page index in center
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                                if (hasMultiple)
                                  Center(
                                    child: Text(
                                      '${_currentIndex + 1} / ${widget.urls.length}',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            // On large screens: close icon centered with page number, and space at the end to balance
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                if (hasMultiple) const SizedBox(width: 4),
                                hasMultiple
                                    ? Center(
                                        child: Text(
                                          '${_currentIndex + 1} / ${widget.urls.length}',
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    // Image (swipeable on desktop via horizontal drag)
                    SizedBox(
                      height: imageHeight,
                      child: GestureDetector(
                        onHorizontalDragEnd: hasMultiple
                            ? (DragEndDetails d) {
                                final v = d.velocity.pixelsPerSecond.dx;
                                if (v < -100 &&
                                    _currentIndex < widget.urls.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                  );
                                } else if (v > 100 && _currentIndex > 0) {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              }
                            : null,
                        behavior: HitTestBehavior.translucent,
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const PageScrollPhysics(),
                          itemCount: widget.urls.length,
                          onPageChanged: (i) =>
                              setState(() => _currentIndex = i),
                          itemBuilder: (context, index) {
                            return InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 4,
                              child: Image(
                                image: NetworkImage(
                                  widget.urls[index],
                                  webHtmlElementStrategy:
                                      WebHtmlElementStrategy.prefer,
                                ),
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.broken_image_outlined,
                                        size: 48,
                                        color: Colors.white70,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Failed to load image',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Prev / Next
                    if (hasMultiple) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: _currentIndex > 0
                                ? () {
                                    _pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: _currentIndex < widget.urls.length - 1
                                ? () {
                                    _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
