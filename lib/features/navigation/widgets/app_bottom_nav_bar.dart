import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/nectar_colors.dart';

/// A single destination in the floating navigation bar.
class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// The floating, pill-shaped bottom navigation bar from `Nectar.pdf`.
///
/// Renders [destinations] with the selected item lifted into a muted pill and
/// rendered in the primary ink colour, while inactive items stay grey. It is a
/// pure presentation widget: selection state and taps are owned by the caller
/// (the routing shell), keeping navigation logic in one place.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final List<NavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadii.xxlAll,
        boxShadow: AppShadows.floating,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          for (var i = 0; i < destinations.length; i++)
            Expanded(
              child: _NavItem(
                destination: destinations[i],
                selected: i == currentIndex,
                onTap: () => onDestinationSelected(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? context.colors.textPrimary : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color:
                selected ? context.colors.surfaceMuted : Colors.transparent,
            borderRadius: AppRadii.lgAll,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? destination.activeIcon : destination.icon,
                size: 22,
                color: color,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: AppTypography.caption.copyWith(
                  color: color,
                  fontWeight:
                      selected ? AppTypography.semiBold : AppTypography.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
