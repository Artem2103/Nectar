import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_title.dart';
import '../application/goals_provider.dart';
import '../application/settings_provider.dart';
import '../domain/app_settings.dart';
import '../domain/user_goals.dart';

/// Full-screen "Goals & targets" editor, pushed from the Profile hub.
///
/// Edits the user's daily calorie goal, macro targets and weight journey bounds,
/// persisting through [goalsProvider].
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      // An opaque scaffold colour (rather than transparent) keeps the strip the
      // keyboard vacates from flashing the black OS window as it animates away;
      // AppBackground still paints the gradient over the body.
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHPadding,
              AppSpacing.md,
              AppSpacing.screenHPadding,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColors.textPrimary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const ScreenTitle('Goals & targets'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
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
              ],
            ),
          ),
        ),
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
  // Read once: the form edits a snapshot, so the unit is fixed for its lifetime.
  late final UnitSystem _units =
      ref.read(settingsProvider).value?.units ?? UnitSystem.metric;
  late final _dailyKcal =
      TextEditingController(text: widget.goals.dailyKcal.toString());
  late final _protein =
      TextEditingController(text: _fmt(widget.goals.proteinG));
  late final _carbs = TextEditingController(text: _fmt(widget.goals.carbsG));
  late final _fat = TextEditingController(text: _fmt(widget.goals.fatG));
  late final _startWeight =
      TextEditingController(text: _fmt(_units.weightFromKg(widget.goals.startWeightKg)));
  late final _goalWeight =
      TextEditingController(text: _fmt(_units.weightFromKg(widget.goals.goalWeightKg)));
  bool _busy = false;

  static String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  /// Parses a weight field (in the display unit) back to kilograms for storage,
  /// or `null` when the field is blank/invalid so the existing value is kept.
  double? _weightToKg(String text) {
    final parsed = double.tryParse(text);
    return parsed == null ? null : _units.weightToKg(parsed);
  }

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
      startWeightKg: _weightToKg(_startWeight.text),
      goalWeightKg: _weightToKg(_goalWeight.text),
    );
    setState(() => _busy = true);
    try {
      await ref.read(goalsProvider.notifier).updateGoals(edited);
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Goals saved')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Couldn't save goals: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Daily nutrition', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          _GoalField(
              controller: _dailyKcal, label: 'Daily calories', integer: true),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                  child: _GoalField(controller: _protein, label: 'Protein g')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _GoalField(controller: _carbs, label: 'Carbs g')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _GoalField(controller: _fat, label: 'Fat g')),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Weight journey', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _GoalField(
                    controller: _startWeight,
                    label: 'Start weight ${_units.weightLabel}'),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _GoalField(
                    controller: _goalWeight,
                    label: 'Goal weight ${_units.weightLabel}'),
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
