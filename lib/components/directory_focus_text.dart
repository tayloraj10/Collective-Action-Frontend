import 'package:flutter/material.dart';

/// Focus / description text for Directory of Good entries.
///
/// Long text can be limited to [maxLinesCollapsed] with ellipsis; users can expand
/// inline. When collapsed, [Tooltip] shows the full text on hover (web/desktop) or
/// long-press (mobile).
///
/// By default, limiting applies on **mobile** only (full detail on desktop for entry
/// pages). Set [truncateOnDesktop] for compact **feed cards** so desktop gets the
/// same limits as mobile.
class DirectoryFocusText extends StatefulWidget {
  const DirectoryFocusText({
    super.key,
    required this.text,
    required this.isMobile,
    required this.style,
    this.compact = false,
    this.maxLinesCollapsed = 3,

    /// Only offer expand/collapse when text is long enough to matter.
    this.minCharsForExpand = 100,

    /// When true (e.g. dashboard/social Directory of Good action cards), long text
    /// is truncated on desktop/tablet too, not only on mobile.
    this.truncateOnDesktop = false,
  });

  final String text;
  final bool isMobile;
  final TextStyle? style;
  final bool compact;
  final int maxLinesCollapsed;
  final int minCharsForExpand;

  /// Compact feed cards: limit copy on all platforms.
  final bool truncateOnDesktop;

  @override
  State<DirectoryFocusText> createState() => _DirectoryFocusTextState();
}

class _DirectoryFocusTextState extends State<DirectoryFocusText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final eligible =
        widget.isMobile || widget.truncateOnDesktop;
    final useExpand =
        eligible && text.length >= widget.minCharsForExpand;

    if (!useExpand) {
      return Text(text, style: widget.style);
    }

    final textWidget = Text(
      text,
      style: widget.style,
      maxLines: _expanded ? null : widget.maxLinesCollapsed,
      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
    );

    final core = !_expanded
        ? Tooltip(
            message: text,
            waitDuration: const Duration(milliseconds: 400),
            child: textWidget,
          )
        : textWidget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        core,
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            style: TextButton.styleFrom(
              padding: EdgeInsets.only(top: widget.compact ? 2 : 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              _expanded
                  ? 'Show less'
                  : (widget.compact ? 'Read more' : 'Read full focus'),
            ),
          ),
        ),
      ],
    );
  }
}
