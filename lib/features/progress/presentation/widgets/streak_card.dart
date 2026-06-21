import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/progress_summary.dart';

/// Day-streak card: the flame above the "Day Streak" label and a row of the
/// week's days, with completed days marked by a filled accent dot (`Nectar.pdf`).
class StreakCard extends StatelessWidget {
  const StreakCard({required this.week, super.key});

  final List<StreakDay> week;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.fireStreak,
            width: 44,
            height: 44,
            excludeFromSemantics: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Day Streak', style: AppTypography.label),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final day in week) _StreakDot(day: day),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakDot extends StatelessWidget {
  const _StreakDot({required this.day});

  final StreakDay day;

  static const double _size = 16;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          day.label,
          style: AppTypography.caption.copyWith(fontSize: 11),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: day.completed ? AppColors.streak : AppColors.track,
          ),
          child: day.completed
              ? const Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: AppColors.onInverse,
                )
              : null,
        ),
      ],
    );
  }
}
