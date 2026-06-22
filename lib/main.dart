import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Backend credentials are injected at build time via --dart-define so no
  // secrets live in the repo.
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  // ProviderScope hosts all Riverpod state for the app; feature providers are
  // registered lazily from within their own feature folders.
  runApp(const ProviderScope(child: NectarApp()));
}
