import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Backend credentials are injected at build time via --dart-define so no
  // secrets live in the repo.
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError(
      'Missing Supabase credentials. Launch with '
      '--dart-define-from-file=supabase_env.json '
      '(or use the "Nectar (Supabase)" run configuration).',
    );
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // ProviderScope hosts all Riverpod state for the app; feature providers are
  // registered lazily from within their own feature folders.
  runApp(const ProviderScope(child: NectarApp()));
}
