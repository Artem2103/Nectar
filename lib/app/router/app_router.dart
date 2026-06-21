import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/groups/presentation/groups_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/navigation/home_shell.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import 'app_routes.dart';

/// Builds the application's [GoRouter].
///
/// A [StatefulShellRoute.indexedStack] backs the four bottom-navigation tabs:
/// each tab owns an independent navigator, so its scroll position and page
/// stack survive while the user moves between tabs. [HomeShell] supplies the
/// shared chrome (background, bottom bar, FAB) and renders the active branch.
abstract final class AppRouter {
  const AppRouter._();

  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              HomeShell(navigationShell: navigationShell),
          branches: [
            _branch(AppRoutes.home, AppRoutes.homeName, const HomeScreen()),
            _branch(AppRoutes.progress, AppRoutes.progressName,
                const ProgressScreen()),
            _branch(
                AppRoutes.groups, AppRoutes.groupsName, const GroupsScreen()),
            _branch(AppRoutes.profile, AppRoutes.profileName,
                const ProfileScreen()),
          ],
        ),
      ],
    );
  }

  /// One tab = one branch with a single top-level route.
  static StatefulShellBranch _branch(String path, String name, Widget child) {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          name: name,
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: child),
        ),
      ],
    );
  }
}
