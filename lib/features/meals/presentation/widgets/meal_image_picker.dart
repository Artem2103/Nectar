import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Tappable square that shows the chosen meal photo, or a prompt to pick one.
class MealImagePicker extends StatelessWidget {
  const MealImagePicker({required this.image, required this.onTap, super.key});

  final File? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final picked = image;
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.xlAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: picked != null
              ? Image.file(picked, fit: BoxFit.cover, excludeFromSemantics: true)
              : DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: AppRadii.xlAll,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_a_photo_rounded,
                        size: 32,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Add a photo', style: AppTypography.label),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
