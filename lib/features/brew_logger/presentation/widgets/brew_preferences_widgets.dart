import 'package:flutter/material.dart';
import 'package:one_brew/l10n/l10n.dart';
import 'package:one_brew/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../../domain/entities/brew_param_key.dart';
import '../controllers/brew_preferences_controller.dart';
import '../models/brew_param_display.dart';

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
    final l10n = context.l10n;
    return Column(
      children: methodConfigs.map((config) {
        return AppCard(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayNameFor(config, l10n),
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
    final l10n = context.l10n;
    final enabled = methodConfigs.where((m) => m.isEnabled).toList();
    if (enabled.isEmpty) {
      return AppCard(
        child: Text(
          l10n.brewEnableMethodToConfigureParams,
          style: AppTextStyles.bodySmall,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: enabled.map((config) {
          final selected = config.method == selectedMethod;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: ChoiceChip(
              label: Text(_displayNameFor(config, l10n)),
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
            ),
          );
        }).toList(),
      ),
    );
  }
}

String _displayNameFor(BrewMethodConfig config, AppLocalizations l10n) {
  switch (config.method) {
    case BrewMethod.pourOver:
      return l10n.brewMethodNamePourOver;
    case BrewMethod.espresso:
      return l10n.brewMethodNameEspresso;
    case BrewMethod.custom:
      final name = config.displayName.trim();
      if (name.isEmpty) return l10n.brewCustomMethodDefaultName;
      if (name.toLowerCase() == 'custom') {
        return l10n.brewCustomMethodDefaultName;
      }
      return name;
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
      final l10n = context.l10n;
      return AppCard(
        child: Text(
          l10n.brewNoParamsConfiguredYet,
          style: AppTextStyles.bodySmall,
        ),
      );
    }

    final l10n = context.l10n;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) {
        final item = items[index];
        final label = localizedParamLabelForDefinition(item.definition, l10n);
        final type = item.definition.type == ParamType.number
            ? l10n.brewParamTypeNumber
            : l10n.brewParamTypeText;
        final unit = item.definition.unit;
        final canToggle = canToggleParam(
          method: item.definition.method,
          paramKey: item.definition.paramKey,
          name: item.definition.name,
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
                  tooltip: l10n.brewTooltipDeleteParameter,
                  onPressed: () => onDelete(item),
                ),
            ],
          ),
        );
      },
    );
  }
}
