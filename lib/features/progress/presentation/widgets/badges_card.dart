import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';

/// Badges card: the shield above the "Badges Earned" label and a row of pips
/// summarising how many badges have been unlocked (`Nectar.pdf`).
class BadgesCard extends StatelessWidget {
  const BadgesCard({required this.earned, required this.total, super.key});

  final int earned;
  final int total;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.badges,
            width: 56,
            height: 56,
            excludeFromSemantics: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Badges Earned', style: AppTypography.label),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < total; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                _BadgePip(earned: i < earned),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgePip extends StatelessWidget {
  const _BadgePip({required this.earned});

  final bool earned;

  static const double _size = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: earned ? AppColors.surfaceInverse : AppColors.surface,
        border: earned ? null : Border.all(color: AppColors.border, width: 1.5),
      ),
      child: earned
          ? const Icon(Icons.star_rounded, size: 10, color: AppColors.onInverse)
          : null,
    );
  }
}
