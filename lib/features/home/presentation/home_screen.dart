import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../application/daily_summary_provider.dart';
import 'widgets/calendar_strip.dart';
import 'widgets/home_header.dart';
import 'widgets/nutrition_carousel.dart';

/// The Home tab: header, weekly calendar, the swipeable nutrition-stat carousel
/// (calories / macros / activity) and the "Recently uploaded" section.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider);

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
            const HomeHeader(),
            const SizedBox(height: AppSpacing.lg),
            CalendarStrip(days: summary.week),
            const SizedBox(height: AppSpacing.xl),
            NutritionCarousel(summary: summary),
            const SizedBox(height: AppSpacing.xxxl),
            const SectionTitle('Recently uploaded'),
            const SizedBox(height: AppSpacing.lg),
            const _RecentlyUploadedEmpty(),
          ],
        ),
      ),
    );
  }
}

/// Empty state prompting the first meal log, matching `Nectar.pdf`: a recessed
/// card holding a single skeleton meal row above a call-to-action caption.
class _RecentlyUploadedEmpty extends StatelessWidget {
  const _RecentlyUploadedEmpty();

  @override
  Widget build(BuildContext context) {
    return AppCard.muted(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const _SkeletonMealRow(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Tap + to add your first meal of the day',
            textAlign: TextAlign.center,
            style: AppTypography.label,
          ),
        ],
      ),
    );
  }
}

class _SkeletonMealRow extends StatelessWidget {
  const _SkeletonMealRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.lgAll,
      ),
      child: Row(
        children: [
          Image.asset(
            AppAssets.mealSalad,
            width: 40,
            height: 40,
            excludeFromSemantics: true,
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBar(widthFactor: 0.7),
                SizedBox(height: AppSpacing.sm),
                _SkeletonBar(widthFactor: 0.45),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single rounded grey placeholder bar.
class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: AppColors.track,
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),
    );
  }
}
