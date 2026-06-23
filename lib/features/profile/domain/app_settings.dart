import 'package:flutter/material.dart';

/// Measurement system the app uses when displaying weights and volumes.
enum UnitSystem {
  /// Kilograms, millilitres — the app default.
  metric,

  /// Pounds, fluid ounces.
  imperial;

  /// Round-trips through the persisted [name]; falls back to [metric].
  static UnitSystem fromName(String? name) =>
      UnitSystem.values.firstWhere((u) => u.name == name, orElse: () => metric);

  /// Kilograms in one pound — the single source of truth for weight conversion.
  static const double _lbPerKg = 2.2046226218;

  /// Short suffix shown after a weight figure in this system (`kg` / `lb`).
  String get weightLabel => this == imperial ? 'lb' : 'kg';

  /// Converts a canonical kilogram value into this system's display unit.
  /// Weights are always stored in kilograms; this is display-only.
  double weightFromKg(double kg) => this == imperial ? kg * _lbPerKg : kg;

  /// Converts a value the user entered in this system's display unit back to the
  /// canonical kilograms used for storage.
  double weightToKg(double value) => this == imperial ? value / _lbPerKg : value;
}

/// The user's app-wide preferences (appearance, units, notifications).
///
/// Pure data with hand-written JSON. Two serialisations are provided: camelCase
/// [toJson]/[fromJson] for the on-device SharedPreferences cache, and snake_case
/// [toSupabaseJson]/[fromSupabaseJson] for the `user_settings` row. [themeMode]
/// is stored by its [ThemeMode.name] (`system` / `light` / `dark`).
class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.units,
    required this.mealReminders,
    required this.weighInReminders,
    required this.streakNudges,
  });

  final ThemeMode themeMode;
  final UnitSystem units;
  final bool mealReminders;
  final bool weighInReminders;
  final bool streakNudges;

  /// Sensible defaults used until the user customises their preferences.
  factory AppSettings.defaults() => const AppSettings(
        themeMode: ThemeMode.system,
        units: UnitSystem.metric,
        mealReminders: true,
        weighInReminders: true,
        streakNudges: true,
      );

  AppSettings copyWith({
    ThemeMode? themeMode,
    UnitSystem? units,
    bool? mealReminders,
    bool? weighInReminders,
    bool? streakNudges,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        units: units ?? this.units,
        mealReminders: mealReminders ?? this.mealReminders,
        weighInReminders: weighInReminders ?? this.weighInReminders,
        streakNudges: streakNudges ?? this.streakNudges,
      );

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.name,
        'units': units.name,
        'mealReminders': mealReminders,
        'weighInReminders': weighInReminders,
        'streakNudges': streakNudges,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        themeMode: _themeModeFromName(json['themeMode'] as String?),
        units: UnitSystem.fromName(json['units'] as String?),
        mealReminders: json['mealReminders'] as bool? ?? true,
        weighInReminders: json['weighInReminders'] as bool? ?? true,
        streakNudges: json['streakNudges'] as bool? ?? true,
      );

  /// Row shape for the `user_settings` table — snake_case keys matching the
  /// Supabase schema. `user_id` is attached by the repository at write time.
  Map<String, dynamic> toSupabaseJson() => {
        'theme_mode': themeMode.name,
        'units': units.name,
        'meal_reminders': mealReminders,
        'weigh_in_reminders': weighInReminders,
        'streak_nudges': streakNudges,
      };

  factory AppSettings.fromSupabaseJson(Map<String, dynamic> json) => AppSettings(
        themeMode: _themeModeFromName(json['theme_mode'] as String?),
        units: UnitSystem.fromName(json['units'] as String?),
        mealReminders: json['meal_reminders'] as bool? ?? true,
        weighInReminders: json['weigh_in_reminders'] as bool? ?? true,
        streakNudges: json['streak_nudges'] as bool? ?? true,
      );

  static ThemeMode _themeModeFromName(String? name) => ThemeMode.values
      .firstWhere((m) => m.name == name, orElse: () => ThemeMode.system);
}
