import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/progress_summary.dart';

/// Weight-progress card: a heading with a "% of goal" flag, the weight-trend
/// line chart, and a segmented control for the charted time window (`Nectar.pdf`).
class WeightChartCard extends StatefulWidget {
  const WeightChartCard({
    required this.trend,
    required this.goalProgressPercent,
    super.key,
  });

  /// Weigh-ins, oldest → newest, plotted on the chart.
  final List<double> trend;

  /// Whole-percentage progress shown in the flag pill.
  final int goalProgressPercent;

  @override
  State<WeightChartCard> createState() => _WeightChartCardState();
}

class _WeightChartCardState extends State<WeightChartCard> {
  ChartRange _range = ChartRange.all;

  static const double _chartHeight = 180;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Weight Progress',
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 20,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
              _GoalFlag(percent: widget.goalProgressPercent),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: _chartHeight,
            child: CustomPaint(
              painter: _WeightChartPainter(values: widget.trend),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _RangeSelector(
            value: _range,
            onChanged: (r) => setState(() => _range = r),
          ),
        ],
      ),
    );
  }
}

/// Muted pill pairing the flag glyph with a bold percentage toward the goal.
class _GoalFlag extends StatelessWidget {
  const _GoalFlag({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.flag,
            width: 14,
            height: 14,
            excludeFromSemantics: true,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text.rich(
            TextSpan(
              style: AppTypography.caption,
              children: [
                TextSpan(
                  text: '$percent% ',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const TextSpan(text: 'of goal'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill segmented control switching the charted time window.
class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.value, required this.onChanged});

  final ChartRange value;
  final ValueChanged<ChartRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.pillAll,
      ),
      child: Row(
        children: [
          for (final range in ChartRange.values)
            Expanded(
              child: _Segment(
                label: range.label,
                selected: range == value,
                onTap: () => onChanged(range),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: AppRadii.pillAll,
          boxShadow: selected ? AppShadows.raised : const [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight:
                selected ? AppTypography.semiBold : AppTypography.medium,
          ),
        ),
      ),
    );
  }
}

/// Paints the weight trend as a dark polyline over a horizontal grid. The scale
/// auto-fits the plotted values (with a little headroom) and labels four evenly
/// spaced rows down the right-hand gutter, so it reads correctly whatever the
/// weights or unit happen to be.
class _WeightChartPainter extends CustomPainter {
  const _WeightChartPainter({required this.values});

  final List<double> values;

  static const int _gridRows = 4; // labelled horizontal lines.
  static const double _gutter = 40; // right-hand space for the scale labels.
  static const double _vInset = 8; // keeps top/bottom labels off the edges.

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _gutter;
    final usableHeight = size.height - _vInset * 2;

    // Fit the vertical scale to the data with ~15% headroom so the trace never
    // hugs the top or bottom edge. A flat series gets a small symmetric band.
    var lo = values.isEmpty ? 0.0 : values.reduce((a, b) => a < b ? a : b);
    var hi = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    if (hi == lo) {
      lo -= 1;
      hi += 1;
    } else {
      final pad = (hi - lo) * 0.15;
      lo -= pad;
      hi += pad;
    }

    double yFor(double value) =>
        _vInset + usableHeight * (1 - (value - lo) / (hi - lo));

    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (var row = 0; row < _gridRows; row++) {
      final value = hi - (hi - lo) * row / (_gridRows - 1);
      final y = yFor(value);
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);

      final label = TextPainter(
        text: TextSpan(text: value.round().toString(), style: AppTypography.caption),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(
        canvas,
        Offset(size.width - label.width, y - label.height / 2),
      );
    }

    if (values.isEmpty) return;

    final linePaint = Paint()
      ..color = AppColors.chartLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? chartWidth / 2
          : chartWidth * i / (values.length - 1);
      final y = yFor(values[i]);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_WeightChartPainter old) =>
      !listEquals(old.values, values);
}
