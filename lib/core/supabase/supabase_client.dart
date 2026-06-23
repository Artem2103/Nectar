import 'package:supabase_flutter/supabase_flutter.dart';

export 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, FileOptions;

/// Shorthand for the singleton Supabase client.
///
/// Every repository talks to the backend through this seam so the
/// `Supabase.instance.client` lookup is written once.
SupabaseClient get supabase => Supabase.instance.client;
