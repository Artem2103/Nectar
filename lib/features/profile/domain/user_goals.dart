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
    required this.startWeightKg,
    required this.goalWeightKg,
  });

  final int dailyKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double startWeightKg;
  final double goalWeightKg;

  /// Sensible defaults used until the user customises their goals.
  factory UserGoals.defaults() => const UserGoals(
        dailyKcal: 2000,
        proteinG: 60,
        carbsG: 200,
        fatG: 65,
        startWeightKg: 80,
        goalWeightKg: 70,
      );

  UserGoals copyWith({
    int? dailyKcal,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? startWeightKg,
    double? goalWeightKg,
  }) =>
      UserGoals(
        dailyKcal: dailyKcal ?? this.dailyKcal,
        proteinG: proteinG ?? this.proteinG,
        carbsG: carbsG ?? this.carbsG,
        fatG: fatG ?? this.fatG,
        startWeightKg: startWeightKg ?? this.startWeightKg,
        goalWeightKg: goalWeightKg ?? this.goalWeightKg,
      );

  Map<String, dynamic> toJson() => {
        'dailyKcal': dailyKcal,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        'startWeightKg': startWeightKg,
        'goalWeightKg': goalWeightKg,
      };

  factory UserGoals.fromJson(Map<String, dynamic> json) => UserGoals(
        dailyKcal: (json['dailyKcal'] as num).toInt(),
        proteinG: (json['proteinG'] as num).toDouble(),
        carbsG: (json['carbsG'] as num).toDouble(),
        fatG: (json['fatG'] as num).toDouble(),
        startWeightKg: (json['startWeightKg'] as num).toDouble(),
        goalWeightKg: (json['goalWeightKg'] as num).toDouble(),
      );
}
