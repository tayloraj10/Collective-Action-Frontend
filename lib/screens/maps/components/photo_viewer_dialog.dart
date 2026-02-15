import 'package:flutter/material.dart';

/// Full-screen style dialog to view one or more images (e.g. from map event info).
class PhotoViewerDialog extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const PhotoViewerDialog({
    super.key,
    required this.urls,
    this.initialIndex = 0,
  });

  @override
  State<PhotoViewerDialog> createState() => _PhotoViewerDialogState();
}

class _PhotoViewerDialogState extends State<PhotoViewerDialog> {
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
    final imageHeight = size.height * 0.6;

    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width - 32,
          maxHeight: size.height * 0.85,
          minWidth: 200,
          minHeight: 200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      // Defer pop to avoid mobile Chrome crash when closing
                      // during gesture/layout.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      });
                    },
                  ),
                  if (hasMultiple)
                    Text(
                      '${_currentIndex + 1} / ${widget.urls.length}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            SizedBox(
              height: imageHeight,
              child: PageView.builder(
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
                        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
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
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
                              duration: const Duration(milliseconds: 200),
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
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
