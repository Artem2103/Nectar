import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme-aware surface, text and line tokens.
///
/// [AppColors] holds the raw light/dark constants; the tokens that *flip*
/// between brightnesses are exposed here as a [ThemeExtension] so bespoke,
/// token-driven widgets resolve the right value via `context.colors` and
/// repaint automatically when the theme mode changes. Brand colours (accent,
/// streak, water) and the mid-grey secondary/tertiary text read well on both
/// brightnesses, so they stay as plain [AppColors] constants.
@immutable
class NectarColors extends ThemeExtension<NectarColors> {
  const NectarColors({
    required this.backgroundTop,
    required this.background,
    required this.backgroundBottom,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceInverse,
    required this.textPrimary,
    required this.onInverse,
    required this.border,
    required this.track,
    required this.chartLine,
  });

  /// Top of the screen background gradient.
  final Color backgroundTop;

  /// Middle settling colour of the background gradient.
  final Color background;

  /// Bottom of the background gradient.
  final Color backgroundBottom;

  /// Card and elevated-surface colour.
  final Color surface;

  /// Muted, recessed surface — empty states, segmented-control tracks.
  final Color surfaceMuted;

  /// Inky/light surface — FAB and primary pill buttons (contrasts the theme).
  final Color surfaceInverse;

  /// Primary text and icon colour.
  final Color textPrimary;

  /// Text/icon colour drawn on top of [surfaceInverse] and the accent.
  final Color onInverse;

  /// Hairline borders and dotted rings.
  final Color border;

  /// Neutral track behind progress rings and bars.
  final Color track;

  /// Data line used by charts.
  final Color chartLine;

  static const NectarColors light = NectarColors(
    backgroundTop: AppColors.backgroundTop,
    background: AppColors.background,
    backgroundBottom: AppColors.surface,
    surface: AppColors.surface,
    surfaceMuted: AppColors.surfaceMuted,
    surfaceInverse: AppColors.surfaceInverse,
    textPrimary: AppColors.textPrimary,
    onInverse: AppColors.onInverse,
    border: AppColors.border,
    track: AppColors.track,
    chartLine: AppColors.chartLine,
  );

  static const NectarColors dark = NectarColors(
    backgroundTop: AppColors.backgroundTopDark,
    background: AppColors.backgroundDark,
    backgroundBottom: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    surfaceMuted: AppColors.surfaceMutedDark,
    surfaceInverse: AppColors.surfaceInverseDark,
    textPrimary: AppColors.textPrimaryDark,
    onInverse: AppColors.onInverseDark,
    border: AppColors.borderDark,
    track: AppColors.trackDark,
    chartLine: AppColors.chartLineDark,
  );

  @override
  NectarColors copyWith({
    Color? backgroundTop,
    Color? background,
    Color? backgroundBottom,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceInverse,
    Color? textPrimary,
    Color? onInverse,
    Color? border,
    Color? track,
    Color? chartLine,
  }) =>
      NectarColors(
        backgroundTop: backgroundTop ?? this.backgroundTop,
        background: background ?? this.background,
        backgroundBottom: backgroundBottom ?? this.backgroundBottom,
        surface: surface ?? this.surface,
        surfaceMuted: surfaceMuted ?? this.surfaceMuted,
        surfaceInverse: surfaceInverse ?? this.surfaceInverse,
        textPrimary: textPrimary ?? this.textPrimary,
        onInverse: onInverse ?? this.onInverse,
        border: border ?? this.border,
        track: track ?? this.track,
        chartLine: chartLine ?? this.chartLine,
      );

  @override
  NectarColors lerp(covariant NectarColors? other, double t) {
    if (other == null) return this;
    return NectarColors(
      backgroundTop: Color.lerp(backgroundTop, other.backgroundTop, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundBottom:
          Color.lerp(backgroundBottom, other.backgroundBottom, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      onInverse: Color.lerp(onInverse, other.onInverse, t)!,
      border: Color.lerp(border, other.border, t)!,
      track: Color.lerp(track, other.track, t)!,
      chartLine: Color.lerp(chartLine, other.chartLine, t)!,
    );
  }
}

/// Convenient access to the active [NectarColors] from any widget.
extension NectarColorsX on BuildContext {
  NectarColors get colors =>
      Theme.of(this).extension<NectarColors>() ?? NectarColors.light;
}
