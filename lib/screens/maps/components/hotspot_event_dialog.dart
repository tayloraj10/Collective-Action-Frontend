import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/services/hotspot_service.dart';
import 'package:collective_action_frontend/utils/map_area_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HotspotEventDialogResult {
  HotspotEventDialogResult({
    required this.title,
    required this.description,
    required this.area,
  });

  final String title;
  final String description;
  final MapAreaSchema area;
}

/// Dialog to create a cleanup hotspot at a map location.
class HotspotEventDialog extends StatefulWidget {
  const HotspotEventDialog({
    super.key,
    required this.position,
    required this.allowedAreas,
    this.suggestedArea,
  });

  final LatLng position;
  final List<MapAreaSchema> allowedAreas;
  final MapAreaSchema? suggestedArea;

  @override
  State<HotspotEventDialog> createState() => _HotspotEventDialogState();
}

class _HotspotEventDialogState extends State<HotspotEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late MapAreaSchema _selectedArea;

  @override
  void initState() {
    super.initState();
    final detected = detectAreaForPoint(
      widget.position.latitude,
      widget.position.longitude,
      widget.allowedAreas,
    );
    if (widget.allowedAreas.length == 1) {
      _selectedArea = widget.allowedAreas.first;
    } else if (detected != null && widget.allowedAreas.any((a) => a.id == detected.id)) {
      _selectedArea = detected;
    } else if (widget.suggestedArea != null &&
        widget.allowedAreas.any((a) => a.id == widget.suggestedArea!.id)) {
      _selectedArea = widget.suggestedArea!;
    } else {
      _selectedArea = widget.allowedAreas.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final areaContainsPoint = detectAreaForPoint(
      widget.position.latitude,
      widget.position.longitude,
      [_selectedArea],
    );
    if (areaContainsPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location must be inside ${areaDisplayName(_selectedArea)}',
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      HotspotEventDialogResult(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        area: _selectedArea,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.local_fire_department, color: Color(0xFFFF6D00)),
          SizedBox(width: 8),
          Text('Add Cleanup Hotspot'),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Mark an area that needs targeted cleanup. The orange circle on the map is $hotspotRadiusDescription.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Hotspot name',
                  hintText: 'e.g. Prospect Park litter zone',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Details (optional)',
                  hintText: 'Why this area needs attention',
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<MapAreaSchema>(
                initialValue: _selectedArea,
                decoration: const InputDecoration(labelText: 'Area'),
                items: widget.allowedAreas
                    .map(
                      (area) => DropdownMenuItem(
                        value: area,
                        child: Text('${areaDisplayName(area)} (${areaTypeLabel(area)})'),
                      ),
                    )
                    .toList(),
                onChanged: widget.allowedAreas.length <= 1
                    ? null
                    : (v) {
                        if (v != null) setState(() => _selectedArea = v);
                      },
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
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.local_fire_department),
          label: const Text('Add Hotspot'),
        ),
      ],
    );
  }
}
