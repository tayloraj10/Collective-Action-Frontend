import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Dialog to capture trash report event data when dropping a report pin.
/// Model: type, location, imageUrl (optional).
class TrashReportEventDialog extends StatefulWidget {
  final LatLng position;

  const TrashReportEventDialog({super.key, required this.position});

  @override
  State<TrashReportEventDialog> createState() => _TrashReportEventDialogState();
}

class _TrashReportEventDialogState extends State<TrashReportEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final eventData = TrashReportEventData(
      location: _locationController.text.trim().isEmpty
          ? ''
          : _locationController.text.trim(),
      imageUrl: null,
    );
    Navigator.of(context).pop(eventData);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report Trash'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Details',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location / Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Submit')),
      ],
    );
  }
}
