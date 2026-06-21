/// A single weigh-in recorded by the user.
///
/// Pure data with hand-written JSON so the weight repository can persist a list
/// as a JSON string in SharedPreferences.
class WeightEntry {
  const WeightEntry({
    required this.id,
    required this.timestamp,
    required this.valueKg,
  });

  /// Stable UUID identifying this entry.
  final String id;

  /// When the weight was recorded.
  final DateTime timestamp;

  /// Recorded body weight in kilograms.
  final double valueKg;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'valueKg': valueKg,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        valueKg: (json['valueKg'] as num).toDouble(),
      );
}
