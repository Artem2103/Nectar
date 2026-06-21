import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/maintenance_view.dart';
import '../../../core/widgets/screen_title.dart';

/// The Profile tab — temporarily disabled in the MVP (see PROJECT.md), shown as
/// a maintenance placeholder.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenHPadding,
              AppSpacing.md,
              AppSpacing.screenHPadding,
              0,
            ),
            child: ScreenTitle('Profile'),
          ),
          const Expanded(
            child: MaintenanceView(
              message:
                  'Profile is temporarily unavailable while we make improvements.',
            ),
          ),
        ],
      ),
    );
  }
}
