import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_ring.dart';

/// Steps progress toward the daily goal, with a walking figure in the ring.
class StepsCard extends StatelessWidget {
  const StepsCard({required this.steps, required this.goal, super.key});

  final int steps;
  final int goal;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Steps', style: AppTypography.label),
          const SizedBox(height: AppSpacing.xxs),
          _ValueWithUnit(value: '$steps', unit: '/${_formatGoal(goal)}'),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: StatRing(
              size: 72,
              progress: goal == 0 ? 0 : (steps / goal).clamp(0.0, 1.0),
              child: const Icon(
                Icons.directions_walk_rounded,
                color: AppColors.textPrimary,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatGoal(int goal) {
    final digits = goal.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

/// Energy burned for the day, broken down by source.
class CaloriesBurnedCard extends StatelessWidget {
  const CaloriesBurnedCard({required this.calories, super.key});

  final int calories;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Calories burned', style: AppTypography.label),
          const SizedBox(height: AppSpacing.xxs),
          _ValueWithUnit(value: '$calories', unit: 'cal'),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Icon(
                Icons.directions_walk_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steps',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                  Text('$calories cal', style: AppTypography.caption),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Water intake for the day.
class WaterCard extends StatelessWidget {
  const WaterCard({required this.flOz, required this.cups, super.key});

  final int flOz;
  final int cups;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Image.asset(
            AppAssets.water,
            width: 36,
            height: 36,
            excludeFromSemantics: true,
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Water', style: AppTypography.label),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '$flOz fl oz ($cups cups)',
                style: AppTypography.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A bold metric followed by a muted unit on the same baseline.
class _ValueWithUnit extends StatelessWidget {
  const _ValueWithUnit({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value, style: AppTypography.statNumber),
        const SizedBox(width: AppSpacing.xxs),
        Text(unit, style: AppTypography.label),
      ],
    );
  }
}
