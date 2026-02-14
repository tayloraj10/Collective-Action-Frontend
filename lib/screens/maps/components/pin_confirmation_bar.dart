import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Bar shown after dropping a pin or drawing a route to confirm submit or cancel.
/// Wrapped in [PointerInterceptor] so clicks hit the bar instead of the map (e.g. on web).
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
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add details or Cancel',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: onSubmit,
                      icon: const Icon(Icons.check),
                      tooltip: 'Continue',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onCancel,
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      icon: const Icon(Icons.close),
                      tooltip: 'Cancel',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
