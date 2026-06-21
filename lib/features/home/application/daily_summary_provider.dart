import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../meals/application/meal_provider.dart';
import '../../meals/domain/meal_entry.dart';
import '../../profile/application/goals_provider.dart';
import '../../profile/domain/user_goals.dart';
import '../domain/daily_summary.dart';

/// Recommended daily targets for the secondary micronutrients. These aren't part
/// of [UserGoals] yet, so reasonable fixed references stand in for the "left"
/// figures on the carousel's second page.
const double _fiberGoalG = 30;
const double _sugarGoalG = 50;
const double _sodiumGoalMg = 2300;

/// Running totals consumed across a set of meals.
typedef _Consumed = ({
  int kcal,
  double proteinG,
  double carbsG,
  double fatG,
  double fiberG,
  double sugarG,
  double sodiumMg,
});

/// Builds the [DailySummary] for today from logged meals and the user's goals.
///
/// Composes the two async sources (meals + goals) and surfaces a single
/// [AsyncValue] so the Home screen renders loading / error / data uniformly.
final dailySummaryProvider = Provider<AsyncValue<DailySummary>>((ref) {
  final mealsAsync = ref.watch(mealRepositoryProvider);
  final goalsAsync = ref.watch(goalsProvider);
  return mealsAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
    data: (meals) => goalsAsync.when(
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
      data: (goals) {
        final today = DateTime.now();
        final todayMeals = meals
            .where((m) =>
                m.timestamp.year == today.year &&
                m.timestamp.month == today.month &&
                m.timestamp.day == today.day)
            .toList();
        final consumed = _sumMacros(todayMeals);
        return AsyncValue.data(DailySummary(
          week: DailySummary.buildWeek(today),
          caloriesLeft:
              (goals.dailyKcal - consumed.kcal).clamp(0, goals.dailyKcal),
          primaryMacros: [
            MacroStat(
              label: 'Protein left',
              grams: (goals.proteinG - consumed.proteinG)
                  .round()
                  .clamp(0, goals.proteinG.round()),
              asset: AppAssets.protein,
              progress: (consumed.proteinG / goals.proteinG).clamp(0.0, 1.0),
            ),
            MacroStat(
              label: 'Carbs left',
              grams: (goals.carbsG - consumed.carbsG)
                  .round()
                  .clamp(0, goals.carbsG.round()),
              asset: AppAssets.carbs,
              progress: (consumed.carbsG / goals.carbsG).clamp(0.0, 1.0),
            ),
            MacroStat(
              label: 'Fat left',
              grams: (goals.fatG - consumed.fatG)
                  .round()
                  .clamp(0, goals.fatG.round()),
              asset: AppAssets.fat,
              progress: (consumed.fatG / goals.fatG).clamp(0.0, 1.0),
            ),
          ],
          secondaryMacros: [
            MacroStat(
              label: 'Fiber left',
              grams: (_fiberGoalG - consumed.fiberG)
                  .round()
                  .clamp(0, _fiberGoalG.round()),
              asset: AppAssets.fiber,
              progress: (consumed.fiberG / _fiberGoalG).clamp(0.0, 1.0),
            ),
            MacroStat(
              label: 'Sugar left',
              grams: (_sugarGoalG - consumed.sugarG)
                  .round()
                  .clamp(0, _sugarGoalG.round()),
              asset: AppAssets.sugar,
              progress: (consumed.sugarG / _sugarGoalG).clamp(0.0, 1.0),
            ),
            MacroStat(
              label: 'Sodium left',
              grams: (_sodiumGoalMg - consumed.sodiumMg)
                  .round()
                  .clamp(0, _sodiumGoalMg.round()),
              asset: AppAssets.sodium,
              progress: (consumed.sodiumMg / _sodiumGoalMg).clamp(0.0, 1.0),
            ),
          ],
          healthScore: _computeHealthScore(consumed, goals),
          healthScoreMax: 10,
          healthScoreNote: _healthNote(consumed, goals),
          steps: 0,
          stepsGoal: 10000,
          caloriesBurned: 0,
          waterFlOz: 0,
          waterCups: 0,
        ));
      },
    ),
  );
});

/// Folds the macro fields of [meals] into a single running total.
_Consumed _sumMacros(List<MealEntry> meals) {
  var kcal = 0;
  var protein = 0.0, carbs = 0.0, fat = 0.0, fiber = 0.0, sugar = 0.0;
  var sodium = 0.0;
  for (final m in meals) {
    kcal += m.kcal;
    protein += m.proteinG;
    carbs += m.carbsG;
    fat += m.fatG;
    fiber += m.fiberG;
    sugar += m.sugarG;
    sodium += m.sodiumMg;
  }
  return (
    kcal: kcal,
    proteinG: protein,
    carbsG: carbs,
    fatG: fat,
    fiberG: fiber,
    sugarG: sugar,
    sodiumMg: sodium,
  );
}

/// A 0–10 balance score: full marks when calories stay within goal and protein
/// is on track; penalised for overshooting calories or falling short on protein.
int _computeHealthScore(_Consumed consumed, UserGoals goals) {
  var score = 10.0;
  if (consumed.kcal > goals.dailyKcal) {
    final overshoot = (consumed.kcal - goals.dailyKcal) / goals.dailyKcal;
    score -= (overshoot * 10).clamp(0.0, 5.0);
  }
  final proteinRatio =
      goals.proteinG == 0 ? 1.0 : consumed.proteinG / goals.proteinG;
  if (proteinRatio < 1) {
    score -= ((1 - proteinRatio) * 5).clamp(0.0, 4.0);
  }
  return score.round().clamp(0, 10);
}

/// Short, actionable note paired with the health score.
String _healthNote(_Consumed consumed, UserGoals goals) {
  if (consumed.kcal == 0) {
    return 'No meals logged yet today — add one to start tracking your balance.';
  }
  if (consumed.kcal > goals.dailyKcal) {
    return "You're over your calorie goal for today — lighter choices from here "
        'will help you stay balanced.';
  }
  if (consumed.proteinG < goals.proteinG * 0.6) {
    return "You're well below your protein goal — focus on increasing protein "
        'intake for better balance.';
  }
  return "Nicely balanced so far — keep your remaining meals on the lighter side "
      'to stay within your goals.';
}
