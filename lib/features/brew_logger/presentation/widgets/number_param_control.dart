import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_slider.dart';
import '../../domain/entities/brew_param_definition.dart';

class NumberParamControl extends StatelessWidget {
  const NumberParamControl({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.range,
    required this.onChanged,
    this.semanticLabel,
    this.valueColor = AppColors.primary,
    this.allowClear = false,
  });

  final String label;
  final double? value;
  final String? unit;
  final BrewParamNumberRange range;
  final ValueChanged<double?> onChanged;
  final String? semanticLabel;
  final Color valueColor;
  final bool allowClear;

  @override
  Widget build(BuildContext context) {
    final sliderValue = range.initialValue(value);
    final displayValue = range.format(sliderValue);
    final normalizedUnit = (unit ?? '').trim();
    final valueText = normalizedUnit.isEmpty
        ? displayValue
        : '$displayValue $normalizedUnit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.labelMedium),
            InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              onTap: () => _openPreciseEditor(context, currentValue: value),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      valueText,
                      style: AppTextStyles.numericValue.copyWith(
                        color: valueColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Icon(Icons.edit_outlined, size: 14, color: valueColor),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppSlider(
          value: sliderValue,
          min: range.min,
          max: range.max,
          divisions: range.sliderDivisions,
          showValueLabel: false,
          unit: normalizedUnit,
          onChanged: (next) => onChanged(range.normalize(next)),
          semanticLabel: semanticLabel,
        ),
      ],
    );
  }

  Future<void> _openPreciseEditor(
    BuildContext context, {
    required double? currentValue,
  }) async {
    final result = await showDialog<_NumberEditResult>(
      context: context,
      builder: (dialogContext) => _NumberEditDialog(
        label: label,
        range: range,
        unit: unit,
        initialValue: currentValue,
        allowClear: allowClear,
      ),
    );
    if (result == null) return;

    if (result.clear) {
      onChanged(null);
      return;
    }

    if (!context.mounted) return;
    onChanged(result.value);
    if (result.wasSnapped) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            'Adjusted to nearest step: ${range.format(result.value)}'
            '${unit == null || unit!.isEmpty ? '' : ' ${unit!}'}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _NumberEditResult {
  const _NumberEditResult({
    required this.value,
    this.clear = false,
    this.wasSnapped = false,
  });

  final double value;
  final bool clear;
  final bool wasSnapped;
}

class _NumberEditDialog extends StatefulWidget {
  const _NumberEditDialog({
    required this.label,
    required this.range,
    required this.unit,
    required this.initialValue,
    required this.allowClear,
  });

  final String label;
  final BrewParamNumberRange range;
  final String? unit;
  final double? initialValue;
  final bool allowClear;

  @override
  State<_NumberEditDialog> createState() => _NumberEditDialogState();
}

class _NumberEditDialogState extends State<_NumberEditDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final initial = widget.range.initialValue(widget.initialValue);
    _controller = TextEditingController(text: widget.range.format(initial));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitText = widget.unit?.trim() ?? '';
    return AlertDialog(
      title: Text('Adjust ${widget.label}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: unitText.isEmpty ? 'Value' : 'Value ($unitText)',
              errorText: _errorText,
            ),
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.range.boundsLabel(unit: unitText),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        if (widget.allowClear)
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pop(const _NumberEditResult(value: 0, clear: true));
            },
            child: const Text('Clear'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Apply')),
      ],
    );
  }

  void _submit() {
    final raw = _controller.text.trim();
    if (raw.isEmpty) {
      if (widget.allowClear) {
        Navigator.of(
          context,
        ).pop(const _NumberEditResult(value: 0, clear: true));
        return;
      }
      setState(() => _errorText = 'Value is required.');
      return;
    }

    final parsed = double.tryParse(raw);
    if (parsed == null) {
      setState(() => _errorText = 'Please enter a valid number.');
      return;
    }
    if (!widget.range.contains(parsed)) {
      setState(
        () => _errorText =
            'Value must be between ${widget.range.min} and ${widget.range.max}.',
      );
      return;
    }

    final normalized = widget.range.normalize(parsed);
    Navigator.of(context).pop(
      _NumberEditResult(
        value: normalized,
        wasSnapped: (normalized - parsed).abs() > 0.000001,
      ),
    );
  }
}
