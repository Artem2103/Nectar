/// Canonical route paths and names.
///
/// Centralising these avoids stringly-typed navigation scattered across the
/// codebase; widgets reference [AppRoutes.home] etc. and call sites use the
/// named-route helpers on GoRouter.
abstract final class AppRoutes {
  const AppRoutes._();

  static const String home = '/home';
  static const String progress = '/progress';
  static const String groups = '/groups';
  static const String profile = '/profile';

  /// Full-screen meal-capture flow, pushed above the tab shell.
  static const String addMeal = '/add-meal';

  // Auth flow — plain routes outside the tab shell.
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';

  // Named-route identifiers (used by `goNamed`).
  static const String homeName = 'home';
  static const String progressName = 'progress';
  static const String groupsName = 'groups';
  static const String profileName = 'profile';
  static const String addMealName = 'add-meal';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String onboardingName = 'onboarding';
}
