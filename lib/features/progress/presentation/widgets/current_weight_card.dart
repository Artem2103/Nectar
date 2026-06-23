import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/nectar_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../../domain/progress_summary.dart';

/// Current-weight card: the live figure with a "Log weight" action, a progress
/// bar tracking the journey from the starting weight to the goal, and the two
/// anchor weights beneath it (`Nectar.pdf`).
class CurrentWeightCard extends StatelessWidget {
  const CurrentWeightCard({
    required this.summary,
    required this.onLogWeight,
    super.key,
  });

  final ProgressSummary summary;
  final VoidCallback onLogWeight;

  @override
  Widget build(BuildContext context) {
    final unit = summary.weightUnit;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Current Weight', style: AppTypography.label),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${_format(summary.currentWeight)} $unit',
                      style: AppTypography.statNumber.copyWith(fontSize: 30),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              PillButton(
                label: 'Log weight',
                icon: Icons.arrow_right_alt_rounded,
                onPressed: onLogWeight,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ProgressBar(fraction: summary.weightProgress),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Anchor(label: 'Start', value: '${_format(summary.startWeight)} $unit'),
              _Anchor(label: 'Goal', value: '${_format(summary.goalWeight)} $unit'),
            ],
          ),
        ],
      ),
    );
  }

  /// Drops a redundant trailing `.0` so whole weights read as `74`, not `74.0`.
  static String _format(double weight) {
    return weight == weight.truncateToDouble()
        ? weight.toStringAsFixed(0)
        : weight.toStringAsFixed(1);
  }
}

/// A muted "label:" caption followed by a bold weight value.
class _Anchor extends StatelessWidget {
  const _Anchor({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppTypography.label,
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: AppTypography.titleMedium.copyWith(
              color: context.colors.textPrimary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
