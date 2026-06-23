import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/nectar_colors.dart';

/// A fully-rounded, inky action button — the "Log weight →" control.
///
/// Wraps the themed [FilledButton] so the pill shape, trailing icon and label
/// styling are defined once. Kept deliberately small; richer variants can be
/// added as named constructors when the design introduces them.
class PillButton extends StatelessWidget {
  const PillButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optional trailing glyph rendered after the label.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final onInverse = context.colors.onInverse;
    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.titleMedium.copyWith(
            color: onInverse,
            fontSize: 15,
          )),
          if (icon != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(icon, size: 18, color: onInverse),
          ],
        ],
      ),
    );
  }
}
