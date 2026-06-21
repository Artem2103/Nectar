import 'package:flutter/widgets.dart';

/// Elevation tokens expressed as soft, low-opacity shadows.
///
/// The design relies on diffuse shadows rather than hard Material elevation, so
/// cards read as gently lifted off the warm background. Reference these lists
/// instead of hand-tuning [BoxShadow]s per widget.
abstract final class AppShadows {
  const AppShadows._();

  /// Resting elevation for content cards.
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F1A1A2E), // AppColors.shadow @ ~6%
      blurRadius: 24,
      spreadRadius: -6,
      offset: Offset(0, 12),
    ),
  ];

  /// Stronger lift for floating surfaces (navigation bar, FAB).
  static const List<BoxShadow> floating = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F1A1A2E), // AppColors.shadow @ ~12%
      blurRadius: 28,
      spreadRadius: -4,
      offset: Offset(0, 14),
    ),
  ];

  /// Subtle highlight used on the selected calendar day.
  static const List<BoxShadow> raised = <BoxShadow>[
    BoxShadow(
      color: Color(0x141A1A2E), // AppColors.shadow @ ~8%
      blurRadius: 16,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];
}
