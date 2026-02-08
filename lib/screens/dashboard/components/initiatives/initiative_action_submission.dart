import 'dart:typed_data';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/services/actions_service.dart';
import 'package:collective_action_frontend/services/photos_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:image_picker/image_picker.dart';

class InitiativeActionSubmission extends ConsumerStatefulWidget {
  final InitiativeSchema initiative;

  const InitiativeActionSubmission({super.key, required this.initiative});

  @override
  ConsumerState<InitiativeActionSubmission> createState() =>
      InitiativeActionSubmissionState();
}

class InitiativeActionSubmissionState
    extends ConsumerState<InitiativeActionSubmission> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  static const int _maxPhotos = 5;
  final List<XFile> _selectedPhotos = [];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  final TextEditingController _amountController = TextEditingController(
    text: '1',
  );

  @override
  void dispose() {
    _amountController.dispose();
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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });
    _formKey.currentState!.save();
    final notifier = ref.read(activeActionProvider.notifier);
    final featuredInitiatives = ref.read(featuredInitiativeProvider.notifier);
    final activeInitiatives = ref.read(activeInitiativeProvider.notifier);
    final int? amount = int.tryParse(_amountController.text);
    final user = ref.read(currentUserProvider).value;
    try {
      // Create the action first (no photos yet) so we have an action id to upload under.
      final action = ActionCreateSchema(
        actionType: ActionTypeValuesEnum.initiative.value,
        amount: amount as int,
        imageUrls: const [],
        linkedId: widget.initiative.id,
        userId: user?.id,
        date: _selectedDate,
      );

      final created = await notifier.createAction(action);
      if (created == null) {
        throw Exception('Action creation returned no result');
      }

      // Upload photos under the action's UUID so they stay associated, then update the action with the URLs.
      if (_selectedPhotos.isNotEmpty) {
        final photosService = PhotosService();
        final actionsService = ActionsService();
        final uploaded = await photosService.uploadSubmissionPhotosBatch(
          created.id,
          _selectedPhotos,
        );
        if (uploaded == null || uploaded.isEmpty) {
          throw Exception('Photo upload returned no URLs');
        }
        await actionsService.updateActionPhotos(created.id, uploaded);
        // Refresh global actions list after photo update
        await notifier.refresh();
      }
      // Refresh initiative data used across the app:
      // - featuredInitiativeProvider drives dashboard widgets
      // - activeInitiativeProvider drives the full initiatives list screen
      await featuredInitiatives.refresh();
      await activeInitiatives.refresh();
      // Refresh linked action lists (e.g. recent actions under an initiative)
      // using the same days window as the initiatives list screen (7 days).
      ref.invalidate(actionsByLinkedProvider((widget.initiative.id, 7)));
      // Play sound on success (web-compatible)
      // AppConstants.playRandomSuccessSound();
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar.success('Action created!'));
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "An error occurred";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = AppConstants.isMobile(context);

    return SizedBox(
      width: 450,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spruced up title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Make a Contribution',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                widget.initiative.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,

                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Amount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  final n = int.tryParse(value);
                  if (n == null) {
                    return 'Enter a valid number';
                  }
                  if (n < 1 || n > 10) {
                    return 'Number must be between 1 and 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 22),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (_selectedPhotos.isNotEmpty) ...[
                LayoutBuilder(
                  builder: (context, constraints) {
                    const itemWidth = 64.0;
                    const gap = 8.0;
                    final n = _selectedPhotos.length;
                    final contentWidth =
                        n * itemWidth + (n > 1 ? (n - 1) * gap : 0.0);
                    final horizontalPadding =
                        (constraints.maxWidth - contentWidth).clamp(
                          0.0,
                          double.infinity,
                        ) /
                        2;
                    return SizedBox(
                      height: 64,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        itemCount: _selectedPhotos.length,
                        separatorBuilder: (_, _) => const SizedBox(width: gap),
                        itemBuilder: (context, index) {
                          final xFile = _selectedPhotos[index];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: itemWidth,
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
                                child: GestureDetector(
                                  onTap: () {
                                    setState(
                                      () => _selectedPhotos.removeAt(index),
                                    );
                                  },
                                  child: CircleAvatar(
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
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
              LayoutBuilder(
                builder: (context, constraints) {
                  final sideBySide = constraints.maxWidth >= 380;
                  const spacing = 12.0;
                  const btnPadding = EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  );
                  final addPhotosLabel = _selectedPhotos.isEmpty
                      ? 'Add Photos'
                      : 'Add Photos (${_selectedPhotos.length}/$_maxPhotos)';

                  Widget addPhotosButton = ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBlue,
                      padding: btnPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _selectedPhotos.length >= _maxPhotos
                        ? null
                        : _pickPhotos,
                    icon: const Icon(Icons.image, size: 22),
                    label: Text(
                      addPhotosLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );

                  Widget submitButton = ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen.withAlpha(217),
                      padding: btnPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _loading ? null : _submit,
                    icon: const Icon(Icons.check, size: 22),
                    label: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );

                  if (sideBySide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(fit: FlexFit.loose, child: addPhotosButton),
                        const SizedBox(width: 30),
                        submitButton,
                      ],
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      addPhotosButton,
                      const SizedBox(height: spacing),
                      submitButton,
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textTertiaryDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: _pickDate,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month, size: 26),
                    const SizedBox(width: 10),
                    Text(
                      '${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.year.toString().substring(2)}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
