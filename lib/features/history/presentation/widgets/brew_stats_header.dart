import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/brew_summary.dart';
import '../controllers/history_controller.dart';

class BrewStatsHeader extends StatelessWidget {
  const BrewStatsHeader({
    super.key,
    required this.stats,
    required this.topBrews,
  });

  final HistoryStats stats;
  final List<BrewSummary> topBrews;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('history-stats-header'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('History Summary', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Brews',
                  value: '${stats.totalBrews}',
                  icon: Icons.local_cafe_rounded,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Rated',
                  value: '${stats.ratedBrews}',
                  icon: Icons.star_rounded,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Avg ★',
                  value: stats.averageQuickScore == null
                      ? '-'
                      : stats.averageQuickScore!.toStringAsFixed(1),
                  icon: Icons.analytics_rounded,
                ),
              ),
            ],
          ),
          if (topBrews.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Top Brews (by rating)', style: AppTextStyles.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: topBrews.take(3).map((brew) {
                final ratingLabel = brew.quickScore == null
                    ? 'Unrated'
                    : 'Rating ${brew.quickScore}/5';
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '${brew.beanName} • $ratingLabel',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: AppSpacing.iconAction, color: AppColors.primary),
        const SizedBox(height: AppSpacing.xxs),
        Text(value, style: AppTextStyles.headlineMedium),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}
