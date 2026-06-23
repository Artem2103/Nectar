import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/nectar_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/badge_definition.dart';

/// Badges card: the shield above an `earned / total` count. Tapping it opens a
/// dialog listing every badge, with unearned ones greyed out (`Nectar.pdf`).
class BadgesCard extends StatelessWidget {
  const BadgesCard({required this.earnedIds, super.key});

  final Set<String> earnedIds;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => _showBadgesDialog(context, earnedIds),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.badges,
            width: 56,
            height: 56,
            excludeFromSemantics: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Badges Earned', style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${earnedIds.length} / ${kAllBadges.length}',
            style: AppTypography.statNumber,
          ),
        ],
      ),
    );
  }
}

Future<void> _showBadgesDialog(BuildContext context, Set<String> earnedIds) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: context.colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Badges', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.lg),
            for (final badge in kAllBadges) ...[
              _BadgeRow(badge: badge, earned: earnedIds.contains(badge.id)),
              if (badge != kAllBadges.last)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    ),
  );
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.badge, required this.earned});

  final BadgeDefinition badge;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: earned ? 1 : 0.35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(badge.iconEmoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(badge.title, style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(badge.description, style: AppTypography.label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
