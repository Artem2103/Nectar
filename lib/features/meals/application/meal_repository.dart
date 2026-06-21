import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/meal_entry.dart';

/// Owns the list of logged meals: hydrates it from SharedPreferences on build
/// and persists every mutation back as a JSON string.
///
/// Doubles as the feature's [AsyncNotifier] so widgets read the list (and react
/// to changes) through a single [mealRepositoryProvider] seam.
class MealRepository extends AsyncNotifier<List<MealEntry>> {
  static const String _key = 'nectar_meals';

  @override
  Future<List<MealEntry>> build() => load();

  /// Reads and decodes the persisted meals (empty list if none stored yet).
  Future<List<MealEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => MealEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Encodes and writes [meals] to SharedPreferences.
  Future<void> save(List<MealEntry> meals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(meals.map((m) => m.toJson()).toList()),
    );
  }

  /// Appends [entry], persists, and publishes the new state.
  Future<void> addMeal(MealEntry entry) async {
    final current = state.value ?? await load();
    final updated = [...current, entry];
    await save(updated);
    state = AsyncData(updated);
  }

  /// Removes the entry with [id], persists, and publishes the new state.
  Future<void> deleteMeal(String id) async {
    final current = state.value ?? await load();
    final updated = current.where((m) => m.id != id).toList();
    await save(updated);
    state = AsyncData(updated);
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
