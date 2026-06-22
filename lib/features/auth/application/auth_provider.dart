import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Streams Supabase auth-state changes (sign in, sign out, token refresh).
///
/// The router listens to the same underlying stream to drive redirects; widgets
/// can watch this provider when they need to react to the session directly.
final authStateProvider = StreamProvider<AuthState>(
  (ref) => Supabase.instance.client.auth.onAuthStateChange,
);
