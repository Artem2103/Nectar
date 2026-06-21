import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// The foundational surface of the app: a large, softly rounded card.
///
/// Every panel in the design (nutrition stats, weight, charts, empty states)
/// is a variation of this card, so the rounding, padding, shadow and optional
/// tap behaviour are centralised here rather than re-declared per screen.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.color = AppColors.surface,
    this.borderRadius = AppRadii.xlAll,
    this.shadows = AppShadows.card,
    this.onTap,
    super.key,
  });

  /// Convenience constructor for the recessed, shadowless muted surface used by
  /// empty states and inert placeholders.
  const AppCard.muted({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(AppSpacing.xl),
    VoidCallback? onTap,
    Key? key,
  }) : this(
          child: child,
          padding: padding,
          color: AppColors.surfaceMuted,
          shadows: const <BoxShadow>[],
          onTap: onTap,
          key: key,
        );

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      ),
    );
  }
}
