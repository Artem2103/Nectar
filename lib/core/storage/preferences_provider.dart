import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app's on-device key/value store, used as a fast local cache for
/// preferences so the correct theme is available on the very first frame.
///
/// [SharedPreferences.getInstance] is awaited once in `main` and the result is
/// injected here via a [ProviderScope] override, so the rest of the app can read
/// the cache synchronously. Reading it without that override throws.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  ),
);
