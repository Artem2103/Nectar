import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/nectar_colors.dart';

/// A rounded linear progress indicator: a neutral [trackColor] rail overlaid
/// with a [color] fill spanning [fraction] (0–1) of its width.
///
/// Centralises the bar shape used by the weight journey (and available to any
/// future metric) so the rounding and fill behaviour live in one place.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.fraction,
    this.height = 10,
    this.color = AppColors.accent,
    this.trackColor,
    super.key,
  });

  /// Portion of the bar filled, clamped to 0–1.
  final double fraction;

  final double height;
  final Color color;

  /// Rail colour; resolves to the theme-aware [NectarColors.track] when null.
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Stack(
        children: [
          Container(height: height, color: trackColor ?? context.colors.track),
          FractionallySizedBox(
            widthFactor: fraction.clamp(0.0, 1.0),
            child: Container(height: height, color: color),
          ),
        ],
      ),
    );
  }
}
