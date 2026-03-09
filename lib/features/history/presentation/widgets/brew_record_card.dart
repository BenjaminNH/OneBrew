import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/brew_summary.dart';

class BrewRecordCard extends StatelessWidget {
  const BrewRecordCard({super.key, required this.summary, this.onTap});

  final BrewSummary summary;
  final VoidCallback? onTap;

  bool get _isHighScore => (summary.quickScore ?? 0) >= 4;

  @override
  Widget build(BuildContext context) {
    final ratio = summary.coffeeWeightG > 0
        ? summary.waterWeightG / summary.coffeeWeightG
        : 0;

    return AppCard(
      key: ValueKey('history-record-card-${summary.id}'),
      onTap: onTap,
      borderRadius: AppSpacing.radiusMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  summary.beanName,
                  style: AppTextStyles.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isHighScore)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        size: AppSpacing.iconSmall,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Top Brew',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppDateUtils.formatDateTimeShort(summary.brewDate),
            style: AppTextStyles.bodySmall,
          ),
          if (summary.roaster != null &&
              summary.roaster!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text('Roaster: ${summary.roaster}', style: AppTextStyles.bodySmall),
          ],
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              _MetaChip(
                icon: Icons.timer_outlined,
                text: '${summary.brewDurationS}s',
              ),
              _MetaChip(
                icon: Icons.water_drop_outlined,
                text:
                    '${summary.coffeeWeightG.toStringAsFixed(0)}g : ${summary.waterWeightG.toStringAsFixed(0)}g',
              ),
              _MetaChip(
                icon: Icons.straighten_rounded,
                text: '1:${ratio.toStringAsFixed(1)}',
              ),
              if (summary.quickScore != null)
                _MetaChip(
                  icon: Icons.star_rounded,
                  text: '${summary.quickScore}/5 ${summary.emoji ?? ''}'.trim(),
                ),
            ],
          ),
          if (summary.notes != null && summary.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              summary.notes!,
              style: AppTextStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSmall, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(text, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
