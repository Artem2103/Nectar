/// Spacing scale built on an 8-point grid (see PROJECT.md → Spacing).
///
/// Use these tokens for padding, margins and gaps instead of magic numbers so
/// rhythm stays consistent across every screen. Two sub-grid values (`xxs`/`xs`)
/// are included for fine adjustments such as icon-to-label gaps.
abstract final class AppSpacing {
  const AppSpacing._();

  /// 2 — hairline nudge.
  static const double xxs = 2;

  /// 4 — half step.
  static const double xs = 4;

  /// 8 — base unit.
  static const double sm = 8;

  /// 12 — compact gap.
  static const double md = 12;

  /// 16 — default content padding.
  static const double lg = 16;

  /// 20 — comfortable gap.
  static const double xl = 20;

  /// 24 — section padding.
  static const double xxl = 24;

  /// 32 — large block separation.
  static const double xxxl = 32;

  /// 40 — hero spacing.
  static const double huge = 40;

  /// Default horizontal padding applied to screen content.
  static const double screenHPadding = lg;

  /// Bottom padding scrollable content must reserve so the last items clear the
  /// floating navigation bar (which overlaps the body via `extendBody`).
  static const double bottomBarClearance = 96;
}
