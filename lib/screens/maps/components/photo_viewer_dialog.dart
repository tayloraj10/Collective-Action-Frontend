import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/providers/map_zoom_provider.dart';
import 'package:collective_action_frontend/utils/safe_navigation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full-screen style dialog to view one or more images (e.g. from map event info).
/// Use [PhotoViewerDialog.show] to open with deferred show. Tap outside (dark area)
/// or the close button dismiss via a deferred pop to avoid mobile Chrome crashes.
class PhotoViewerDialog extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const PhotoViewerDialog({
    super.key,
    required this.urls,
    this.initialIndex = 0,
  });

  /// Same opening style as initiative submission: showDialog with Dialog(child: content).
  /// Opens after the current tap to reduce mobile Chrome crashes.
  static void show(
    BuildContext context, {
    required List<String> urls,
    int initialIndex = 0,
  }) {
    if (urls.isEmpty) return;
    scheduleAfterTap(context, () {
      if (!context.mounted) return;
      showDialog<void>(
        context: context,
        barrierColor: Colors.black87,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: PhotoViewerDialog(
            urls: urls,
            initialIndex: initialIndex,
          ),
        ),
      );
    });
  }

  @override
  State<PhotoViewerDialog> createState() => _PhotoViewerDialogState();
}

class _PhotoViewerDialogState extends State<PhotoViewerDialog> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isClosing = false;

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

  /// Delay on mobile web so the tap finishes and image work can settle before
  /// we pop (reduces crashes when closing from dashboard on mobile Chrome).
  static const Duration _kMobileWebCloseDelay = Duration(milliseconds: 280);

  void _close() {
    if (!mounted) return;
    if (_isClosing) return;
    _isClosing = true;

    // Capture navigator (and optionally container) synchronously. Do not use
    // context in the delayed callback. Defer setClosed() until after pop so we
    // don't trigger rebuilds while the dialog is still in the tree.
    NavigatorState? navigator;
    ProviderContainer? container;
    try {
      navigator = Navigator.of(context);
      container = ProviderScope.containerOf(context);
    } catch (_) {
      // Context invalid; cannot pop safely.
      return;
    }

    final isMobileWeb = kIsWeb && AppConstants.isMobile(context);
    final delay = isMobileWeb ? _kMobileWebCloseDelay : null;

    void doPop() {
      final nav = navigator;
      if (nav == null || !nav.mounted) return;
      nav.pop();
      // Notify after route is removed so we don't rebuild during pop.
      final c = container;
      if (c != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            c.read(photoViewerClosedAtProvider.notifier).setClosed();
          } catch (_) {}
        });
      }
    }

    if (delay != null) {
      Future.delayed(delay, doPop);
    } else {
      Future.microtask(doPop);
    }
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

    return Stack(
      fit: StackFit.expand,
        children: [
          // Tap outside content to close (deferred pop; barrier shows through)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
            ),
          ),
          // Content: tap here does not close
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: ConstrainedBox(
                constraints: contentConstraints,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close + page index: match initiative card (mobile = close left, index center).
                    // Use GestureDetector (not IconButton) so close path matches tap-outside and
                    // avoids IconButton splash/focus behavior that can trigger crashes on mobile Chrome.
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = AppConstants.isMobile(context);
                          final closeControl = GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _close,
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          );
                          if (isMobile) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: closeControl,
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                closeControl,
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
                    // Image (swipeable via horizontal drag on desktop)
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
                          physics: const PageScrollPhysics(),
                          controller: _pageController,
                          itemCount: widget.urls.length,
                          onPageChanged: (i) {
                            if (mounted && !_isClosing) setState(() => _currentIndex = i);
                          },
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
      );
  }
}
