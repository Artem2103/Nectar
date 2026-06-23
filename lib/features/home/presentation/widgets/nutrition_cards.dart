import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_ring.dart';
import '../../domain/daily_summary.dart';

/// Hero energy card: the remaining calories beside a flame ring (`Nectar.pdf`).
class CaloriesCard extends StatelessWidget {
  const CaloriesCard({required this.caloriesLeft, super.key});

  final int caloriesLeft;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$caloriesLeft', style: AppTypography.hero),
                const SizedBox(height: AppSpacing.xs),
                Text('Calories left', style: AppTypography.label),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          const StatRing(
            size: 76,
            child: Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.textPrimary,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact macro card: remaining grams above a ring holding the macro icon.
/// Used six times across the carousel (protein/carbs/fat, fiber/sugar/sodium).
class MacroStatCard extends StatelessWidget {
  const MacroStatCard({required this.macro, super.key});

  final MacroStat macro;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${macro.grams}g', style: AppTypography.statNumber),
          const SizedBox(height: AppSpacing.xxs),
          Text(macro.label, style: AppTypography.caption),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: StatRing(
              size: 64,
              progress: macro.progress,
              child: Image.asset(
                macro.asset,
                width: 30,
                height: 30,
                excludeFromSemantics: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Daily health score with a green progress bar and a coaching note.
class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({
    required this.score,
    required this.max,
    required this.note,
    super.key,
  });

  final int score;
  final int max;
  final String note;

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTypography.titleMedium.copyWith(
      fontSize: 20,
      fontWeight: AppTypography.bold,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Health Score', style: titleStyle),
              Text('$score/$max', style: titleStyle),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ScoreBar(fraction: max == 0 ? 0 : score / max),
          const SizedBox(height: AppSpacing.lg),
          Text(
            note,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded track + accent fill for the health score.
class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.fraction});

  final double fraction;

  static const double _height = 10;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_height),
      child: Stack(
        children: [
          Container(height: _height, color: AppColors.track),
          FractionallySizedBox(
            widthFactor: fraction.clamp(0.0, 1.0),
            child: Container(height: _height, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
