import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/maintenance_view.dart';
import '../../../core/widgets/screen_title.dart';

/// The Groups (Ranks) tab — temporarily disabled in the MVP (see PROJECT.md),
/// shown as a maintenance placeholder.
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

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
            child: ScreenTitle('Groups'),
          ),
          const Expanded(
            child: MaintenanceView(
              message:
                  'Groups is temporarily unavailable while we make improvements.',
            ),
          ),
        ],
      ),
    );
  }
}
