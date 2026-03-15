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

    if (enabled.length == 1) {
      final onlyEnabled = enabled.first;
      if (state.brewMethod != onlyEnabled.method) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.setBrewMethod(onlyEnabled.method);
        });
      }
      return const SizedBox.shrink();
    }

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Brew Method', style: AppTextStyles.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (int index = 0; index < enabled.length; index++) ...[
                Expanded(
                  child: _MethodOptionButton(
                    config: enabled[index],
                    selected: enabled[index].method == state.brewMethod,
                    onPressed: () =>
                        controller.setBrewMethod(enabled[index].method),
                  ),
                ),
                if (index < enabled.length - 1)
                  const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MethodOptionButton extends StatelessWidget {
  const _MethodOptionButton({
    required this.config,
    required this.selected,
    required this.onPressed,
  });

  final BrewMethodConfig config;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected ? Colors.white : AppColors.textSecondary;

    return AnimatedContainer(
      key: Key('brew-method-option-${config.method.name}'),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: AppSpacing.buttonSmallHeight,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.shadowDark,
        ),
        boxShadow: selected ? AppColors.softShadow : const [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          onTap: onPressed,
          child: Center(
            child: Text(
              config.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
