import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

enum PlantingKind {
  tree('tree', 'Tree', EventDataType.treePlanting),
  wildflower('wildflower', 'Wildflower', EventDataType.wildflowerPlanting);

  const PlantingKind(this.value, this.label, this.eventType);
  final String value;
  final String label;
  final EventDataType eventType;
}

class PlantingEventDialogResult {
  const PlantingEventDialogResult({
    required this.eventData,
    this.photos = const [],
  });

  final Map<String, dynamic> eventData;
  final List<XFile> photos;
}

class PlantingEventDialog extends StatefulWidget {
  const PlantingEventDialog({
    super.key,
    required this.position,
    this.initialName,
  });

  final LatLng position;
  final String? initialName;

  @override
  State<PlantingEventDialog> createState() => _PlantingEventDialogState();
}

class _PlantingEventDialogState extends State<PlantingEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();

  static const int _maxPhotos = 5;
  final List<XFile> _selectedPhotos = [];
  PlantingKind _kind = PlantingKind.tree;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null && widget.initialName!.isNotEmpty) {
      _nameController.text = widget.initialName!;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _speciesController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final remaining = _maxPhotos - _selectedPhotos.length;
    if (remaining <= 0) return;
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1024,
      limit: remaining,
    );
    if (picked.isEmpty || !mounted) return;
    setState(() {
      for (final x in picked) {
        if (_selectedPhotos.length >= _maxPhotos) break;
        _selectedPhotos.add(x);
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    Navigator.of(context).pop(
      PlantingEventDialogResult(
        eventData: {
          'type': _kind.eventType.value,
          'planting_type': _kind.value,
          'name': _nameController.text.trim(),
          'location': _locationController.text.trim(),
          'species': _speciesController.text.trim(),
          'quantity': quantity < 1 ? 1 : quantity,
          'notes': _notesController.text.trim(),
        },
        photos: List.from(_selectedPhotos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final contentHeight = (size.height * 0.85).clamp(280.0, 700.0);
    final contentWidth = (size.width * 0.95).clamp(280.0, 420.0);
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: contentWidth,
          maxHeight: contentHeight,
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
                    'Add Planting',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton<PlantingKind>(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.successGreen.withValues(
                                  alpha: 0.2,
                                );
                              }
                              return null;
                            }),
                            foregroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.successGreen;
                              }
                              return Theme.of(context).colorScheme.onSurface;
                            }),
                            side: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return BorderSide(
                                  color: AppColors.successGreen,
                                  width: 2,
                                );
                              }
                              return BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.5),
                                width: 1,
                              );
                            }),
                            textStyle: WidgetStateProperty.resolveWith((states) {
                              return Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: states.contains(
                                          WidgetState.selected,
                                        )
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  );
                            }),
                          ),
                          segments: const [
                            ButtonSegment(
                              value: PlantingKind.tree,
                              icon: Icon(Icons.park, size: 18),
                              label: Text('Tree'),
                            ),
                            ButtonSegment(
                              value: PlantingKind.wildflower,
                              icon: Icon(Icons.local_florist, size: 18),
                              label: Text('Wildflower'),
                            ),
                          ],
                          selected: {_kind},
                          onSelectionChanged: (selected) {
                            setState(() => _kind = selected.first);
                          },
                          showSelectedIcon: true,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location / Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _speciesController,
                          decoration: InputDecoration(
                            labelText: _kind == PlantingKind.tree
                                ? 'Tree species'
                                : 'Wildflower species / seed mix',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity planted',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            final quantity = int.tryParse(value ?? '');
                            if (quantity == null || quantity < 1) {
                              return 'Enter at least 1';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          minLines: 2,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Text(
                          'Photos',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        if (_selectedPhotos.isNotEmpty) ...[
                          SizedBox(
                            width: contentWidth - 48,
                            height: 64,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedPhotos.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final xFile = _selectedPhotos[index];
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: FutureBuilder<Uint8List>(
                                          future: xFile.readAsBytes(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              return Image.memory(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                            return const Center(
                                              child: Icon(Icons.image),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -4,
                                      right: -4,
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.basic,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(
                                              () => _selectedPhotos.removeAt(
                                                index,
                                              ),
                                            );
                                          },
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        MouseRegion(
                          cursor: SystemMouseCursors.basic,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _selectedPhotos.length >= _maxPhotos
                                ? null
                                : _pickPhotos,
                            icon: const Icon(Icons.image, size: 22),
                            label: Text(
                              _selectedPhotos.isEmpty
                                  ? 'Add Photos'
                                  : 'Add Photos (${_selectedPhotos.length}/$_maxPhotos)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
