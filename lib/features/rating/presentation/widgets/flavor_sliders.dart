import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_slider.dart';

class FlavorSliders extends StatelessWidget {
  const FlavorSliders({
    super.key,
    required this.acidity,
    required this.sweetness,
    required this.bitterness,
    required this.body,
    required this.onAcidityChanged,
    required this.onSweetnessChanged,
    required this.onBitternessChanged,
    required this.onBodyChanged,
  });

  final double acidity;
  final double sweetness;
  final double bitterness;
  final double body;
  final ValueChanged<double> onAcidityChanged;
  final ValueChanged<double> onSweetnessChanged;
  final ValueChanged<double> onBitternessChanged;
  final ValueChanged<double> onBodyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Professional Scores', style: AppTextStyles.titleLarge),
        const SizedBox(height: AppSpacing.md),
        _FlavorSliderRow(
          label: 'Acidity',
          value: acidity,
          onChanged: onAcidityChanged,
          semanticLabel: 'Acidity score',
        ),
        const SizedBox(height: AppSpacing.sm),
        _FlavorSliderRow(
          label: 'Sweetness',
          value: sweetness,
          onChanged: onSweetnessChanged,
          semanticLabel: 'Sweetness score',
        ),
        const SizedBox(height: AppSpacing.sm),
        _FlavorSliderRow(
          label: 'Bitterness',
          value: bitterness,
          onChanged: onBitternessChanged,
          semanticLabel: 'Bitterness score',
        ),
        const SizedBox(height: AppSpacing.sm),
        _FlavorSliderRow(
          label: 'Body',
          value: body,
          onChanged: onBodyChanged,
          semanticLabel: 'Body score',
        ),
      ],
    );
  }
}

class _FlavorSliderRow extends StatelessWidget {
  const _FlavorSliderRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.titleMedium),
            Text(
              value.toStringAsFixed(1),
              style: AppTextStyles.numericValue.copyWith(
                color: AppColors.primaryDark,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppSlider(
          value: value.clamp(0.0, 10.0),
          min: 0.0,
          max: 10.0,
          divisions: 20,
          showValueLabel: false,
          onChanged: onChanged,
          semanticLabel: semanticLabel,
        ),
      ],
    );
  }
}
