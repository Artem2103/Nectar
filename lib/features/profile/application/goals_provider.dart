import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user_goals.dart';
import 'goals_repository.dart';

/// The async-loaded [UserGoals].
///
/// Read with `ref.watch(goalsProvider)` and persist changes via
/// `ref.read(goalsProvider.notifier).updateGoals(...)`.
final goalsProvider = AsyncNotifierProvider<GoalsRepository, UserGoals>(
  GoalsRepository.new,
);
