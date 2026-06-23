import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';

/// A titled group of settings rows rendered inside a single rounded card.
///
/// Children are typically [SettingsNavRow], [SettingsToggleRow] or
/// [SettingsValueRow]; hairline dividers are inserted between them automatically
/// so callers just pass the rows in order.
class SettingsSection extends StatelessWidget {
  const SettingsSection({required this.children, this.title, super.key});

  /// Optional caption shown above the card (e.g. "Account", "Preferences").
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Text(
              title!.toUpperCase(),
              style: AppTypography.caption.copyWith(letterSpacing: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A tappable row that navigates to a detail screen or sheet, ending in a
/// chevron. Use [trailingValue] to show the current selection inline.
class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({
    required this.title,
    this.icon,
    this.subtitle,
    this.trailingValue,
    this.onTap,
    super.key,
  });

  final String title;
  final IconData? icon;
  final String? subtitle;
  final String? trailingValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingValue != null)
            Flexible(
              child: Text(
                trailingValue!,
                style: AppTypography.label,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

/// A row with a trailing [Switch] for an on/off preference.
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.icon,
    this.subtitle,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.accent,
      ),
    );
  }
}

/// A read-only row displaying a label and its current value (no chevron).
class SettingsValueRow extends StatelessWidget {
  const SettingsValueRow({
    required this.title,
    required this.value,
    this.icon,
    super.key,
  });

  final String title;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      icon: icon,
      title: title,
      trailing: Text(value, style: AppTypography.label),
    );
  }
}

/// Shared layout for every settings row: an optional leading icon tile, the
/// title (with optional subtitle) and a trailing widget, made tappable when an
/// [onTap] is supplied.
class _SettingsRowShell extends StatelessWidget {
  const _SettingsRowShell({
    required this.title,
    this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final IconData? icon;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: AppRadii.mdAll,
              ),
              child: Icon(icon, size: 20, color: AppColors.textPrimary),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: AppTypography.medium,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(subtitle!, style: AppTypography.caption),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
