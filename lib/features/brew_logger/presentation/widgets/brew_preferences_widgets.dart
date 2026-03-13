import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../controllers/brew_preferences_controller.dart';
import '../models/brew_param_names.dart';

class BrewMethodToggleList extends StatelessWidget {
  const BrewMethodToggleList({
    super.key,
    required this.methodConfigs,
    required this.onToggle,
  });

  final List<BrewMethodConfig> methodConfigs;
  final void Function(BrewMethod method, bool enabled) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: methodConfigs.map((config) {
        return AppCard(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  config.displayName,
                  style: AppTextStyles.titleMedium,
                ),
              ),
              Switch(
                value: config.isEnabled,
                onChanged: (value) => onToggle(config.method, value),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class BrewMethodSegmented extends StatelessWidget {
  const BrewMethodSegmented({
    super.key,
    required this.methodConfigs,
    required this.selectedMethod,
    required this.onSelected,
  });

  final List<BrewMethodConfig> methodConfigs;
  final BrewMethod selectedMethod;
  final ValueChanged<BrewMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    final enabled = methodConfigs.where((m) => m.isEnabled).toList();
    if (enabled.isEmpty) {
      return AppCard(
        child: Text(
          'Enable a brew method to configure parameters.',
          style: AppTextStyles.bodySmall,
        ),
      );
    }

    return Wrap(
      spacing: AppSpacing.xs,
      children: enabled.map((config) {
        final selected = config.method == selectedMethod;
        return ChoiceChip(
          label: Text(config.displayName),
          selected: selected,
          onSelected: (_) => onSelected(config.method),
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
    );
  }
}

class BrewParamListEditor extends StatelessWidget {
  const BrewParamListEditor({
    super.key,
    required this.items,
    required this.onVisibilityChanged,
    required this.onDelete,
  });

  final List<BrewParamItem> items;
  final void Function(BrewParamItem item, bool visible) onVisibilityChanged;
  final void Function(BrewParamItem item) onDelete;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return AppCard(
        child: Text(
          'No parameters configured for this brew method yet.',
          style: AppTextStyles.bodySmall,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) {
        final item = items[index];
        final label = item.definition.name;
        final type = item.definition.type == ParamType.number
            ? 'Number'
            : 'Text';
        final unit = item.definition.unit;
        final canToggle = canToggleParam(
          method: item.definition.method,
          name: label,
        );
        final canDelete = !item.isSystem;

        return AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.titleSmall),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      unit == null || unit.isEmpty ? type : '$type · $unit',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              if (!canToggle)
                const Icon(Icons.lock_outline, color: AppColors.textSecondary)
              else
                Switch(
                  value: item.isVisible,
                  onChanged: (value) => onVisibilityChanged(item, value),
                ),
              if (canDelete)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                  tooltip: 'Delete parameter',
                  onPressed: () => onDelete(item),
                ),
            ],
          ),
        );
      },
    );
  }
}
