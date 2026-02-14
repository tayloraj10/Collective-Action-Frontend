import 'dart:typed_data';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

/// Result of trash report event dialog: event data plus optional photos to upload.
class TrashReportEventDialogResult {
  final TrashReportEventData eventData;
  final List<XFile> photos;

  const TrashReportEventDialogResult({
    required this.eventData,
    this.photos = const [],
  });
}

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

  static const int _maxPhotos = 5;
  final List<XFile> _selectedPhotos = [];

  @override
  void dispose() {
    _locationController.dispose();
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
    final eventData = TrashReportEventData(
      location: _locationController.text.trim().isEmpty
          ? ''
          : _locationController.text.trim(),
      imageUrl: null,
    );
    Navigator.of(context).pop(
      TrashReportEventDialogResult(
        eventData: eventData,
        photos: List.from(_selectedPhotos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final contentHeight = (size.height * 0.85).clamp(280.0, 700.0);
    final contentWidth = (size.width * 0.95).clamp(280.0, 400.0);
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
                    'Report Trash',
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
                        Text(
                          'Details',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
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
