import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Bar shown after dropping a pin or drawing a route to confirm submit or cancel.
/// Mobile: text on top row, check/cancel on row below. Desktop: all in one row.
class PinConfirmationBar extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const PinConfirmationBar({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final textWidget = Text(
      'Add details or Cancel',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
    final buttons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onSubmit,
          icon: const Icon(Icons.check),
          tooltip: 'Continue',
        ),
        SizedBox(width: isMobile ? 12 : 8),
        IconButton(
          onPressed: onCancel,
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          icon: const Icon(Icons.close),
          tooltip: 'Cancel',
        ),
      ],
    );

    return SafeArea(
      child: PointerInterceptor(
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: isMobile
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      textWidget,
                      const SizedBox(height: 8),
                      buttons,
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textWidget,
                      const SizedBox(width: 12),
                      buttons,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
