/// The user's daily nutrition targets and weight journey bounds.
///
/// Pure data with hand-written JSON so the goals repository can persist a single
/// instance as a JSON string in SharedPreferences.
class UserGoals {
  const UserGoals({
    required this.dailyKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.sugarG,
    required this.sodiumMg,
    required this.startWeightKg,
    required this.goalWeightKg,
  });

  final int dailyKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;

  /// Daily fibre target in grams.
  final double fiberG;

  /// Daily sugar limit in grams.
  final double sugarG;

  /// Daily sodium limit in milligrams.
  final double sodiumMg;

  final double startWeightKg;
  final double goalWeightKg;

  /// Sensible defaults used until the user customises their goals. The fibre,
  /// sugar and sodium figures mirror common daily reference values.
  factory UserGoals.defaults() => const UserGoals(
        dailyKcal: 2000,
        proteinG: 60,
        carbsG: 200,
        fatG: 65,
        fiberG: 30,
        sugarG: 50,
        sodiumMg: 2300,
        startWeightKg: 80,
        goalWeightKg: 70,
      );

  UserGoals copyWith({
    int? dailyKcal,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fiberG,
    double? sugarG,
    double? sodiumMg,
    double? startWeightKg,
    double? goalWeightKg,
  }) =>
      UserGoals(
        dailyKcal: dailyKcal ?? this.dailyKcal,
        proteinG: proteinG ?? this.proteinG,
        carbsG: carbsG ?? this.carbsG,
        fatG: fatG ?? this.fatG,
        fiberG: fiberG ?? this.fiberG,
        sugarG: sugarG ?? this.sugarG,
        sodiumMg: sodiumMg ?? this.sodiumMg,
        startWeightKg: startWeightKg ?? this.startWeightKg,
        goalWeightKg: goalWeightKg ?? this.goalWeightKg,
      );

  Map<String, dynamic> toJson() => {
        'dailyKcal': dailyKcal,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        'fiberG': fiberG,
        'sugarG': sugarG,
        'sodiumMg': sodiumMg,
        'startWeightKg': startWeightKg,
        'goalWeightKg': goalWeightKg,
      };

  factory UserGoals.fromJson(Map<String, dynamic> json) => UserGoals(
        dailyKcal: (json['dailyKcal'] as num).toInt(),
        proteinG: (json['proteinG'] as num).toDouble(),
        carbsG: (json['carbsG'] as num).toDouble(),
        fatG: (json['fatG'] as num).toDouble(),
        fiberG: (json['fiberG'] as num?)?.toDouble() ?? 30,
        sugarG: (json['sugarG'] as num?)?.toDouble() ?? 50,
        sodiumMg: (json['sodiumMg'] as num?)?.toDouble() ?? 2300,
        startWeightKg: (json['startWeightKg'] as num).toDouble(),
        goalWeightKg: (json['goalWeightKg'] as num).toDouble(),
      );

  /// Row shape for the `user_goals` table — snake_case keys matching the
  /// Supabase schema. `user_id` is attached by the repository at write time.
  Map<String, dynamic> toSupabaseJson() => {
        'daily_kcal': dailyKcal,
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        'fiber_g': fiberG,
        'sugar_g': sugarG,
        'sodium_mg': sodiumMg,
        'start_weight_kg': startWeightKg,
        'goal_weight_kg': goalWeightKg,
      };

  factory UserGoals.fromSupabaseJson(Map<String, dynamic> json) => UserGoals(
        dailyKcal: (json['daily_kcal'] as num).toInt(),
        proteinG: (json['protein_g'] as num).toDouble(),
        carbsG: (json['carbs_g'] as num).toDouble(),
        fatG: (json['fat_g'] as num).toDouble(),
        fiberG: (json['fiber_g'] as num?)?.toDouble() ?? 30,
        sugarG: (json['sugar_g'] as num?)?.toDouble() ?? 50,
        sodiumMg: (json['sodium_mg'] as num?)?.toDouble() ?? 2300,
        startWeightKg: (json['start_weight_kg'] as num).toDouble(),
        goalWeightKg: (json['goal_weight_kg'] as num).toDouble(),
      );
}
