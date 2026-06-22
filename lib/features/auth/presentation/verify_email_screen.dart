import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';

/// Shown after sign-up when the Supabase project requires email confirmation,
/// so `signUp` returns no session. The user must click the link in their inbox
/// before any authenticated work (saving goals) can succeed.
///
/// Listens for a session arriving via [GoTrueClient.onAuthStateChange]: when
/// the confirmation link establishes a session (e.g. on a deep-link-enabled
/// build), the user is advanced straight into onboarding.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  /// The address the confirmation link was sent to, used for the resend action.
  final String email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  StreamSubscription<AuthState>? _authSub;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    // Advance to onboarding the moment a session is established by the
    // confirmation link being followed.
    _authSub = supabase.auth.onAuthStateChange.listen((state) {
      if (state.session != null && mounted) {
        context.goNamed(AppRoutes.onboardingName);
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    try {
      await supabase.auth.resend(type: OtpType.signup, email: widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Confirmation email sent')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Couldn't resend email: $e")));
      }
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    Text('Confirm your email',
                        style: AppTypography.sectionTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'We sent a confirmation link to ${widget.email}. '
                      'Tap it to activate your account, then sign in.',
                      style: AppTypography.label,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: _resending ? null : _resend,
                      child: Text(
                        _resending ? 'Sending…' : 'Resend email',
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.onInverse, fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _resending
                          ? null
                          : () => context.goNamed(AppRoutes.loginName),
                      child:
                          Text('Back to sign in', style: AppTypography.label),
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
