import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meals/application/meal_provider.dart';
import '../../meals/domain/meal_entry.dart';
import '../../profile/application/goals_provider.dart';
import '../domain/progress_summary.dart';
import '../domain/weight_entry.dart';
import 'weight_provider.dart';

/// Builds the [ProgressSummary] from logged weigh-ins, meals and goals.
///
/// Composes three async sources and surfaces a single [AsyncValue] so the
/// Progress screen renders loading / error / data uniformly.
final progressSummaryProvider = Provider<AsyncValue<ProgressSummary>>((ref) {
  final weightsAsync = ref.watch(weightRepositoryProvider);
  final mealsAsync = ref.watch(mealRepositoryProvider);
  final goalsAsync = ref.watch(goalsProvider);

  return weightsAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
    data: (weights) => mealsAsync.when(
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
      data: (meals) => goalsAsync.when(
        loading: () => const AsyncValue.loading(),
        error: (e, s) => AsyncValue.error(e, s),
        data: (goals) {
          final sortedWeights = [...weights]
            ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
          final start = goals.startWeightKg;
          final goal = goals.goalWeightKg;
          final current = sortedWeights.isEmpty
              ? start
              : sortedWeights.last.valueKg;

          final span = start - goal;
          final goalProgress = span == 0
              ? 0
              : ((start - current) / span * 100).clamp(0, 100).round();

          return AsyncValue.data(ProgressSummary(
            dayStreak: _dayStreak(meals),
            streakWeek: _streakWeek(meals),
            badgesEarned: _dayStreak(meals) >= 1 ? 1 : 0,
            badgesTotal: 3,
            startWeight: start,
            currentWeight: current,
            goalWeight: goal,
            weightUnit: 'kg',
            weightTrend: _weightTrend(sortedWeights),
            goalProgressPercent: goalProgress,
          ));
        },
      ),
    ),
  );
});

/// Whether [meals] contains an entry on the given calendar day.
bool _hasMealOn(List<MealEntry> meals, DateTime day) {
  return meals.any((m) =>
      m.timestamp.year == day.year &&
      m.timestamp.month == day.month &&
      m.timestamp.day == day.day);
}

/// Consecutive days (ending today) with at least one logged meal. Today is
/// allowed to be empty without breaking the streak — a fresh day shouldn't read
/// as a missed one before the first meal is logged.
int _dayStreak(List<MealEntry> meals) {
  final today = DateTime.now();
  var cursor = DateTime(today.year, today.month, today.day);
  if (!_hasMealOn(meals, cursor)) {
    cursor = cursor.subtract(const Duration(days: 1));
  }
  var streak = 0;
  while (_hasMealOn(meals, cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

/// The seven cells of the current Sunday–Saturday week, flagged where a meal was
/// logged. Ordering matches the design's `S M T W T F S` strip.
List<StreakDay> _streakWeek(List<MealEntry> meals) {
  const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final today = DateTime.now();
  final midnight = DateTime(today.year, today.month, today.day);
  // weekday: Mon=1..Sun=7; map to days since Sunday (Sun=0..Sat=6).
  final sunday = midnight.subtract(Duration(days: midnight.weekday % 7));
  return List.generate(7, (i) {
    final day = sunday.add(Duration(days: i));
    return StreakDay(label: labels[i], completed: _hasMealOn(meals, day));
  });
}

/// Recorded weigh-ins as a chart-ready series (oldest → newest). Falls back to
/// the design placeholder when nothing is logged, and flattens a single reading
/// into two points so the chart always has a line to draw.
List<double> _weightTrend(List<WeightEntry> sorted) {
  if (sorted.isEmpty) return ProgressSummary.placeholder().weightTrend;
  final values = sorted.map((e) => e.valueKg).toList();
  if (values.length == 1) return [values.first, values.first];
  return values;
}
