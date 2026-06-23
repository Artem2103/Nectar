import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import 'widgets/auth_text_field.dart';

/// Email + password account creation. On success the user is sent to onboarding
/// to set their initial goals.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => _busy = true);
    try {
      final email = _email.text.trim();
      final res = await supabase.auth.signUp(
        email: email,
        password: _password.text,
      );
      if (!mounted) return;
      if (res.session == null) {
        // Email confirmation is enabled: sign-up returned no session, so the
        // user must confirm via the emailed link before any authenticated
        // work (saving goals) can run. Route them to the verify screen rather
        // than into onboarding, where the upsert would fail with
        // AuthSessionMissingException.
        context.goNamed(AppRoutes.verifyEmailName, extra: email);
      } else {
        context.goNamed(AppRoutes.onboardingName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text("Couldn't create account: $e")));
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
                    Text('Create account', style: AppTypography.sectionTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Start tracking in seconds',
                        style: AppTypography.label),
                    const SizedBox(height: AppSpacing.xl),
                    AuthTextField(
                      controller: _email,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _password,
                      label: 'Password',
                      obscure: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      controller: _confirm,
                      label: 'Confirm password',
                      obscure: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: _busy ? null : _register,
                      child: Text(
                        _busy ? 'Creating…' : 'Create account',
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.onInverse, fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => context.goNamed(AppRoutes.loginName),
                      child: Text('Sign in', style: AppTypography.label),
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
