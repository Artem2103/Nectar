import '../../meals/domain/meal_entry.dart';
import '../../profile/domain/user_goals.dart';
import 'weight_entry.dart';

/// A single achievement the user can unlock. Pure metadata — whether it has been
/// earned is derived at read time by [computeEarnedBadgeIds].
class BadgeDefinition {
  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
  });

  final String id, title, description, iconEmoji;
}

/// The full catalogue of badges, shown (earned or greyed) in the badges dialog.
const kAllBadges = [
  BadgeDefinition(
      id: 'first_meal',
      title: 'First Bite',
      description: 'Log your first meal',
      iconEmoji: '🍽️'),
  BadgeDefinition(
      id: 'streak_3',
      title: 'On a Roll',
      description: '3-day logging streak',
      iconEmoji: '🔥'),
  BadgeDefinition(
      id: 'streak_7',
      title: 'Week Warrior',
      description: '7-day logging streak',
      iconEmoji: '⚡'),
  BadgeDefinition(
      id: 'first_weight',
      title: 'Scale Starter',
      description: 'Log your first weigh-in',
      iconEmoji: '⚖️'),
  BadgeDefinition(
      id: 'weight_5',
      title: 'Dedicated',
      description: 'Log weight 5 times',
      iconEmoji: '📊'),
  BadgeDefinition(
      id: 'goal_50',
      title: 'Halfway There',
      description: 'Reach 50% of your weight goal',
      iconEmoji: '🎯'),
];

/// Derives which badge ids the user has earned from their logged data.
Set<String> computeEarnedBadgeIds(
  List<MealEntry> meals,
  List<WeightEntry> weights,
  UserGoals goals,
  int dayStreak,
) {
  final e = <String>{};
  if (meals.isNotEmpty) e.add('first_meal');
  if (dayStreak >= 3) e.add('streak_3');
  if (dayStreak >= 7) e.add('streak_7');
  if (weights.isNotEmpty) e.add('first_weight');
  if (weights.length >= 5) e.add('weight_5');
  final span = goals.startWeightKg - goals.goalWeightKg;
  if (span > 0) {
    final sorted = [...weights]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final current =
        sorted.isEmpty ? goals.startWeightKg : sorted.last.valueKg;
    if ((goals.startWeightKg - current) / span >= 0.5) e.add('goal_50');
  }
  return e;
}
