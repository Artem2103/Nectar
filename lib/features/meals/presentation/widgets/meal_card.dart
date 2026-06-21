import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/meal_entry.dart';

/// One logged meal rendered as a row inside an [AppCard]: photo thumbnail,
/// name + time, and the calorie figure with its macro breakdown.
class MealCard extends StatelessWidget {
  const MealCard({required this.meal, super.key});

  final MealEntry meal;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Thumbnail(imagePath: meal.imagePath),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(_formatTime(meal.timestamp), style: AppTypography.label),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.kcal} kcal',
                style: AppTypography.titleMedium
                    .copyWith(fontWeight: AppTypography.bold),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'P ${meal.proteinG.round()}g · '
                'C ${meal.carbsG.round()}g · '
                'F ${meal.fatG.round()}g',
                style: AppTypography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 12-hour clock, e.g. `2:05 PM`.
  static String _formatTime(DateTime t) {
    final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }
}

/// Square photo thumbnail, falling back to a neutral nutrition glyph when the
/// meal was added without an image.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imagePath});

  final String? imagePath;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path != null && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: AppRadii.mdAll,
        child: Image.file(
          File(path),
          width: _size,
          height: _size,
          fit: BoxFit.cover,
          excludeFromSemantics: true,
        ),
      );
    }
    return Container(
      width: _size,
      height: _size,
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.mdAll,
      ),
      child: const Icon(
        Icons.restaurant_rounded,
        size: 22,
        color: AppColors.textSecondary,
      ),
    );
  }
}
