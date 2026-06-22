import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/user_goals.dart';

/// Owns the user's [UserGoals]: hydrates the single `user_goals` row from
/// Supabase on build and upserts changes back. Returns sensible defaults until
/// the user customises their targets.
class GoalsRepository extends AsyncNotifier<UserGoals> {
  String get _uid => supabase.auth.currentUser!.id;

  @override
  Future<UserGoals> build() => load();

  /// Reads the persisted goals row, or [UserGoals.defaults] if none exists yet.
  Future<UserGoals> load() async {
    final row = await supabase
        .from('user_goals')
        .select()
        .eq('user_id', _uid)
        .maybeSingle();
    if (row == null) return UserGoals.defaults();
    return UserGoals.fromSupabaseJson(row);
  }

  /// Upserts [goals] for the current user and publishes them as the new state.
  Future<void> updateGoals(UserGoals goals) async {
    await supabase
        .from('user_goals')
        .upsert({...goals.toSupabaseJson(), 'user_id': _uid});
    state = AsyncData(goals);
  }
}
