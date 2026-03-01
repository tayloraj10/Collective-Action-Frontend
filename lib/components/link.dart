import 'package:flutter/material.dart';

class LinkText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  /// Null = no limit; set to 2 e.g. to cap at 2 lines with ellipsis.
  final int? maxLines;
  final FontWeight fontWeight;
  final void Function()? onTap;

  const LinkText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.maxLines,
    this.fontWeight = FontWeight.w500,
    this.onTap,
  });

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          maxLines: widget.maxLines,
          style: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            overflow: widget.maxLines != null
                ? TextOverflow.ellipsis
                : TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}
