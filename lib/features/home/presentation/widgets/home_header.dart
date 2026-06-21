import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Home top bar: the Nectar wordmark on the left and the day-streak pill on the
/// right, as shown across every Home page in `Nectar.pdf`.
class HomeHeader extends StatelessWidget {
  const HomeHeader({this.streakDays = 0, super.key});

  /// Current consecutive-day streak shown in the pill.
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Wordmark(),
        _StreakPill(days: streakDays),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    // logo.png is the full brand lockup (glyph + "Nectar" wordmark), so it is
    // rendered on its own — no separate text label is needed.
    // The logo PNG (869x287) has ~127px of transparent padding on its left
    // edge. At height 60 that scales to ~26.5px, so the visible wordmark sits
    // inset from the widget's left edge. Shifting left by that amount lands the
    // logo's visible left edge exactly on the screen margin — i.e. flush with
    // the left edge of the "2000" calories card below it.
    return Transform.translate(
      offset: const Offset(-22, 0),
      child: Semantics(
        label: 'Nectar',
        image: true,
        child: Image.asset(
          AppAssets.logo,
          height: 60,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}

class _StreakPill extends StatelessWidget {
  const _StreakPill({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$days day streak',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.pillAll,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 16)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$days',
              style: AppTypography.titleMedium.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
