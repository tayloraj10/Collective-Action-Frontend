import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preference key for persistence. Used by [SoundEnabledNotifier] and by
/// [AppConstants.playRandomSuccessSound] so sound can be gated without ref.
const String soundEnabledPrefsKey = 'sound_enabled';

class SoundEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadFromPrefs();
    return true; // default: sounds on
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(soundEnabledPrefsKey);
    if (stored != null && stored != state) {
      state = stored;
    }
  }

  Future<void> _persist(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(soundEnabledPrefsKey, value);
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _persist(enabled);
  }

  Future<void> toggle() async {
    state = !state;
    await _persist(state);
  }
}

final soundEnabledProvider = NotifierProvider<SoundEnabledNotifier, bool>(
  SoundEnabledNotifier.new,
);
