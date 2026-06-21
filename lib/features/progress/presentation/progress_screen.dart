import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/screen_title.dart';

/// The Progress tab.
///
/// Foundation scope establishes the screen title and layout. The streak and
/// badge cards, current-weight card with the "Log weight" pill, and the
/// timeframe-filtered weight chart are built in the dedicated Progress pass.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHPadding,
          AppSpacing.md,
          AppSpacing.screenHPadding,
          AppSpacing.bottomBarClearance,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTitle('Progress'),
          ],
        ),
      ),
    );
  }
}
