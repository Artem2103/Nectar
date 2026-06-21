import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_background.dart';
import 'widgets/app_bottom_nav_bar.dart';
import 'widgets/nav_fab.dart';

/// Persistent chrome wrapping the four primary tabs.
///
/// Owns the shared gradient backdrop, the floating navigation bar and the add
/// action, and swaps the active branch via the [StatefulNavigationShell] handed
/// down by [StatefulShellRoute]. Tab screens render only their own content.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Destination order must mirror the branch order in `app_router.dart`.
  static const List<NavDestination> _destinations = [
    NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    NavDestination(
      label: 'Progress',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
    ),
    NavDestination(
      label: 'Ranks',
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups_rounded,
    ),
    NavDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  void _onDestinationSelected(int index) {
    // `initialLocation: true` re-selecting the current tab pops it to its root.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _onAddMeal(BuildContext context) {
    // The central action: open the full-screen meal-capture flow.
    context.push(AppRoutes.addMeal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AppBackground(child: navigationShell),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppBottomNavBar(
                destinations: _destinations,
                currentIndex: navigationShell.currentIndex,
                onDestinationSelected: _onDestinationSelected,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            NavFab(onPressed: () => _onAddMeal(context)),
          ],
        ),
      ),
    );
  }
}
