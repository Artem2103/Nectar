import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_settings.dart';
import 'settings_repository.dart';

/// The async-loaded [AppSettings].
///
/// Read with `ref.watch(settingsProvider)` and persist changes via
/// `ref.read(settingsProvider.notifier).updateSettings(...)`.
final settingsProvider = AsyncNotifierProvider<SettingsRepository, AppSettings>(
  SettingsRepository.new,
);
