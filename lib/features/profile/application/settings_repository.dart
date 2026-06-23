import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/preferences_provider.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/app_settings.dart';

/// Owns the user's [AppSettings].
///
/// Supabase's `user_settings` row is the source of truth, mirrored into a
/// SharedPreferences cache so the last-known preferences (notably the theme) are
/// available instantly on launch and survive being offline. On build the remote
/// row wins; if it can't be reached the cache is used, falling back to defaults.
class SettingsRepository extends AsyncNotifier<AppSettings> {
  static const _cacheKey = 'app_settings';

  String? get _uid => supabase.auth.currentUser?.id;
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  Future<AppSettings> build() => load();

  /// Reads the persisted settings: the remote row when signed in and reachable,
  /// otherwise the local cache, otherwise [AppSettings.defaults].
  Future<AppSettings> load() async {
    final uid = _uid;
    if (uid == null) return readCache(_prefs) ?? AppSettings.defaults();
    try {
      final row = await supabase
          .from('user_settings')
          .select()
          .eq('user_id', uid)
          .maybeSingle();
      final settings =
          row == null ? AppSettings.defaults() : AppSettings.fromSupabaseJson(row);
      await _writeCache(settings);
      return settings;
    } catch (_) {
      return readCache(_prefs) ?? AppSettings.defaults();
    }
  }

  /// Upserts [settings] for the current user, refreshes the cache and publishes
  /// them as the new state.
  Future<void> updateSettings(AppSettings settings) async {
    await _writeCache(settings);
    state = AsyncData(settings);
    final uid = _uid;
    if (uid == null) return;
    await supabase
        .from('user_settings')
        .upsert({...settings.toSupabaseJson(), 'user_id': uid});
  }

  /// The current settings, or the cached/default values while still loading.
  AppSettings get currentOrDefaults =>
      state.value ?? readCache(_prefs) ?? AppSettings.defaults();

  Future<void> _writeCache(AppSettings settings) =>
      _prefs.setString(_cacheKey, jsonEncode(settings.toJson()));

  /// Synchronously reads the cached settings, or `null` if none are stored yet.
  static AppSettings? readCache(SharedPreferences prefs) {
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return null;
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
