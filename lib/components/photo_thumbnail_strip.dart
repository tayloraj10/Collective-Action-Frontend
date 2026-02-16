import 'package:flutter/material.dart';

/// Standardized horizontal photo strip: compact thumbnails with scroll arrows
/// when multiple images (or fit-to-width when [showArrows] is false).
/// Use with [PhotoViewerDialog.show] on tap.
class PhotoThumbnailStrip extends StatefulWidget {
  final List<String> urls;
  final void Function(int index) onTap;
  final ThemeData? theme;

  /// Thumbnail size when scrollable. Default 36 (compact). Use 48 for dialogs with arrows.
  final double thumbSize;

  /// When false (e.g. cleanup/trash event dialogs), no arrows are shown and
  /// thumbnails share the available width so all fit.
  final bool showArrows;

  const PhotoThumbnailStrip({
    super.key,
    required this.urls,
    required this.onTap,
    this.theme,
    this.thumbSize = 36,
    this.showArrows = true,
  });

  @override
  State<PhotoThumbnailStrip> createState() => _PhotoThumbnailStripState();
}

class _PhotoThumbnailStripState extends State<PhotoThumbnailStrip> {
  static const double _gap = 12;
  late ScrollController _scrollController;

  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Arrows need hasClients; rebuild once after layout so they enable correctly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  double get _itemWidth => widget.thumbSize + _gap;

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

  Widget _buildThumb(ThemeData theme, String url, int index, double size) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: size,
          height: size,
          child: Image(
            image: NetworkImage(
              url,
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
            ),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.onSurface.withAlpha(128),
                size: 20,
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);
    final hasMultiple = widget.urls.length > 1;
    final showArrows = widget.showArrows && hasMultiple;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        // Fit-to-width mode: no arrows, distribute space so all thumbs fit.
        if (!widget.showArrows && widget.urls.isNotEmpty) {
          const gap = 12.0;
          final count = widget.urls.length;
          final totalGaps = (count - 1) * gap;
          final itemSize = ((width - totalGaps) / count).clamp(24.0, 120.0);
          return SizedBox(
            height: itemSize,
            child: Row(
              children: [
                for (int i = 0; i < count; i++)
                  Padding(
                    padding: EdgeInsets.only(right: i < count - 1 ? gap : 0),
                    child: _buildThumb(
                      theme,
                      widget.urls[i],
                      i,
                      itemSize,
                    ),
                  ),
              ],
            ),
          );
        }

        return SizedBox(
          width: width,
          height: widget.thumbSize + 4,
          child: Row(
            children: [
              if (showArrows)
                SizedBox(
                  width: 28,
                  height: widget.thumbSize + 4,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_canGoPrev) _goToPrev();
                      },
                      child: Center(
                        child: Icon(
                          Icons.chevron_left,
                          size: 20,
                          color: theme.colorScheme.onSurface.withAlpha(180),
                        ),
                      ),
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
                        child: _buildThumb(
                          theme,
                          widget.urls[index],
                          index,
                          widget.thumbSize,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (showArrows)
                SizedBox(
                  width: 28,
                  height: widget.thumbSize + 4,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_canGoNext) _goToNext();
                      },
                      child: Center(
                        child: Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: theme.colorScheme.onSurface.withAlpha(180),
                        ),
                      ),
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
