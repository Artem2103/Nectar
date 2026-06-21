import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typographic scale for Nectar, built on the Inter typeface.
///
/// Sizes and weights are matched to `Nectar.pdf`. These styles are assembled
/// into a [TextTheme] in `app_theme.dart`; the named getters here are exposed
/// for the handful of bespoke, oversized numerals the design calls for (e.g.
/// the "2000 calories" hero) that fall outside the standard Material slots.
abstract final class AppTypography {
  const AppTypography._();

  /// The bundled variable font family (see pubspec.yaml).
  static const String fontFamily = 'Inter';

  // Weight aliases keep intent readable at call sites.
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.2,
  );

  /// Oversized hero numeral — the "2000" calories figure.
  static TextStyle get hero => _base.copyWith(
        fontSize: 64,
        fontWeight: extraBold,
        letterSpacing: -1.5,
        height: 1.0,
      );

  /// Large screen title — "Progress", "Profile".
  static TextStyle get largeTitle => _base.copyWith(
        fontSize: 34,
        fontWeight: bold,
        letterSpacing: -0.8,
      );

  /// Prominent numeral inside a card — "74 kg", "60g".
  static TextStyle get statNumber => _base.copyWith(
        fontSize: 30,
        fontWeight: bold,
        letterSpacing: -0.6,
      );

  /// Section heading — "Recently uploaded", "Weight Progress".
  static TextStyle get sectionTitle => _base.copyWith(
        fontSize: 22,
        fontWeight: bold,
        letterSpacing: -0.4,
      );

  /// Default emphasised body — card titles, button labels.
  static TextStyle get titleMedium => _base.copyWith(
        fontSize: 17,
        fontWeight: semiBold,
        letterSpacing: -0.2,
      );

  /// Standard body copy.
  static TextStyle get body => _base.copyWith(
        fontSize: 15,
        fontWeight: regular,
        height: 1.35,
      );

  /// Supporting label — "Calories left", "Proteins left".
  static TextStyle get label => _base.copyWith(
        fontSize: 14,
        fontWeight: medium,
        color: AppColors.textSecondary,
        letterSpacing: -0.1,
      );

  /// Smallest text — navigation labels, pill captions.
  static TextStyle get caption => _base.copyWith(
        fontSize: 12,
        fontWeight: medium,
        color: AppColors.textSecondary,
        letterSpacing: 0,
      );
}
