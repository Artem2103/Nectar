import 'package:flutter/material.dart';

import '../theme/app_radii.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/nectar_colors.dart';

/// The foundational surface of the app: a large, softly rounded card.
///
/// Every panel in the design (nutrition stats, weight, charts, empty states)
/// is a variation of this card, so the rounding, padding, shadow and optional
/// tap behaviour are centralised here rather than re-declared per screen.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.color,
    this.borderRadius = AppRadii.xlAll,
    this.shadows = AppShadows.card,
    this.onTap,
    super.key,
  }) : _muted = false;

  /// Convenience constructor for the recessed, shadowless muted surface used by
  /// empty states and inert placeholders.
  const AppCard.muted({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.borderRadius = AppRadii.xlAll,
    this.onTap,
    super.key,
  })  : color = null,
        shadows = const <BoxShadow>[],
        _muted = true;

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Explicit surface colour; when null the theme-aware default is resolved at
  /// build time ([NectarColors.surface], or `surfaceMuted` for [AppCard.muted]).
  final Color? color;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;
  final VoidCallback? onTap;

  /// Whether this card uses the recessed muted surface as its default.
  final bool _muted;

  @override
  Widget build(BuildContext context) {
    final resolved = color ??
        (_muted ? context.colors.surfaceMuted : context.colors.surface);
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: resolved,
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
