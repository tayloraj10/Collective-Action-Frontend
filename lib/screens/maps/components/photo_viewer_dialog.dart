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

  /// Opens the photo viewer after the current tap; on mobile web uses a short
  /// delay to reduce crashes and jank when opening during tap.
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
        builder: (c) => PhotoViewerDialog(
          urls: urls,
          initialIndex: initialIndex,
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

  void _close() {
    // Prevent multiple taps from scheduling multiple pops (crashes on mobile Chrome).
    if (_isClosing) return;
    _isClosing = true;

    // Capture navigator and set provider synchronously—do not use context in the
    // delayed callback to avoid using disposed context or triggering rebuilds
    // during route removal. Also avoids races with image disposal on web.
    final navigator = Navigator.of(context);
    try {
      final container = ProviderScope.containerOf(context);
      container.read(photoViewerClosedAtProvider.notifier).setClosed();
    } catch (_) {}

    // On mobile web use a longer delay so (1) the tap is fully done and (2) any
    // in-flight image decode/network work can settle before we dispose the route.
    final isMobileWeb = kIsWeb && AppConstants.isMobile(context);
    final delay = isMobileWeb ? const Duration(milliseconds: 200) : null;

    if (delay != null) {
      Future.delayed(delay, () {
        if (navigator.mounted) navigator.pop();
      });
    } else {
      Future.microtask(() {
        if (navigator.mounted) navigator.pop();
      });
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Stack(
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
                    // Close + page index: match initiative card (mobile = close left, index center)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = AppConstants.isMobile(context);
                          if (isMobile) {
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
                                    onPressed: _close,
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: _close,
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
                            if (mounted) setState(() => _currentIndex = i);
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
      ),
    );
  }
}
