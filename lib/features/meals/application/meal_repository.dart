import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/meal_entry.dart';

/// Owns the list of logged meals: hydrates it from Supabase on build and writes
/// every mutation straight through to the `meal_entries` table.
///
/// Doubles as the feature's [AsyncNotifier] so widgets read the list (and react
/// to changes) through a single [mealRepositoryProvider] seam.
class MealRepository extends AsyncNotifier<List<MealEntry>> {
  /// Public Supabase Storage bucket holding meal photos. Objects are keyed
  /// `<uid>/<mealId>.jpg` so a meal's photo is deterministically locatable.
  static const _imageBucket = 'meal_images';

  String get _uid => supabase.auth.currentUser!.id;

  String _imageObjectPath(String mealId) => '$_uid/$mealId.jpg';

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

  /// Uploads [file] as the photo for the meal [mealId] and returns its public
  /// URL. Overwrites any existing object so re-saving a meal is idempotent.
  Future<String> uploadImage(File file, String mealId) async {
    final path = _imageObjectPath(mealId);
    await supabase.storage.from(_imageBucket).upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
        );
    return supabase.storage.from(_imageBucket).getPublicUrl(path);
  }

  /// Removes the entry with [id], then republishes state. Also drops its photo
  /// from Storage (best-effort — a failed cleanup must not block the delete).
  Future<void> deleteMeal(String id) async {
    await supabase
        .from('meal_entries')
        .delete()
        .eq('id', id)
        .eq('user_id', _uid);
    try {
      await supabase.storage.from(_imageBucket).remove([_imageObjectPath(id)]);
    } catch (_) {
      // Photo may never have existed (manual entry) or already be gone.
    }
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
