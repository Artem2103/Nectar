import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/nectar_colors.dart';
import '../../domain/daily_summary.dart';

/// The weekly day selector beneath the Home header (`Nectar.pdf`).
///
/// Seven evenly-spaced day cells: unselected days show their number inside a
/// dotted ring, while the current day is lifted onto a white rounded card with a
/// solid ring.
class CalendarStrip extends StatelessWidget {
  const CalendarStrip({required this.days, super.key});

  final List<CalendarDay> days;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final day in days) Expanded(child: _DayCell(day: day)),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day});

  final CalendarDay day;

  static const double _ringSize = 34;

  @override
  Widget build(BuildContext context) {
    final selected = day.isSelected;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          day.label,
          style: AppTypography.caption.copyWith(
            color: selected
                ? context.colors.textPrimary
                : AppColors.textSecondary,
            fontWeight:
                selected ? AppTypography.semiBold : AppTypography.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _DayNumber(number: day.dayOfMonth, selected: selected),
      ],
    );

    if (!selected) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: content,
      );
    }

    // Selected day floats on a white card that extends above and below the row.
    return Semantics(
      selected: true,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadii.lgAll,
          boxShadow: AppShadows.raised,
        ),
        child: content,
      ),
    );
  }
}

class _DayNumber extends StatelessWidget {
  const _DayNumber({required this.number, required this.selected});

  final int number;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _DayCell._ringSize,
      child: CustomPaint(
        painter: _DayRingPainter(
          dotted: !selected,
          ringColor: context.colors.border,
        ),
        child: Center(
          child: Text(
            '$number',
            style: AppTypography.caption.copyWith(
              color: context.colors.textPrimary,
              fontWeight: AppTypography.semiBold,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}

/// Draws the ring around a day number: a ring of small dots for unselected days,
/// or a solid hairline circle for the selected day.
class _DayRingPainter extends CustomPainter {
  const _DayRingPainter({required this.dotted, required this.ringColor});

  final bool dotted;
  final Color ringColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 1;

    if (!dotted) {
      final solid = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = ringColor;
      canvas.drawCircle(center, radius, solid);
      return;
    }

    const dotCount = 26;
    final dot = Paint()
      ..style = PaintingStyle.fill
      ..color = ringColor;
    for (var i = 0; i < dotCount; i++) {
      final angle = (2 * math.pi / dotCount) * i;
      final offset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(offset, 1, dot);
    }
  }

  @override
  bool shouldRepaint(_DayRingPainter old) =>
      old.dotted != dotted || old.ringColor != ringColor;
}
