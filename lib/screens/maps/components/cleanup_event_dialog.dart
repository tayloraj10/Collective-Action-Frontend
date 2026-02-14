import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

/// Result of cleanup event dialog: event data plus optional photos to upload.
class CleanupEventDialogResult {
  final CleanupEventData eventData;
  final List<XFile> photos;

  const CleanupEventDialogResult({
    required this.eventData,
    this.photos = const [],
  });
}

/// Dialog to capture cleanup event data when dropping a cleanup pin.
class CleanupEventDialog extends StatefulWidget {
  final LatLng position;

  /// Default value for the name field (e.g. current user's name when logged in).
  final String? initialName;

  const CleanupEventDialog({
    super.key,
    required this.position,
    this.initialName,
  });

  @override
  State<CleanupEventDialog> createState() => _CleanupEventDialogState();
}

class _CleanupEventDialogState extends State<CleanupEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _smallBagsController = TextEditingController();
  final _largeBagsController = TextEditingController();
  final _poundsController = TextEditingController();

  static const int _maxPhotos = 5;
  final List<XFile> _selectedPhotos = [];

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
    _smallBagsController.dispose();
    _largeBagsController.dispose();
    _poundsController.dispose();
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
    final smallBags = int.tryParse(_smallBagsController.text) ?? 0;
    final largeBags = int.tryParse(_largeBagsController.text) ?? 0;
    final pounds = num.tryParse(_poundsController.text);
    final eventData = CleanupEventData(
      name: _nameController.text.trim().isEmpty
          ? ''
          : _nameController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? ''
          : _locationController.text.trim(),
      smallBags: smallBags == 0 ? null : smallBags,
      largeBags: largeBags == 0 ? null : largeBags,
      pounds: pounds,
    );
    Navigator.of(context).pop(
      CleanupEventDialogResult(
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
                    'Add Cleanup',
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Text(
                          'Cleanup amounts',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _smallBagsController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Small Bags Cleaned Up',
                                border: OutlineInputBorder(),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '(about a plastic shopping bag)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _largeBagsController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Large Bags Cleaned Up',
                                border: OutlineInputBorder(),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '(about a plastic garbage bag)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _poundsController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Pounds of trash',
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                          ],
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
