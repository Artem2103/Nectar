import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../meals/application/meal_provider.dart';
import '../../meals/domain/meal_entry.dart';
import '../../meals/presentation/widgets/meal_card.dart';
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
    final summaryAsync = ref.watch(dailySummaryProvider);

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
            summaryAsync.when(
              loading: () => const _CarouselPlaceholder(),
              error: (e, _) => _CarouselError(message: '$e'),
              data: (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CalendarStrip(days: summary.week),
                  const SizedBox(height: AppSpacing.xl),
                  NutritionCarousel(summary: summary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const SectionTitle('Recently uploaded'),
            const SizedBox(height: AppSpacing.lg),
            const _RecentlyUploaded(),
          ],
        ),
      ),
    );
  }
}

/// Fixed-height loading state standing in for the calendar + carousel block.
class _CarouselPlaceholder extends StatelessWidget {
  const _CarouselPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 360,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

/// Error state for the calendar + carousel block.
class _CarouselError extends StatelessWidget {
  const _CarouselError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard.muted(
      child: Text(
        "Couldn't load your day: $message",
        style: AppTypography.label,
      ),
    );
  }
}

/// Today's logged meals, newest first — or the empty-state prompt when none
/// have been added yet.
class _RecentlyUploaded extends ConsumerWidget {
  const _RecentlyUploaded();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealRepositoryProvider);
    return mealsAsync.when(
      loading: () => const _RecentlyUploadedEmpty(),
      error: (_, _) => const _RecentlyUploadedEmpty(),
      data: (meals) {
        final now = DateTime.now();
        final todayMeals = meals
            .where((m) =>
                m.timestamp.year == now.year &&
                m.timestamp.month == now.month &&
                m.timestamp.day == now.day)
            .toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
        if (todayMeals.isEmpty) return const _RecentlyUploadedEmpty();
        return _MealList(meals: todayMeals);
      },
    );
  }
}

/// A vertical list of [MealCard]s with consistent spacing between them.
class _MealList extends StatelessWidget {
  const _MealList({required this.meals});

  final List<MealEntry> meals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < meals.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          MealCard(meal: meals[i]),
        ],
      ],
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
