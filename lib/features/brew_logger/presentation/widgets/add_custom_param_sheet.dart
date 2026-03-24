import 'package:flutter/material.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/brew_method.dart';

class AddCustomParamDraft {
  const AddCustomParamDraft({
    required this.name,
    required this.type,
    this.unit,
    this.numberMin,
    this.numberMax,
    this.numberStep,
    this.numberDefault,
  });

  final String name;
  final ParamType type;
  final String? unit;
  final double? numberMin;
  final double? numberMax;
  final double? numberStep;
  final double? numberDefault;
}

Future<AddCustomParamDraft?> showAddCustomParamSheet(
  BuildContext context, {
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<AddCustomParamDraft>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    builder: (_) => const _AddCustomParamSheet(),
  );
}

class _AddCustomParamSheet extends StatefulWidget {
  const _AddCustomParamSheet();

  @override
  State<_AddCustomParamSheet> createState() => _AddCustomParamSheetState();
}

class _AddCustomParamSheetState extends State<_AddCustomParamSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _stepController = TextEditingController();
  final _defaultController = TextEditingController();
  ParamType _selectedType = ParamType.number;

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _stepController.dispose();
    _defaultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final platformView = WidgetsBinding.instance.platformDispatcher.views.first;
    final keyboardInset =
        platformView.viewInsets.bottom / platformView.devicePixelRatio;
    final keyboardBottomGap = keyboardInset > 0
        ? AppSpacing.sm
        : AppSpacing.pageBottom;

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.pageHorizontal,
          right: AppSpacing.pageHorizontal,
          bottom: keyboardInset + keyboardBottomGap,
          top: AppSpacing.pageTop,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.brewAddParamSheetTitle,
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('add-param-name-field'),
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.commonName,
                  hintText: l10n.brewAddParamFieldNameHint,
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return l10n.brewAddParamValidationNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.brewAddParamFieldTypeLabel,
                style: AppTextStyles.labelMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: ParamType.values.map((type) {
                  final selected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(
                      type == ParamType.number
                          ? l10n.brewParamTypeNumber
                          : l10n.brewParamTypeText,
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedType = type),
                    selectedColor: AppColors.primary,
                    labelStyle: AppTextStyles.labelSmall.copyWith(
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                    side: BorderSide(
                      color: selected
                          ? AppColors.primary
                          : AppColors.shadowDark,
                    ),
                    backgroundColor: AppColors.background,
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('add-param-unit-field'),
                controller: _unitController,
                decoration: InputDecoration(
                  labelText: l10n.brewAddParamFieldUnitLabel,
                  hintText: l10n.brewAddParamFieldUnitHint,
                ),
              ),
              if (_selectedType == ParamType.number) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('add-param-min-field'),
                        controller: _minController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.brewAddParamFieldMinLabel,
                          hintText: '0',
                        ),
                        validator: _validateMin,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        key: const Key('add-param-max-field'),
                        controller: _maxController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.brewAddParamFieldMaxLabel,
                          hintText: '100',
                        ),
                        validator: _validateMax,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('add-param-step-field'),
                        controller: _stepController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.brewAddParamFieldStepLabel,
                          hintText: '1',
                        ),
                        validator: _validateStep,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        key: const Key('add-param-default-field'),
                        controller: _defaultController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.brewAddParamFieldDefaultLabel,
                          hintText: '10',
                        ),
                        validator: _validateDefault,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(l10n.brewActionAddParameter),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateMin(String? value) {
    if (_selectedType != ParamType.number) return null;
    final parsed = _tryParse(value);
    if (parsed == null) return context.l10n.brewAddParamValidationMinRequired;
    return null;
  }

  String? _validateMax(String? value) {
    if (_selectedType != ParamType.number) return null;
    final max = _tryParse(value);
    if (max == null) return context.l10n.brewAddParamValidationMaxRequired;
    final min = _tryParse(_minController.text);
    if (min != null && max <= min) {
      return context.l10n.brewAddParamValidationMaxGreaterThanMin;
    }
    return null;
  }

  String? _validateStep(String? value) {
    if (_selectedType != ParamType.number) return null;
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return null;
    final parsed = double.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return context.l10n.brewAddParamValidationStepPositive;
    }
    return null;
  }

  String? _validateDefault(String? value) {
    if (_selectedType != ParamType.number) return null;
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return null;
    final parsedDefault = double.tryParse(trimmed);
    if (parsedDefault == null) return context.l10n.brewErrorInvalidNumber;
    final min = _tryParse(_minController.text);
    final max = _tryParse(_maxController.text);
    if (min != null &&
        max != null &&
        (parsedDefault < min || parsedDefault > max)) {
      return context.l10n.brewAddParamValidationDefaultWithinRange;
    }
    return null;
  }

  double? _tryParse(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final min = _tryParse(_minController.text);
    final max = _tryParse(_maxController.text);
    final step = _tryParse(_stepController.text);
    final defaultValue = _tryParse(_defaultController.text);
    final draft = AddCustomParamDraft(
      name: _nameController.text.trim(),
      type: _selectedType,
      unit: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
      numberMin: _selectedType == ParamType.number ? min : null,
      numberMax: _selectedType == ParamType.number ? max : null,
      numberStep: _selectedType == ParamType.number ? step : null,
      numberDefault: _selectedType == ParamType.number ? defaultValue : null,
    );
    Navigator.of(context).pop(draft);
  }
}
