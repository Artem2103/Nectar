import '../../../core/constants/app_assets.dart';

/// A single cell in the weekly calendar strip.
class CalendarDay {
  const CalendarDay({
    required this.label,
    required this.dayOfMonth,
    required this.isSelected,
  });

  /// Three-letter weekday label, e.g. `Mon`.
  final String label;

  /// Day-of-month number shown inside the ring.
  final int dayOfMonth;

  /// Whether this is the highlighted (current) day.
  final bool isSelected;
}

/// One macronutrient figure rendered as a mini stat card.
class MacroStat {
  const MacroStat({
    required this.label,
    required this.grams,
    required this.asset,
    this.progress = 0,
  });

  /// Supporting caption, e.g. `Proteins left`.
  final String label;

  /// Remaining amount in grams.
  final int grams;

  /// Icon artwork shown inside the ring (an [AppAssets] path).
  final String asset;

  /// Ring fill fraction, `0`–`1`.
  final double progress;
}

/// Immutable snapshot of everything the Home stat carousel displays for a day.
///
/// Kept free of UI concerns so it can later be produced by a repository /
/// backend; for the MVP it is hydrated with the placeholder figures from
/// `Nectar.pdf` via [DailySummary.placeholder].
class DailySummary {
  const DailySummary({
    required this.week,
    required this.caloriesLeft,
    required this.primaryMacros,
    required this.secondaryMacros,
    required this.healthScore,
    required this.healthScoreMax,
    required this.healthScoreNote,
    required this.steps,
    required this.stepsGoal,
    required this.caloriesBurned,
    required this.waterFlOz,
    required this.waterCups,
  });

  final List<CalendarDay> week;

  // Page 1 — energy + primary macros.
  final int caloriesLeft;
  final List<MacroStat> primaryMacros;

  // Page 2 — secondary macros + health score.
  final List<MacroStat> secondaryMacros;
  final int healthScore;
  final int healthScoreMax;
  final String healthScoreNote;

  // Page 3 — activity.
  final int steps;
  final int stepsGoal;
  final int caloriesBurned;
  final int waterFlOz;
  final int waterCups;

  /// Placeholder data matching the design. The week is computed from the real
  /// current date (Monday–Sunday, today highlighted); nutrition figures are the
  /// static MVP values shown in `Nectar.pdf` until real tracking is wired in.
  factory DailySummary.placeholder({DateTime? today}) {
    return DailySummary(
      week: buildWeek(today ?? DateTime.now()),
      caloriesLeft: 2000,
      primaryMacros: const [
        MacroStat(label: 'Proteins left', grams: 60, asset: AppAssets.protein),
        MacroStat(label: 'Carbs left', grams: 90, asset: AppAssets.carbs),
        MacroStat(label: 'Fat left', grams: 30, asset: AppAssets.fat),
      ],
      secondaryMacros: const [
        MacroStat(label: 'Fiber left', grams: 25, asset: AppAssets.fiber),
        MacroStat(label: 'Sugar left', grams: 40, asset: AppAssets.sugar),
        MacroStat(label: 'Sodium left', grams: 15, asset: AppAssets.sodium),
      ],
      healthScore: 7,
      healthScoreMax: 10,
      healthScoreNote:
          "You're well below your calorie and protein goals — focus on "
          'increasing protein intake for better balance.',
      steps: 0,
      stepsGoal: 10000,
      caloriesBurned: 0,
      waterFlOz: 0,
      waterCups: 0,
    );
  }

  static const List<String> _weekdayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  /// Builds the Monday–Sunday calendar strip for the week containing [today],
  /// with the matching day flagged as selected.
  static List<CalendarDay> buildWeek(DateTime today) {
    // DateTime.weekday is Mon=1..Sun=7; rewind to this week's Monday.
    final monday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      return CalendarDay(
        label: _weekdayLabels[i],
        dayOfMonth: date.day,
        isSelected: date.day == today.day &&
            date.month == today.month &&
            date.year == today.year,
      );
    });
  }
}
