import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter/material.dart';

/// Dialog to display cleanup event information when a cleanup pin is clicked.
class CleanupEventInfoDialog extends StatelessWidget {
  final ActionSchema action;
  final CleanupEventData? eventData;

  const CleanupEventInfoDialog({
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cleanup Event'),
      content: SingleChildScrollView(
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (eventData?.name != null && eventData!.name.isNotEmpty)
              _InfoRow(
                label: 'Name',
                value: eventData!.name,
                icon: Icons.person_outline,
              ),
            if (eventData?.location != null && eventData!.location.isNotEmpty)
              _InfoRow(
                label: 'Location',
                value: eventData!.location,
                icon: Icons.location_on_outlined,
              ),
            // Only show cleanup amounts section if at least one amount is present
            if (eventData?.smallBags != null ||
                eventData?.largeBags != null ||
                eventData?.pounds != null) ...[
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Cleanup amounts',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (eventData?.smallBags != null)
                _InfoRow(
                  label: 'Small Bags',
                  value: '${eventData!.smallBags}',
                  icon: Icons.shopping_bag_outlined,
                ),
              if (eventData?.largeBags != null)
                _InfoRow(
                  label: 'Large Bags',
                  value: '${eventData!.largeBags}',
                  icon: Icons.delete_outline,
                ),
              if (eventData?.pounds != null)
                _InfoRow(
                  label: 'Pounds',
                  value: '${eventData!.pounds}',
                  icon: Icons.scale_outlined,
                ),
            ],
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Date',
              value: _formatDate(action.date),
              icon: Icons.calendar_today_outlined,
            ),
            if (eventData?.imageUrl != null &&
                eventData!.imageUrl!.isNotEmpty) ...[
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
                    'Image',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Image.network(
                eventData!.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Failed to load image');
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
