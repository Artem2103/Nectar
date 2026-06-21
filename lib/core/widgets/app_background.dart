import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The warm, top-weighted gradient that sits behind every screen.
///
/// Reproduces the subtle pink-to-white wash from `Nectar.pdf`. Placed once at
/// the app-shell level so the backdrop stays continuous as tabs switch; screens
/// themselves render transparently on top.
class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.32, 1.0],
          colors: [
            AppColors.backgroundTop,
            AppColors.background,
            AppColors.surface,
          ],
        ),
      ),
      child: child,
    );
  }
}
