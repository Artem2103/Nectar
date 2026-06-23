import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_title.dart';
import '../application/goals_provider.dart';
import '../application/settings_provider.dart';
import '../application/theme_controller.dart';
import '../domain/app_settings.dart';
import 'widgets/settings_widgets.dart';

/// The Profile tab, structured as a settings hub: an account header above
/// grouped setting rows that open detail screens / sheets, ending in sign-out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = supabase.auth.currentUser?.email ?? '';
    final settings = ref.watch(settingsProvider).value ?? AppSettings.defaults();
    final themeMode = ref.watch(themeControllerProvider);
    final dailyKcal = ref.watch(goalsProvider).value?.dailyKcal;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHPadding,
          AppSpacing.md,
          AppSpacing.screenHPadding,
          AppSpacing.bottomBarClearance,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenTitle('Profile'),
            const SizedBox(height: AppSpacing.xl),
            _Header(email: email),
            const SizedBox(height: AppSpacing.xl),
            SettingsSection(
              title: 'Goals & nutrition',
              children: [
                SettingsNavRow(
                  icon: Icons.flag_rounded,
                  title: 'Goals & targets',
                  subtitle: 'Calories, macros and weight journey',
                  trailingValue:
                      dailyKcal == null ? null : '$dailyKcal kcal',
                  onTap: () => context.pushNamed(AppRoutes.goalsName),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SettingsSection(
              title: 'Preferences',
              children: [
                SettingsNavRow(
                  icon: Icons.dark_mode_rounded,
                  title: 'Appearance',
                  trailingValue: _themeLabel(themeMode),
                  onTap: () => _pickTheme(context, ref, themeMode),
                ),
                SettingsNavRow(
                  icon: Icons.straighten_rounded,
                  title: 'Units',
                  trailingValue: _unitsLabel(settings.units),
                  onTap: () => _pickUnits(context, ref, settings),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SettingsSection(
              title: 'Notifications',
              children: [
                SettingsToggleRow(
                  icon: Icons.restaurant_rounded,
                  title: 'Meal reminders',
                  value: settings.mealReminders,
                  onChanged: (v) => ref
                      .read(settingsProvider.notifier)
                      .updateSettings(settings.copyWith(mealReminders: v)),
                ),
                SettingsToggleRow(
                  icon: Icons.monitor_weight_rounded,
                  title: 'Weigh-in reminders',
                  value: settings.weighInReminders,
                  onChanged: (v) => ref
                      .read(settingsProvider.notifier)
                      .updateSettings(settings.copyWith(weighInReminders: v)),
                ),
                SettingsToggleRow(
                  icon: Icons.local_fire_department_rounded,
                  title: 'Streak nudges',
                  value: settings.streakNudges,
                  onChanged: (v) => ref
                      .read(settingsProvider.notifier)
                      .updateSettings(settings.copyWith(streakNudges: v)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            TextButton(
              onPressed: () => supabase.auth.signOut(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.streak,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                'Sign out',
                style: AppTypography.titleMedium
                    .copyWith(color: AppColors.streak, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };

  static String _unitsLabel(UnitSystem units) => switch (units) {
        UnitSystem.metric => 'Metric (kg)',
        UnitSystem.imperial => 'Imperial (lb)',
      };

  Future<void> _pickTheme(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) async {
    final choice = await _showOptionSheet<ThemeMode>(
      context: context,
      title: 'Appearance',
      options: [
        for (final mode in ThemeMode.values)
          _Option(value: mode, label: _themeLabel(mode), selected: mode == current),
      ],
    );
    if (choice != null) {
      await ref.read(themeControllerProvider.notifier).setThemeMode(choice);
    }
  }

  Future<void> _pickUnits(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final choice = await _showOptionSheet<UnitSystem>(
      context: context,
      title: 'Units',
      options: [
        for (final units in UnitSystem.values)
          _Option(
            value: units,
            label: _unitsLabel(units),
            selected: units == settings.units,
          ),
      ],
    );
    if (choice != null && choice != settings.units) {
      await ref
          .read(settingsProvider.notifier)
          .updateSettings(settings.copyWith(units: choice));
    }
  }
}

/// A single choice in an [_showOptionSheet].
class _Option<T> {
  const _Option({
    required this.value,
    required this.label,
    required this.selected,
  });

  final T value;
  final String label;
  final bool selected;
}

/// Shows a simple single-select bottom sheet and returns the chosen value, or
/// `null` if dismissed.
Future<T?> _showOptionSheet<T>({
  required BuildContext context,
  required String title,
  required List<_Option<T>> options,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.sm,
            ),
            child: Text(title, style: AppTypography.titleMedium),
          ),
          for (final option in options)
            ListTile(
              title: Text(option.label, style: AppTypography.body),
              trailing: option.selected
                  ? const Icon(Icons.check_rounded, color: AppColors.accent)
                  : null,
              onTap: () => Navigator.pop(context, option.value),
            ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final name =
        (supabase.auth.currentUser?.userMetadata?['name'] as String?)?.trim();
    final hasName = name != null && name.isNotEmpty;

    final initialSource = hasName ? name : email;
    final initial =
        initialSource.isNotEmpty ? initialSource[0].toUpperCase() : '?';

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.surfaceInverse,
            child: Text(
              initial,
              style: AppTypography.statNumber
                  .copyWith(color: AppColors.onInverse),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: hasName
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        email,
                        style: AppTypography.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                : Text(
                    email.isEmpty ? 'Signed in' : email,
                    style: AppTypography.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }
}
