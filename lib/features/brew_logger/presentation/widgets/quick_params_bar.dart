import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_slider.dart';
import '../../../../features/inventory/presentation/widgets/smart_tag_field.dart';
import '../controllers/brew_logger_controller.dart';

/// The essential "quick" parameter bar — always visible.
///
/// Shows: Bean selection, Coffee weight, Water weight (and ratio badge).
/// In quick mode these three are all that's needed to log a brew.
///
/// Ref: docs/03_UI_Specification.md § 4.2 — Default Minimalism
class QuickParamsBar extends ConsumerWidget {
  const QuickParamsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brewLoggerControllerProvider);
    final ctrl = ref.read(brewLoggerControllerProvider.notifier);

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
        Row(
          children: [
            Expanded(
              child: _ParamColumn(
                label: 'Coffee',
                value: '${state.coffeeWeightG.toStringAsFixed(1)} g',
                child: AppSlider(
                  value: state.coffeeWeightG,
                  min: 5.0,
                  max: 100.0,
                  divisions: 190,
                  unit: 'g',
                  onChanged: ctrl.setCoffeeWeight,
                  semanticLabel: 'Coffee weight',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ParamColumn(
                label: 'Water',
                value: '${state.waterWeightG.toStringAsFixed(0)} g',
                child: AppSlider(
                  value: state.waterWeightG,
                  min: 50.0,
                  max: 600.0,
                  divisions: 110,
                  unit: 'g',
                  onChanged: ctrl.setWaterWeight,
                  semanticLabel: 'Water weight',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),

        // ── Ratio badge ──────────────────────────────────────────────────
        Align(
          alignment: Alignment.centerRight,
          child: _RatioBadge(ratio: state.ratio),
        ),
      ],
    );
  }
}

/// A labelled column containing a value display + a control widget.
class _ParamColumn extends StatelessWidget {
  const _ParamColumn({
    required this.label,
    required this.value,
    required this.child,
  });

  final String label;
  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.labelMedium),
            Text(
              value,
              style: AppTextStyles.numericValue.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
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
