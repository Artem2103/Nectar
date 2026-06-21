import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/weight_entry.dart';

/// Owns the list of recorded weigh-ins: hydrates from SharedPreferences on build
/// and persists every mutation back as a JSON string.
class WeightRepository extends AsyncNotifier<List<WeightEntry>> {
  static const String _key = 'nectar_weights';

  @override
  Future<List<WeightEntry>> build() => load();

  /// Reads and decodes the persisted weigh-ins (empty list if none stored yet).
  Future<List<WeightEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => WeightEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Encodes and writes [entries] to SharedPreferences.
  Future<void> save(List<WeightEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  /// Appends [entry], persists, and publishes the new state.
  Future<void> addWeight(WeightEntry entry) async {
    final current = state.value ?? await load();
    final updated = [...current, entry];
    await save(updated);
    state = AsyncData(updated);
  }

  /// Every weigh-in sorted oldest → newest.
  List<WeightEntry> allEntries() {
    final entries = [...(state.value ?? const <WeightEntry>[])];
    entries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return entries;
  }
}
