/// A single weigh-in recorded by the user.
///
/// Pure data with hand-written JSON. The legacy `toJson`/`fromJson` pair is kept
/// for backwards compatibility; the `toSupabaseJson`/`fromSupabaseJson` pair
/// mirrors the snake_case `weight_entries` table.
class WeightEntry {
  const WeightEntry({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.valueKg,
  });

  /// Stable UUID identifying this entry.
  final String id;

  /// Owning auth user.
  final String userId;

  /// When the weight was recorded.
  final DateTime timestamp;

  /// Recorded body weight in kilograms.
  final double valueKg;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'timestamp': timestamp.toIso8601String(),
        'valueKg': valueKg,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        id: json['id'] as String,
        userId: json['userId'] as String? ?? '',
        timestamp: DateTime.parse(json['timestamp'] as String),
        valueKg: (json['valueKg'] as num).toDouble(),
      );

  /// Row shape for the `weight_entries` table — snake_case keys matching the
  /// Supabase schema.
  Map<String, dynamic> toSupabaseJson() => {
        'id': id,
        'user_id': userId,
        'value_kg': valueKg,
        'logged_at': timestamp.toIso8601String(),
      };

  factory WeightEntry.fromSupabaseJson(Map<String, dynamic> json) => WeightEntry(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        timestamp: DateTime.parse(json['logged_at'] as String),
        valueKg: (json['value_kg'] as num).toDouble(),
      );
}
