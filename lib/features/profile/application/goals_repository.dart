import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/user_goals.dart';

/// Owns the user's [UserGoals]: hydrates from SharedPreferences on build and
/// persists changes back as a JSON string. Returns sensible defaults until the
/// user customises their targets.
class GoalsRepository extends AsyncNotifier<UserGoals> {
  static const String _key = 'nectar_goals';

  @override
  Future<UserGoals> build() => load();

  /// Reads the persisted goals, or [UserGoals.defaults] if none stored yet.
  Future<UserGoals> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return UserGoals.defaults();
    return UserGoals.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Persists [goals] and publishes them as the new state.
  Future<void> saveGoals(UserGoals goals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(goals.toJson()));
    state = AsyncData(goals);
  }
}
