import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meals/application/meal_provider.dart';
import '../../profile/application/goals_provider.dart';
import '../../profile/application/settings_provider.dart';
import '../../profile/domain/app_settings.dart';
import '../domain/badge_definition.dart';
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
  // Display unit only — weights are stored in kg and converted at the seam here
  // so every weight figure on the Progress screen honours the Units setting.
  final units = ref.watch(settingsProvider).value?.units ?? UnitSystem.metric;

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
          final startKg = goals.startWeightKg;
          final goalKg = goals.goalWeightKg;
          final currentKg =
              sortedWeights.isEmpty ? startKg : sortedWeights.last.valueKg;

          final span = startKg - goalKg;
          final goalProgress = span == 0
              ? 0
              : ((startKg - currentKg) / span * 100).clamp(0, 100).round();

          // Distinct calendar days with a logged meal, built once so the streak
          // helpers do O(1) lookups instead of rescanning every meal per day.
          final loggedDays = {for (final m in meals) _dayKey(m.timestamp)};
          final dayStreak = _dayStreak(loggedDays);

          return AsyncValue.data(ProgressSummary(
            dayStreak: dayStreak,
            streakWeek: _streakWeek(loggedDays),
            earnedBadgeIds: computeEarnedBadgeIds(
              meals,
              weights,
              goals,
              dayStreak,
            ),
            startWeight: units.weightFromKg(startKg),
            currentWeight: units.weightFromKg(currentKg),
            goalWeight: units.weightFromKg(goalKg),
            weightUnit: units.weightLabel,
            weightTrend: _weightTrend(sortedWeights, units),
            goalProgressPercent: goalProgress,
          ));
        },
      ),
    ),
  );
});

/// A stable per-calendar-day key (`yyyymmdd`) used to test meal presence without
/// re-walking the meal list.
int _dayKey(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

/// Consecutive days (ending today) with at least one logged meal. Today is
/// allowed to be empty without breaking the streak — a fresh day shouldn't read
/// as a missed one before the first meal is logged.
int _dayStreak(Set<int> loggedDays) {
  final today = DateTime.now();
  var cursor = DateTime(today.year, today.month, today.day);
  if (!loggedDays.contains(_dayKey(cursor))) {
    cursor = cursor.subtract(const Duration(days: 1));
  }
  var streak = 0;
  while (loggedDays.contains(_dayKey(cursor))) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

/// The seven cells of the current Sunday–Saturday week, flagged where a meal was
/// logged. Ordering matches the design's `S M T W T F S` strip.
List<StreakDay> _streakWeek(Set<int> loggedDays) {
  const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final today = DateTime.now();
  final midnight = DateTime(today.year, today.month, today.day);
  // weekday: Mon=1..Sun=7; map to days since Sunday (Sun=0..Sat=6).
  final sunday = midnight.subtract(Duration(days: midnight.weekday % 7));
  return List.generate(7, (i) {
    final day = sunday.add(Duration(days: i));
    return StreakDay(label: labels[i], completed: loggedDays.contains(_dayKey(day)));
  });
}

/// Recorded weigh-ins as a chart-ready series (oldest → newest) in the active
/// display [units]. Falls back to the design placeholder when nothing is logged,
/// and flattens a single reading into two points so the chart always has a line
/// to draw.
List<double> _weightTrend(List<WeightEntry> sorted, UnitSystem units) {
  if (sorted.isEmpty) {
    return [
      for (final kg in ProgressSummary.placeholder().weightTrend)
        units.weightFromKg(kg),
    ];
  }
  final values = [for (final e in sorted) units.weightFromKg(e.valueKg)];
  if (values.length == 1) return [values.first, values.first];
  return values;
}
