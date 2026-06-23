import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../profile/application/goals_provider.dart';
import '../../profile/domain/user_goals.dart';
import 'widgets/auth_text_field.dart';

/// One-time setup shown right after registration: captures a display name and
/// the user's initial goals, persists them, then enters the app.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _name = TextEditingController();
  final _startWeight = TextEditingController();
  final _goalWeight = TextEditingController();
  final _dailyKcal = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _startWeight.dispose();
    _goalWeight.dispose();
    _dailyKcal.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final defaults = UserGoals.defaults();
    final goals = defaults.copyWith(
      dailyKcal: int.tryParse(_dailyKcal.text),
      startWeightKg: double.tryParse(_startWeight.text),
      goalWeightKg: double.tryParse(_goalWeight.text),
    );

    setState(() => _busy = true);
    try {
      final name = _name.text.trim();
      if (name.isNotEmpty) {
        await supabase.auth
            .updateUser(UserAttributes(data: {'name': name}));
      }
      await ref.read(goalsProvider.notifier).updateGoals(goals);
      if (mounted) context.goNamed(AppRoutes.homeName);
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
    return Scaffold(
      // Opaque scaffold (not transparent) so the strip the keyboard vacates
      // doesn't flash the black OS window during the close animation.
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenHPadding),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Set your goals', style: AppTypography.sectionTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text('You can change these anytime in your profile.',
                        style: AppTypography.label),
                    const SizedBox(height: AppSpacing.xl),
                    AuthTextField(controller: _name, label: 'Name'),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _startWeight,
                      label: 'Start weight (kg)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _goalWeight,
                      label: 'Goal weight (kg)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _dailyKcal,
                      label: 'Daily calorie target',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: _busy ? null : _complete,
                      child: Text(
                        _busy ? 'Saving…' : 'Get started',
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.onInverse, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
