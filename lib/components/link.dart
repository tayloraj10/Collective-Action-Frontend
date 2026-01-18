import 'package:flutter/material.dart';

class LinkText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color color;
  final int maxLines;
  final FontWeight fontWeight;
  final void Function()? onTap;

  const LinkText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    this.maxLines = 2,
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
          style: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            decoration: TextDecoration.underline,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: widget.maxLines,
        ),
      ),
    );
  }
}
