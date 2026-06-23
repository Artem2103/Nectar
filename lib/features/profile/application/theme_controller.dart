import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/preferences_provider.dart';
import '../../auth/application/auth_provider.dart';
import 'settings_provider.dart';
import 'settings_repository.dart';

/// Drives `MaterialApp.themeMode`.
///
/// Seeds synchronously from the on-device cache so the first frame already shows
/// the user's chosen appearance, then adopts the authoritative value once
/// [settingsProvider] resolves (and reloads it whenever the session changes).
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Adopt the theme from settings whenever they load or change.
    ref.listen(settingsProvider, (_, next) {
      final mode = next.value?.themeMode;
      if (mode != null) state = mode;
    });
    // Reload settings — and therefore the theme — on sign in / sign out.
    ref.listen(authStateProvider, (_, _) => ref.invalidate(settingsProvider));

    final cached =
        SettingsRepository.readCache(ref.read(sharedPreferencesProvider));
    return cached?.themeMode ?? ThemeMode.system;
  }

  /// Updates the active theme and persists it through the settings repository.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final repo = ref.read(settingsProvider.notifier);
    await repo.updateSettings(repo.currentOrDefaults.copyWith(themeMode: mode));
  }
}

/// The active [ThemeMode] for the whole app. Watched by `MaterialApp`; changed
/// via `ref.read(themeControllerProvider.notifier).setThemeMode(...)`.
final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
