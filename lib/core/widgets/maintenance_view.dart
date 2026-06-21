import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Centered "Under Maintenance" placeholder shown by feature screens that are
/// temporarily disabled (Groups and Profile in the MVP — see PROJECT.md).
///
/// Reused rather than duplicated so the illustration, copy and spacing stay
/// identical; only the [message] differs per screen.
class MaintenanceView extends StatelessWidget {
  const MaintenanceView({required this.message, super.key});

  /// Supporting line under the title, tailored to the host feature.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Illustration(),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Under Maintenance',
              style: AppTypography.titleMedium.copyWith(fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// The artwork inside a soft radial glow, as in the design.
class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.illustrationGlowStart,
            AppColors.illustrationGlowEnd,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Image.asset(
          AppAssets.maintenance,
          fit: BoxFit.contain,
          // Decorative imagery; hidden from assistive tech.
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
