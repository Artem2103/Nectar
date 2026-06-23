import 'package:flutter/material.dart';

/// Centralised colour tokens for Nectar.
///
/// Values are sampled directly from the design source of truth (`Nectar.pdf`).
/// Nothing in the app should construct a [Color] inline — always reference a
/// token here so the palette stays consistent and is trivial to re-theme.
abstract final class AppColors {
  const AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  /// Primary accent — progress bars, positive trends, brand highlights.
  static const Color accent = Color(0xFF00C219);

  /// Streak / energy accent — fire indicators, active streak day.
  static const Color streak = Color(0xFFFF6D28);

  /// Water tracking accent.
  static const Color water = Color(0xFF50D2FF);

  // ── Surfaces ─────────────────────────────────────────────────────────────
  /// Warm off-white at the top of every screen; fades into [background].
  static const Color backgroundTop = Color(0xFFF6F1F2);

  /// Base background colour the gradient settles into.
  static const Color background = Color(0xFFFBFAFB);

  /// Card and elevated-surface colour.
  static const Color surface = Color(0xFFFFFFFF);

  /// Muted, recessed surface — empty states, segmented-control tracks.
  static const Color surfaceMuted = Color(0xFFEFEDF2);

  /// Inky surface — the floating action button and primary pill buttons.
  static const Color surfaceInverse = Color(0xFF111114);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Primary text — titles, big numbers.
  static const Color textPrimary = Color(0xFF111114);

  /// Secondary text — captions, supporting labels.
  static const Color textSecondary = Color(0xFF9A9AA0);

  /// Tertiary text — de-emphasised hints, skeleton placeholders.
  static const Color textTertiary = Color(0xFFBFBFC6);

  /// Text/icon colour drawn on top of [surfaceInverse] and [accent].
  static const Color onInverse = Color(0xFFFFFFFF);

  // ── Lines & fills ────────────────────────────────────────────────────────
  /// Hairline borders and dotted calendar rings.
  static const Color border = Color(0xFFE6E3EA);

  /// Neutral track behind progress rings and bars.
  static const Color track = Color(0xFFE8E6EC);

  /// Dark data line used by charts.
  static const Color chartLine = Color(0xFF3A3A3C);

  // ── Dark scheme ──────────────────────────────────────────────────────────
  // Dark tokens consumed by [AppTheme.dark] and resolved through [NectarColors]
  // so bespoke, token-driven widgets repaint correctly in dark mode.
  /// Warm-equivalent top of the dark background gradient.
  static const Color backgroundTopDark = Color(0xFF17171C);

  /// Dark base background.
  static const Color backgroundDark = Color(0xFF0E0E11);

  /// Dark card / elevated-surface colour.
  static const Color surfaceDark = Color(0xFF1A1A1F);

  /// Dark muted, recessed surface.
  static const Color surfaceMutedDark = Color(0xFF222228);

  /// Light surface used for inverse elements (FAB, primary pills) on dark.
  static const Color surfaceInverseDark = Color(0xFFF5F5F7);

  /// Primary text on dark surfaces.
  static const Color textPrimaryDark = Color(0xFFF5F5F7);

  /// Text/icon colour drawn on top of [surfaceInverseDark].
  static const Color onInverseDark = Color(0xFF111114);

  /// Hairline borders and neutral tracks on dark surfaces.
  static const Color borderDark = Color(0xFF2C2C33);

  /// Neutral track behind progress rings and bars on dark surfaces.
  static const Color trackDark = Color(0xFF33333B);

  /// Light data line used by charts on dark surfaces.
  static const Color chartLineDark = Color(0xFFD4D4D8);

  // ── Decorative ───────────────────────────────────────────────────────────
  /// Soft gradient pair behind the maintenance illustration.
  static const Color illustrationGlowStart = Color(0xFFFFEAEF);
  static const Color illustrationGlowEnd = Color(0xFFCDD1DC);

  /// Ambient shadow colour for elevated cards (applied at low opacity).
  static const Color shadow = Color(0xFF1A1A2E);
}
