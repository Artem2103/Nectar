import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/meal_entry.dart';

/// Owns the list of logged meals: hydrates it from Supabase on build and writes
/// every mutation straight through to the `meal_entries` table.
///
/// Doubles as the feature's [AsyncNotifier] so widgets read the list (and react
/// to changes) through a single [mealRepositoryProvider] seam.
class MealRepository extends AsyncNotifier<List<MealEntry>> {
  String get _uid => supabase.auth.currentUser!.id;

  @override
  Future<List<MealEntry>> build() => load();

  /// Reads this user's meals, oldest → newest.
  Future<List<MealEntry>> load() async {
    final rows = await supabase
        .from('meal_entries')
        .select()
        .eq('user_id', _uid)
        .order('logged_at');
    return rows
        .map((e) => MealEntry.fromSupabaseJson(e))
        .toList();
  }

  /// Inserts (or updates) [entry] for the current user, then republishes state.
  Future<void> addMeal(MealEntry entry) async {
    await supabase
        .from('meal_entries')
        .upsert({...entry.toSupabaseJson(), 'user_id': _uid});
    final current = state.value ?? const <MealEntry>[];
    state = AsyncData([...current.where((m) => m.id != entry.id), entry]);
  }

  /// Removes the entry with [id], then republishes state.
  Future<void> deleteMeal(String id) async {
    await supabase
        .from('meal_entries')
        .delete()
        .eq('id', id)
        .eq('user_id', _uid);
    final current = state.value ?? const <MealEntry>[];
    state = AsyncData(current.where((m) => m.id != id).toList());
  }

  /// Entries logged on the current calendar day, newest first.
  List<MealEntry> todayEntries() {
    final now = DateTime.now();
    final today = (state.value ?? const <MealEntry>[])
        .where((m) =>
            m.timestamp.year == now.year &&
            m.timestamp.month == now.month &&
            m.timestamp.day == now.day)
        .toList();
    today.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return today;
  }
}
