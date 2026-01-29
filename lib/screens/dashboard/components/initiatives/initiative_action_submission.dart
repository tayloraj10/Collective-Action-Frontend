import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/providers/initiative_provider.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/action_provider.dart';
import 'package:audioplayers/audioplayers.dart';

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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });
    _formKey.currentState!.save();
    final notifier = ref.read(activeActionProvider.notifier);
    final featuredInitiatives = ref.read(featuredInitiativeProvider.notifier);
    final int? amount = int.tryParse(_amountController.text);
    final user = ref.read(currentUserProvider).value;
    final action = ActionCreateSchema(
      actionType: ActionTypeValuesEnum.initiative.value,
      amount: amount as int,
      imageUrl: null,
      linkedId: widget.initiative.id,
      userId: user?.id,
      date: _selectedDate,
    );
    try {
      await notifier.createAction(action);
      await featuredInitiatives.refresh();
      // Play sound on success (web-compatible)
      // Create a separate AudioPlayer instance so it doesn't get disposed
      // when the dialog closes, allowing the sound to play fully
      try {
        final audioPlayer = AudioPlayer();
        audioPlayer.setReleaseMode(ReleaseMode.release);
        final (:source, :maxDuration) = AppConstants.randomSuccessSoundSource();
        audioPlayer.play(source);
        // Stop playback after maxDuration
        Future.delayed(maxDuration, () => audioPlayer.stop());
        // Audio player will auto-dispose when playback completes due to ReleaseMode.release
      } catch (e) {
        // Ignore sound errors
      }
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

    return SizedBox(
      width: 400,
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
                  Text(
                    'Make a Contribution',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.image, size: 26),
                    label: const Text(
                      'Add Image',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen.withAlpha(217),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _loading ? null : _submit,
                    icon: const Icon(Icons.check, size: 26),
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
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
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
