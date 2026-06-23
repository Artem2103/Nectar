import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/nectar_colors.dart';
import '../../domain/daily_summary.dart';
import 'activity_cards.dart';
import 'nutrition_cards.dart';

/// The swipeable stack of nutrition / activity pages on Home (`Nectar.pdf`).
///
/// Three pages share a fixed height and are paged horizontally, with a dot
/// indicator beneath them:
///   1. calories + primary macros
///   2. secondary macros + health score
///   3. steps, calories burned and water
class NutritionCarousel extends StatefulWidget {
  const NutritionCarousel({required this.summary, super.key});

  final DailySummary summary;

  @override
  State<NutritionCarousel> createState() => _NutritionCarouselState();
}

class _NutritionCarouselState extends State<NutritionCarousel> {
  final PageController _controller = PageController();
  int _page = 0;

  /// Tall enough for the largest page; shorter pages top-align, leaving room for
  /// the card shadows so the viewport never clips them.
  static const double _pageHeight = 344;

  /// Half the gutter shown between adjacent pages while swiping. Applied
  /// symmetrically to every page so both neighbouring cards look identically
  /// inset and never touch.
  static const double _pageGutter = AppSpacing.sm;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final pages = <Widget>[
      _Page(children: [
        CaloriesCard(caloriesLeft: summary.caloriesLeft),
        const SizedBox(height: AppSpacing.md),
        _MacroRow(macros: summary.primaryMacros),
      ]),
      _Page(children: [
        _MacroRow(macros: summary.secondaryMacros),
        const SizedBox(height: AppSpacing.md),
        HealthScoreCard(
          score: summary.healthScore,
          max: summary.healthScoreMax,
          note: summary.healthScoreNote,
        ),
      ]),
      _Page(children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: StepsCard(
                steps: summary.steps,
                goal: summary.stepsGoal,
              )),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: CaloriesBurnedCard(
                calories: summary.caloriesBurned,
              )),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        WaterCard(flOz: summary.waterFlOz, cups: summary.waterCups),
      ]),
    ];

    return Column(
      children: [
        SizedBox(
          height: _pageHeight,
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            children: pages,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _DotsIndicator(count: pages.length, activeIndex: _page),
      ],
    );
  }
}

/// A single carousel page: top-aligned content so card shadows are not clipped,
/// inset by [_NutritionCarouselState._pageGutter] on each side so neighbouring
/// pages keep a symmetric gutter and never touch while swiping.
class _Page extends StatelessWidget {
  const _Page({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _NutritionCarouselState._pageGutter,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

/// A row of equal-width macro cards.
class _MacroRow extends StatelessWidget {
  const _MacroRow({required this.macros});

  final List<MacroStat> macros;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < macros.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            Expanded(child: MacroStatCard(macro: macros[i])),
          ],
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            width: i == activeIndex ? 8 : 6,
            height: i == activeIndex ? 8 : 6,
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? context.colors.textPrimary
                  : context.colors.track,
              borderRadius: AppRadii.pillAll,
            ),
          ),
      ],
    );
  }
}
