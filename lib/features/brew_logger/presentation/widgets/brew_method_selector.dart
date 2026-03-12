import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/brew_method_config.dart';
import '../controllers/brew_logger_controller.dart';

class BrewMethodSelector extends ConsumerWidget {
  const BrewMethodSelector({super.key, required this.configs});

  final List<BrewMethodConfig> configs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brewLoggerControllerProvider);
    final controller = ref.read(brewLoggerControllerProvider.notifier);
    final enabled = configs.where((c) => c.isEnabled).toList();

    if (enabled.isEmpty) {
      return AppCard(
        child: Text(
          'Enable a brew method in preferences to start logging.',
          style: AppTextStyles.bodySmall,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brew Method', style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: enabled.map((config) {
            final selected = config.method == state.brewMethod;
            return ChoiceChip(
              label: Text(config.displayName),
              selected: selected,
              onSelected: (_) => controller.setBrewMethod(config.method),
              selectedColor: AppColors.primary,
              labelStyle: AppTextStyles.labelSmall.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.shadowDark,
              ),
              backgroundColor: AppColors.background,
            );
          }).toList(),
        ),
      ],
    );
  }
}
