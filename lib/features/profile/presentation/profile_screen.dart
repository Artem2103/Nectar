import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_title.dart';
import '../application/goals_provider.dart';
import '../domain/user_goals.dart';

/// The Profile tab: account header, an editor for the user's nutrition and
/// weight goals, and a sign-out action.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);
    final email = supabase.auth.currentUser?.email ?? '';

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
            const SizedBox(height: AppSpacing.lg),
            goalsAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text(
                "Couldn't load your goals: $e",
                style: AppTypography.label,
              ),
              data: (goals) => _GoalsForm(goals: goals),
            ),
            const SizedBox(height: AppSpacing.lg),
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

class _GoalsForm extends ConsumerStatefulWidget {
  const _GoalsForm({required this.goals});

  final UserGoals goals;

  @override
  ConsumerState<_GoalsForm> createState() => _GoalsFormState();
}

class _GoalsFormState extends ConsumerState<_GoalsForm> {
  late final _dailyKcal =
      TextEditingController(text: widget.goals.dailyKcal.toString());
  late final _protein =
      TextEditingController(text: _fmt(widget.goals.proteinG));
  late final _carbs = TextEditingController(text: _fmt(widget.goals.carbsG));
  late final _fat = TextEditingController(text: _fmt(widget.goals.fatG));
  late final _startWeight =
      TextEditingController(text: _fmt(widget.goals.startWeightKg));
  late final _goalWeight =
      TextEditingController(text: _fmt(widget.goals.goalWeightKg));
  bool _busy = false;

  static String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toStringAsFixed(0) : v.toString();

  @override
  void dispose() {
    for (final c in [
      _dailyKcal,
      _protein,
      _carbs,
      _fat,
      _startWeight,
      _goalWeight,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final edited = widget.goals.copyWith(
      dailyKcal: int.tryParse(_dailyKcal.text),
      proteinG: double.tryParse(_protein.text),
      carbsG: double.tryParse(_carbs.text),
      fatG: double.tryParse(_fat.text),
      startWeightKg: double.tryParse(_startWeight.text),
      goalWeightKg: double.tryParse(_goalWeight.text),
    );
    setState(() => _busy = true);
    try {
      await ref.read(goalsProvider.notifier).updateGoals(edited);
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Goals saved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Couldn't save goals: $e")));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Your goals', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          _GoalField(
              controller: _dailyKcal, label: 'Daily calories', integer: true),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _GoalField(controller: _protein, label: 'Protein g')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _GoalField(controller: _carbs, label: 'Carbs g')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _GoalField(controller: _fat, label: 'Fat g')),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _GoalField(
                    controller: _startWeight, label: 'Start weight kg'),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _GoalField(
                    controller: _goalWeight, label: 'Goal weight kg'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(
              _busy ? 'Saving…' : 'Save goals',
              style: AppTypography.titleMedium
                  .copyWith(color: AppColors.onInverse, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact numeric field matching the app's form styling.
class _GoalField extends StatelessWidget {
  const _GoalField({
    required this.controller,
    required this.label,
    this.integer = false,
  });

  final TextEditingController controller;
  final String label;
  final bool integer;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !integer),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          integer ? RegExp(r'[0-9]') : RegExp(r'[0-9.]'),
        ),
      ],
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.label,
        filled: true,
        fillColor: AppColors.surface,
        border: const OutlineInputBorder(
          borderRadius: AppRadii.lgAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lgAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
