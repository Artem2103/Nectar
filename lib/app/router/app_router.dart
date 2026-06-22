import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/supabase/supabase_client.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/groups/presentation/groups_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/meals/presentation/add_meal_screen.dart';
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
///
/// A top-level [GoRouter.redirect] guards everything behind Supabase auth, and
/// [GoRouterRefreshStream] re-evaluates that guard whenever the session changes.
abstract final class AppRouter {
  const AppRouter._();

  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.home,
      redirect: (context, state) {
        final loggedIn = supabase.auth.currentUser != null;
        final onAuth = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register ||
            state.matchedLocation == AppRoutes.onboarding;
        if (!loggedIn && !onAuth) return AppRoutes.login;
        if (loggedIn && state.matchedLocation == AppRoutes.login) {
          return AppRoutes.home;
        }
        return null;
      },
      refreshListenable: GoRouterRefreshStream(
        supabase.auth.onAuthStateChange.map((_) => null),
      ),
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
        // Pushed above the shell so it covers the bottom bar — the central
        // "add meal" action.
        GoRoute(
          path: AppRoutes.addMeal,
          name: AppRoutes.addMealName,
          builder: (context, state) => const AddMealScreen(),
        ),
        // Auth flow — full-screen routes shown before the user has a session.
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: AppRoutes.registerName,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          name: AppRoutes.onboardingName,
          builder: (context, state) => const OnboardingScreen(),
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

/// Adapts a [Stream] into a [Listenable] so [GoRouter] re-runs its redirect
/// logic on every emission. The standard GoRouter pattern for bridging an
/// auth-state stream into `refreshListenable`.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
