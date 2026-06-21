import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// A bold, left-aligned section heading such as "Recently uploaded".
///
/// Thin wrapper around the [AppTypography.sectionTitle] style so headings stay
/// visually identical wherever they appear.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {this.trailing, super.key});

  final String text;

  /// Optional control aligned to the trailing edge (e.g. a "See all" action).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final title = Text(text, style: AppTypography.sectionTitle);
    if (trailing == null) return title;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: title),
        trailing!,
      ],
    );
  }
}
