import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

/// The black circular "+" action that floats beside the navigation bar.
///
/// Used to start adding a meal (the app's central action). Kept as its own
/// widget so its size, colour and shadow are reused wherever the action
/// surfaces (e.g. an empty-state shortcut).
class NavFab extends StatelessWidget {
  const NavFab({required this.onPressed, this.size = 64, super.key});

  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceInverse,
        shape: BoxShape.circle,
        boxShadow: AppShadows.floating,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.onInverse,
              size: 30,
              semanticLabel: 'Add meal',
            ),
          ),
        ),
      ),
    );
  }
}
