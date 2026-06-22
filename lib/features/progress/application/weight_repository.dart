import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/weight_entry.dart';

/// Owns the list of recorded weigh-ins: hydrates from Supabase on build and
/// writes every mutation straight through to the `weight_entries` table.
class WeightRepository extends AsyncNotifier<List<WeightEntry>> {
  String get _uid => supabase.auth.currentUser!.id;

  @override
  Future<List<WeightEntry>> build() => load();

  /// Reads this user's weigh-ins, oldest → newest.
  Future<List<WeightEntry>> load() async {
    final rows = await supabase
        .from('weight_entries')
        .select()
        .eq('user_id', _uid)
        .order('logged_at');
    return rows
        .map((e) => WeightEntry.fromSupabaseJson(e))
        .toList();
  }

  /// Inserts (or updates) [entry] for the current user, then republishes state.
  Future<void> addWeight(WeightEntry entry) async {
    await supabase
        .from('weight_entries')
        .upsert({...entry.toSupabaseJson(), 'user_id': _uid});
    final current = state.value ?? const <WeightEntry>[];
    state = AsyncData([...current.where((e) => e.id != entry.id), entry]);
  }

  /// Every weigh-in sorted oldest → newest.
  List<WeightEntry> allEntries() {
    final entries = [...(state.value ?? const <WeightEntry>[])];
    entries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return entries;
  }
}
