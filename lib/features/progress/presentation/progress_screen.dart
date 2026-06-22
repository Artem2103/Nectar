import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/screen_title.dart';
import '../domain/progress_summary.dart';
import '../application/progress_provider.dart';
import 'widgets/badges_card.dart';
import 'widgets/current_weight_card.dart';
import 'widgets/log_weight_sheet.dart';
import 'widgets/streak_card.dart';
import 'widgets/weight_chart_card.dart';

/// The Progress tab: streak and badges summary, the current-weight journey, and
/// the weight-trend chart (`Nectar.pdf`).
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(progressSummaryProvider);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHPadding,
          AppSpacing.md,
          AppSpacing.screenHPadding,
          AppSpacing.bottomBarClearance,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenTitle('Progress'),
            const SizedBox(height: AppSpacing.xl),
            summaryAsync.when(
              loading: () => const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text(
                "Couldn't load your progress: $e",
                style: AppTypography.label,
              ),
              data: (summary) => _ProgressContent(summary: summary),
            ),
          ],
        ),
      ),
    );
  }
}

/// The populated Progress body, rendered once the summary has loaded.
class _ProgressContent extends ConsumerWidget {
  const _ProgressContent({required this.summary});

  final ProgressSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: StreakCard(week: summary.streakWeek)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: BadgesCard(earnedIds: summary.earnedBadgeIds),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CurrentWeightCard(
          summary: summary,
          onLogWeight: () => showLogWeightSheet(
            context,
            ref,
            currentWeight: summary.currentWeight,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        WeightChartCard(
          trend: summary.weightTrend,
          goalProgressPercent: summary.goalProgressPercent,
        ),
      ],
    );
  }
}
