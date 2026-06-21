import 'package:flutter/widgets.dart';

/// Corner-radius tokens.
///
/// The design language favours large, soft rounding (see PROJECT.md → "Large
/// rounded cards"). Ready-made [BorderRadius] values are exposed alongside the
/// raw doubles to keep call sites terse.
abstract final class AppRadii {
  const AppRadii._();

  /// 8 — chips and small controls.
  static const double sm = 8;

  /// 14 — inner elements, skeleton rows.
  static const double md = 14;

  /// 20 — buttons and compact cards.
  static const double lg = 20;

  /// 28 — primary content cards.
  static const double xl = 28;

  /// 32 — the floating navigation bar.
  static const double xxl = 32;

  /// Fully rounded (pills, circular rings).
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}
