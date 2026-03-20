import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/history_controller.dart';

class BrewStatsHeader extends StatelessWidget {
  const BrewStatsHeader({super.key, required this.stats});

  final HistoryStats stats;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('history-stats-header'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatPanel(
              key: const Key('history-stats-total'),
              label: 'Brews',
              value: '${stats.totalBrews}',
              icon: Icons.local_cafe_rounded,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _StatPanel(
              key: const Key('history-stats-rated'),
              label: 'Rated',
              value: '${stats.ratedBrews}',
              icon: Icons.star_rounded,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _StatPanel(
              key: const Key('history-stats-average'),
              label: 'Avg',
              value: stats.averageQuickScore == null
                  ? '-'
                  : stats.averageQuickScore!.toStringAsFixed(1),
              icon: Icons.analytics_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPanel extends StatelessWidget {
  const _StatPanel({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSpacing.iconSmall, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(child: Text(value, style: AppTextStyles.headlineMedium)),
        ],
      ),
    );
  }
}
