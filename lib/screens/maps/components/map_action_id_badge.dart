import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Database action id for map submission info popups (tap to copy full UUID).
class MapActionIdBadge extends StatelessWidget {
  const MapActionIdBadge({
    super.key,
    required this.actionId,
    this.onHeader = true,
  });

  final String actionId;
  final bool onHeader;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = onHeader
        ? Colors.black.withValues(alpha: 0.28)
        : theme.colorScheme.surfaceContainerHighest;
    final foreground = onHeader
        ? Colors.white
        : theme.colorScheme.onSurfaceVariant;
    final borderColor = onHeader
        ? Colors.white.withValues(alpha: 0.35)
        : theme.colorScheme.outline.withValues(alpha: 0.45);

    return Tooltip(
      message: '$actionId\nTap to copy',
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: actionId));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Action ID copied'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 148),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ID',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: foreground.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  actionId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontSize: 10,
                    height: 1.1,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.copy, size: 12, color: foreground.withValues(alpha: 0.9)),
            ],
          ),
        ),
      ),
    );
  }
}
