import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_slider.dart';
import '../../domain/entities/brew_param_definition.dart';

class NumberParamControl extends StatefulWidget {
  const NumberParamControl({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.range,
    required this.onChanged,
    this.semanticLabel,
    this.valueColor = AppColors.primary,
    this.allowClear = false,
    this.unrangedStep = 0.1,
    this.unrangedFractionDigits = 2,
  });

  final String label;
  final double? value;
  final String? unit;
  final BrewParamNumberRange? range;
  final ValueChanged<double?> onChanged;
  final String? semanticLabel;
  final Color valueColor;
  final bool allowClear;
  final double unrangedStep;
  final int unrangedFractionDigits;

  @override
  State<NumberParamControl> createState() => _NumberParamControlState();
}

class _NumberParamControlState extends State<NumberParamControl> {
  late final TextEditingController _unrangedController;

  bool get _isRanged => widget.range != null;

  @override
  void initState() {
    super.initState();
    _unrangedController = TextEditingController(
      text: _formatUnranged(widget.value),
    );
  }

  @override
  void didUpdateWidget(covariant NumberParamControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _formatUnranged(widget.value);
    if (_unrangedController.text != next) {
      _unrangedController.text = next;
    }
  }

  @override
  void dispose() {
    _unrangedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final range = widget.range;
    final sliderValue = range?.initialValue(widget.value);
    final displayValue = _isRanged
        ? range!.format(sliderValue!)
        : _formatUnranged(widget.value);
    final normalizedUnit = (widget.unit ?? '').trim();
    final valueText = normalizedUnit.isEmpty
        ? displayValue
        : '$displayValue $normalizedUnit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: AppTextStyles.labelMedium),
            InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              onTap: () =>
                  _openPreciseEditor(context, currentValue: widget.value),
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
                        color: widget.valueColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: widget.valueColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        if (_isRanged)
          AppSlider(
            value: sliderValue!,
            min: range!.min,
            max: range.max,
            divisions: range.sliderDivisions,
            showValueLabel: false,
            unit: normalizedUnit,
            onChanged: (next) => widget.onChanged(range.normalize(next)),
            semanticLabel: widget.semanticLabel,
          )
        else
          _buildUnrangedInput(normalizedUnit),
      ],
    );
  }

  Widget _buildUnrangedInput(String normalizedUnit) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppColors.debossedShadow,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove_rounded),
            onPressed: () => _applyStep(-widget.unrangedStep),
          ),
          Expanded(
            child: TextField(
              key: const Key('unranged-number-input'),
              controller: _unrangedController,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),
              ],
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: normalizedUnit.isEmpty ? null : normalizedUnit,
              ),
              onSubmitted: (_) => _commitUnrangedInput(),
              onEditingComplete: _commitUnrangedInput,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _applyStep(widget.unrangedStep),
          ),
        ],
      ),
    );
  }

  void _applyStep(double delta) {
    final current = widget.value ?? 0;
    final next = _normalizeUnranged(current + delta);
    _unrangedController.text = _formatUnranged(next);
    widget.onChanged(next);
  }

  void _commitUnrangedInput() {
    final raw = _unrangedController.text.trim();
    if (raw.isEmpty) {
      if (widget.allowClear) {
        widget.onChanged(null);
        return;
      }
      final fallback = _formatUnranged(widget.value ?? 0);
      _unrangedController.text = fallback;
      return;
    }
    final parsed = double.tryParse(raw);
    if (parsed == null) {
      _unrangedController.text = _formatUnranged(widget.value);
      return;
    }
    final normalized = _normalizeUnranged(parsed);
    _unrangedController.text = _formatUnranged(normalized);
    widget.onChanged(normalized);
  }

  double _normalizeUnranged(double value) {
    final step = widget.unrangedStep > 0 ? widget.unrangedStep : 0;
    if (step == 0) {
      return double.parse(value.toStringAsFixed(widget.unrangedFractionDigits));
    }
    final scaled = (value / step).round() * step;
    return double.parse(scaled.toStringAsFixed(widget.unrangedFractionDigits));
  }

  String _formatUnranged(double? value) {
    final resolved = value ?? 0;
    return resolved.toStringAsFixed(widget.unrangedFractionDigits);
  }

  Future<void> _openPreciseEditor(
    BuildContext context, {
    required double? currentValue,
  }) async {
    final l10n = context.l10n;
    final range = widget.range;
    final result = await showDialog<_NumberEditResult>(
      context: context,
      builder: (dialogContext) => _NumberEditDialog(
        label: widget.label,
        range: range,
        step: range?.step ?? widget.unrangedStep,
        unit: widget.unit,
        initialValue: currentValue,
        allowClear: widget.allowClear,
        unrangedFractionDigits: widget.unrangedFractionDigits,
      ),
    );
    if (result == null) return;

    if (result.clear) {
      widget.onChanged(null);
      return;
    }

    if (!context.mounted) return;
    widget.onChanged(result.value);
    if (result.wasSnapped && range != null) {
      final unitSuffix = widget.unit == null || widget.unit!.isEmpty
          ? ''
          : ' ${widget.unit!}';
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            l10n.brewAdjustedToNearestStep(
              range.format(result.value),
              unitSuffix,
            ),
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
    required this.step,
    required this.unit,
    required this.initialValue,
    required this.allowClear,
    required this.unrangedFractionDigits,
  });

  final String label;
  final BrewParamNumberRange? range;
  final double step;
  final String? unit;
  final double? initialValue;
  final bool allowClear;
  final int unrangedFractionDigits;

  @override
  State<_NumberEditDialog> createState() => _NumberEditDialogState();
}

class _NumberEditDialogState extends State<_NumberEditDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final initial =
        widget.range?.initialValue(widget.initialValue) ??
        widget.initialValue ??
        0;
    final initialText =
        widget.range?.format(initial) ??
        initial.toStringAsFixed(widget.unrangedFractionDigits);
    _controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final unitText = widget.unit?.trim() ?? '';
    return AlertDialog(
      title: Text(l10n.brewAdjustDialogTitle(widget.label)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: unitText.isEmpty
                  ? l10n.brewValueLabel
                  : l10n.brewValueLabelWithUnit(unitText),
              errorText: _errorText,
            ),
            autofocus: true,
          ),
          if (widget.range != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.range!.boundsLabel(unit: unitText),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
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
            child: Text(l10n.brewActionClear),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        TextButton(onPressed: _submit, child: Text(l10n.brewActionApply)),
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
      setState(() => _errorText = context.l10n.brewErrorValueRequired);
      return;
    }

    final parsed = double.tryParse(raw);
    if (parsed == null) {
      setState(() => _errorText = context.l10n.brewErrorInvalidNumber);
      return;
    }
    final range = widget.range;
    if (range != null && !range.contains(parsed)) {
      setState(
        () => _errorText = context.l10n.brewErrorValueOutOfRange(
          range.min,
          range.max,
        ),
      );
      return;
    }

    final normalized = _normalize(parsed);
    Navigator.of(context).pop(
      _NumberEditResult(
        value: normalized,
        wasSnapped: (normalized - parsed).abs() > 0.000001,
      ),
    );
  }

  double _normalize(double raw) {
    final range = widget.range;
    if (range != null) {
      return range.normalize(raw);
    }
    final step = widget.step > 0 ? widget.step : 0;
    if (step == 0) {
      return double.parse(raw.toStringAsFixed(widget.unrangedFractionDigits));
    }
    final snapped = (raw / step).round() * step;
    return double.parse(snapped.toStringAsFixed(widget.unrangedFractionDigits));
  }
}
