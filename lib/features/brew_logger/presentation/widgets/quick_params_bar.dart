import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../features/inventory/presentation/widgets/smart_tag_field.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../controllers/brew_logger_controller.dart';
import '../models/brew_param_names.dart';
import 'number_param_control.dart';

/// Top-level parameter bar that follows current visibility settings.
///
/// Bean selector stays visible; Coffee/Water/Ratio are method-aware and
/// hidden when the user disables them in preferences.
///
/// Ref: docs/03_UI_Specification.md § 4.2 — Default Focus
class QuickParamsBar extends ConsumerWidget {
  const QuickParamsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brewLoggerControllerProvider);
    final ctrl = ref.read(brewLoggerControllerProvider.notifier);
    final isEspresso = state.brewMethod == BrewMethod.espresso;
    final coffeeLabel = isEspresso ? 'Dose' : 'Coffee';
    final waterLabel = isEspresso ? 'Yield' : 'Water';
    final coffeeParamName = isEspresso
        ? BrewParamNames.coffeeDose
        : BrewParamNames.coffeeWeight;
    final waterParamName = isEspresso
        ? BrewParamNames.yieldAmount
        : BrewParamNames.waterWeight;
    final catalogAsync = ref.watch(brewParamCatalogProvider(state.brewMethod));
    final catalog = catalogAsync.asData?.value;
    final showCoffee = catalog?.isVisibleByName(coffeeParamName) ?? true;
    final showWater = catalog?.isVisibleByName(waterParamName) ?? true;
    final showRatio =
        catalog?.isVisibleByName(BrewParamNames.brewRatio) ?? true;
    final coffeeDefinition = catalog?.definitionByName(coffeeParamName);
    final waterDefinition = catalog?.definitionByName(waterParamName);
    final coffeeRange = _resolveNumberRange(
      method: state.brewMethod,
      name: coffeeParamName,
      definition: coffeeDefinition,
      fallback: const BrewParamNumberRange(
        min: 8.0,
        max: 40.0,
        step: 0.1,
        defaultValue: 15.0,
      ),
    );
    final waterRange = _resolveNumberRange(
      method: state.brewMethod,
      name: waterParamName,
      definition: waterDefinition,
      fallback: const BrewParamNumberRange(
        min: 120.0,
        max: 700.0,
        step: 1.0,
        defaultValue: 225.0,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Bean picker ─────────────────────────────────────────────────
        SmartTagField(
          type: TagFieldType.bean,
          tags: state.beanName.isEmpty ? [] : [state.beanName],
          labelText: 'Coffee Bean',
          hintText: 'Search or add bean...',
          singleSelection: true,
          onTagsChanged: (tags) =>
              ctrl.setBeanName(tags.isEmpty ? '' : tags.first),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Coffee & Water weights side by side ─────────────────────────
        if (showCoffee || showWater) ...[
          Row(
            children: [
              if (showCoffee)
                Expanded(
                  child: NumberParamControl(
                    label: coffeeLabel,
                    value: state.coffeeWeightG,
                    unit: 'g',
                    range: coffeeRange,
                    onChanged: (value) {
                      if (value == null) return;
                      ctrl.setCoffeeWeight(value);
                    },
                    semanticLabel: '${coffeeLabel.toLowerCase()} weight',
                  ),
                ),
              if (showCoffee && showWater) const SizedBox(width: AppSpacing.md),
              if (showWater)
                Expanded(
                  child: NumberParamControl(
                    label: waterLabel,
                    value: state.waterWeightG,
                    unit: 'g',
                    range: waterRange,
                    onChanged: (value) {
                      if (value == null) return;
                      ctrl.setWaterWeight(value);
                    },
                    semanticLabel: '${waterLabel.toLowerCase()} weight',
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],

        // ── Ratio badge ──────────────────────────────────────────────────
        if (showRatio)
          Align(
            alignment: Alignment.centerRight,
            child: _RatioBadge(ratio: state.ratio),
          ),
      ],
    );
  }
}

/// Small badge showing the current water : coffee ratio.
class _RatioBadge extends StatelessWidget {
  const _RatioBadge({required this.ratio});
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        '1 : ${ratio.toStringAsFixed(1)}',
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
      ),
    );
  }
}

BrewParamNumberRange _resolveNumberRange({
  required BrewMethod method,
  required String name,
  required BrewParamDefinition? definition,
  required BrewParamNumberRange fallback,
}) {
  final fromDefinition = definition?.numberRange;
  if (fromDefinition != null) return fromDefinition;
  final fromTemplate = BrewParamDefaults.numberRangeFor(
    method: method,
    name: name,
  );
  return fromTemplate ?? fallback;
}
