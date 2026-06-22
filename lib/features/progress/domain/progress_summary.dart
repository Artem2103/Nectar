import 'badge_definition.dart';

/// Immutable snapshot of everything the Progress screen displays.
///
/// Mirrors `DailySummary` on Home: kept free of UI concerns so it can later be
/// produced by a repository / backend. For the MVP it is hydrated with the
/// placeholder figures from `Nectar.pdf` via [ProgressSummary.placeholder].
class ProgressSummary {
  const ProgressSummary({
    required this.dayStreak,
    required this.streakWeek,
    required this.earnedBadgeIds,
    required this.startWeight,
    required this.currentWeight,
    required this.goalWeight,
    required this.weightUnit,
    required this.weightTrend,
    required this.goalProgressPercent,
  });

  /// Current consecutive-day logging streak.
  final int dayStreak;

  /// Seven cells (Sun–Sat) describing which days of this week are completed.
  final List<StreakDay> streakWeek;

  /// Ids of the badges the user has unlocked (see `badge_definition.dart`).
  final Set<String> earnedBadgeIds;

  int get badgesEarned => earnedBadgeIds.length;
  int get badgesTotal => kAllBadges.length;

  // ── Weight journey ─────────────────────────────────────────────────────────
  final double startWeight;
  final double currentWeight;
  final double goalWeight;

  /// Display unit for every weight figure, e.g. `kg`.
  final String weightUnit;

  /// Recorded weigh-ins driving the chart, oldest → newest, in [weightUnit].
  final List<double> weightTrend;

  /// Progress toward the goal over the charted window, as a whole percentage.
  final int goalProgressPercent;

  /// Fraction (0–1) of the journey from [startWeight] to [goalWeight] already
  /// covered by [currentWeight]. Guards a zero-length goal range.
  double get weightProgress {
    final span = startWeight - goalWeight;
    if (span == 0) return 0;
    return ((startWeight - currentWeight) / span).clamp(0.0, 1.0);
  }

  /// Placeholder data matching the design. Static MVP values stand in until real
  /// weight tracking is wired in through this single provider seam.
  factory ProgressSummary.placeholder() {
    return ProgressSummary(
      dayStreak: 1,
      streakWeek: const [
        StreakDay(label: 'S', completed: false),
        StreakDay(label: 'M', completed: true),
        StreakDay(label: 'T', completed: false),
        StreakDay(label: 'W', completed: false),
        StreakDay(label: 'T', completed: false),
        StreakDay(label: 'F', completed: false),
        StreakDay(label: 'S', completed: false),
      ],
      earnedBadgeIds: const {'first_meal'},
      startWeight: 85,
      currentWeight: 74,
      goalWeight: 70,
      weightUnit: 'kg',
      weightTrend: _placeholderTrend(),
      goalProgressPercent: 0,
    );
  }

  /// A gently easing line that hovers near the current weight, reading as the
  /// near-flat trace in the design until real weigh-ins are recorded.
  static List<double> _placeholderTrend() {
    return List<double>.generate(24, (i) => 76 - (i / 23) * 2); // 76 → 74
  }
}

/// A single day in the weekly streak strip.
class StreakDay {
  const StreakDay({required this.label, required this.completed});

  /// Single-letter weekday initial, e.g. `M`.
  final String label;

  /// Whether the user logged a meal on this day.
  final bool completed;
}

/// Selectable time window for the weight chart.
enum ChartRange {
  d30('30D'),
  m6('6M'),
  y1('1Y'),
  all('ALL');

  const ChartRange(this.label);

  /// Short label shown inside the segmented control.
  final String label;
}
