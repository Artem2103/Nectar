/// A single logged meal and its nutrition breakdown.
///
/// Pure data: serialises to/from JSON by hand (no codegen) so the meal
/// repository can persist a list of entries as a JSON string.
class MealEntry {
  const MealEntry({
    required this.id,
    required this.timestamp,
    required this.name,
    required this.imagePath,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.fiberG = 0,
    this.sugarG = 0,
    this.sodiumMg = 0,
  });

  /// Stable UUID identifying this entry.
  final String id;

  /// When the meal was logged.
  final DateTime timestamp;

  final String name;

  /// Local file path to the captured photo, or `null` if added manually.
  final String? imagePath;

  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final double sugarG;
  final double sodiumMg;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'name': name,
        'imagePath': imagePath,
        'kcal': kcal,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        'fiberG': fiberG,
        'sugarG': sugarG,
        'sodiumMg': sodiumMg,
      };

  factory MealEntry.fromJson(Map<String, dynamic> json) => MealEntry(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        name: json['name'] as String,
        imagePath: json['imagePath'] as String?,
        kcal: (json['kcal'] as num).toInt(),
        proteinG: (json['proteinG'] as num).toDouble(),
        carbsG: (json['carbsG'] as num).toDouble(),
        fatG: (json['fatG'] as num).toDouble(),
        fiberG: (json['fiberG'] as num?)?.toDouble() ?? 0,
        sugarG: (json['sugarG'] as num?)?.toDouble() ?? 0,
        sodiumMg: (json['sodiumMg'] as num?)?.toDouble() ?? 0,
      );
}
