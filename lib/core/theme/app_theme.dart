import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

/// Assembles the design tokens into a single Material 3 [ThemeData].
///
/// Material 3 is used as the foundation but heavily customised so stock widgets
/// inherit Nectar's palette and Inter typography by default. Bespoke surfaces
/// (cards, navigation) still read from the token classes directly.
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: AppColors.onInverse,
      secondary: AppColors.streak,
      onSecondary: AppColors.onInverse,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceMuted,
      outline: AppColors.border,
      outlineVariant: AppColors.track,
      error: Color(0xFFE5484D),
    );

    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlAll),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.surfaceInverse,
          foregroundColor: AppColors.onInverse,
          textStyle: AppTypography.titleMedium,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.pillAll),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: AppTypography.hero,
      headlineLarge: AppTypography.largeTitle,
      headlineMedium: AppTypography.statNumber,
      titleLarge: AppTypography.sectionTitle,
      titleMedium: AppTypography.titleMedium,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.body,
      labelLarge: AppTypography.label,
      labelMedium: AppTypography.caption,
    );
  }
}
