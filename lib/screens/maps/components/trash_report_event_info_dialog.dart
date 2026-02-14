import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:flutter/material.dart';
import 'photo_viewer_dialog.dart';

/// Dialog to display trash report event information when a trash report pin is clicked.
class TrashReportEventInfoDialog extends StatelessWidget {
  final ActionSchema action;
  final TrashReportEventData? eventData;

  const TrashReportEventInfoDialog({
    super.key,
    required this.action,
    this.eventData,
  });

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime d) {
    return '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';
  }

  /// Prefer event_data image_url, then action.imageUrls. Normalize so relative or quoted URLs load.
  static List<String> _imageUrls(
    ActionSchema action,
    TrashReportEventData? eventData,
  ) {
    final urls = <String>[];
    if (eventData?.imageUrl != null && eventData!.imageUrl!.isNotEmpty) {
      final u = PhotosService.normalizePhotoUrl(eventData.imageUrl!);
      if (u.isNotEmpty && !urls.contains(u)) urls.add(u);
    }
    if (action.imageUrls.isNotEmpty) {
      for (final url in action.imageUrls) {
        if (url.isEmpty) continue;
        final u = PhotosService.normalizePhotoUrl(url);
        if (u.isNotEmpty && !urls.contains(u)) urls.add(u);
      }
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxH = (size.height * 0.7).clamp(200.0, 500.0);
    final maxW = (size.width * 0.95).clamp(280.0, 400.0);
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxW,
          maxHeight: maxH,
          minWidth: 280,
          minHeight: 200,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Trash Report',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Details',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (eventData?.location != null &&
                          eventData!.location.isNotEmpty)
                        _InfoRow(
                          label: 'Location',
                          value: eventData!.location,
                          icon: Icons.location_on_outlined,
                        ),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      _InfoRow(
                        label: 'Date',
                        value: _formatDate(action.date),
                        icon: Icons.calendar_today_outlined,
                      ),
                      if (_imageUrls(action, eventData).isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Image${_imageUrls(action, eventData).length > 1 ? 's' : ''}',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _InfoDialogPhotoGallery(
                          urls: _imageUrls(action, eventData),
                          onPhotoTap: (index) {
                            showDialog(
                              context: context,
                              builder: (c) => PhotoViewerDialog(
                                urls: _imageUrls(action, eventData),
                                initialIndex: index,
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _InfoRow({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: icon != null ? 90 : 100,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

/// Horizontal scrollable photo gallery with optional prev/next buttons (like initiative action card).
class _InfoDialogPhotoGallery extends StatefulWidget {
  final List<String> urls;
  final void Function(int index)? onPhotoTap;

  const _InfoDialogPhotoGallery({required this.urls, this.onPhotoTap});

  @override
  State<_InfoDialogPhotoGallery> createState() =>
      _InfoDialogPhotoGalleryState();
}

class _InfoDialogPhotoGalleryState extends State<_InfoDialogPhotoGallery> {
  static const double _thumbSize = 48;
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

  double get _itemWidth => _thumbSize + _gap;

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

  Widget _buildThumb(
    BuildContext context,
    ThemeData theme,
    String url,
    int index,
    double size,
  ) {
    final thumb = ClipRRect(
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
    );
    if (widget.onPhotoTap != null) {
      return GestureDetector(
        onTap: () => widget.onPhotoTap!(index),
        child: thumb,
      );
    }
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMultiple = widget.urls.length > 1;
    final isMobile = AppConstants.isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (!isMobile && widget.urls.isNotEmpty) {
          final count = widget.urls.length;
          const gap = 12.0;
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
                      context,
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
          height: _thumbSize + 4,
          child: Row(
            children: [
              if (hasMultiple)
                SizedBox(
                  width: 28,
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
                        color: theme.colorScheme.onSurface.withAlpha(180),
                      ),
                      onPressed: _canGoPrev ? _goToPrev : null,
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemExtent: _itemWidth,
                  itemCount: widget.urls.length,
                  itemBuilder: (context, index) {
                    final url = widget.urls[index];
                    final thumb = Padding(
                      padding: EdgeInsets.only(
                        right: index < widget.urls.length - 1 ? _gap : 0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          width: _thumbSize,
                          height: _thumbSize,
                          child: Image(
                            image: NetworkImage(
                              url,
                              webHtmlElementStrategy:
                                  WebHtmlElementStrategy.prefer,
                            ),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: theme.colorScheme.onSurface.withAlpha(
                                  128,
                                ),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    if (widget.onPhotoTap != null) {
                      return GestureDetector(
                        onTap: () => widget.onPhotoTap!(index),
                        child: thumb,
                      );
                    }
                    return thumb;
                  },
                ),
              ),
              if (hasMultiple)
                SizedBox(
                  width: 28,
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
                        color: theme.colorScheme.onSurface.withAlpha(180),
                      ),
                      onPressed: _canGoNext ? _goToNext : null,
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
