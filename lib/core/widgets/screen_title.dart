import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// The large, left-aligned page title used at the top of standalone tabs
/// ("Progress", "Groups", "Profile").
class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.largeTitle);
  }
}
