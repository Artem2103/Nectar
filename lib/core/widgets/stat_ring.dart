import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A circular progress ring with content centred inside it.
///
/// Recurs throughout the Home stat cards (`Nectar.pdf`): the calories flame, the
/// macro emoji and the steps figure all sit inside one of these rings. The ring
/// is a light [track] circle with an optional [progress] arc drawn over it, so
/// the same widget covers both the empty placeholder state (progress `0`) and a
/// filled metric later on.
class StatRing extends StatelessWidget {
  const StatRing({
    required this.size,
    required this.child,
    this.progress = 0,
    this.strokeWidth = 6,
    this.trackColor = AppColors.track,
    this.progressColor = AppColors.accent,
    super.key,
  }) : assert(progress >= 0 && progress <= 1, 'progress must be 0..1');

  /// Outer diameter of the ring.
  final double size;

  /// Fraction of the ring filled by the [progressColor] arc, `0`–`1`.
  final double progress;

  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  /// Centred content (icon, emoji or image).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress,
          strokeWidth: strokeWidth,
          trackColor: trackColor,
          progressColor: progressColor,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = progressColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // start at 12 o'clock
      2 * math.pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.strokeWidth != strokeWidth ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}
