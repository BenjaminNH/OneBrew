import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/equipment.dart';

const _maxSegments = 1000;

/// DTO returned when the grinder form is submitted.
class GrinderFormResult {
  const GrinderFormResult({
    required this.name,
    required this.minClick,
    required this.maxClick,
    required this.clickStep,
    required this.clickUnit,
  });

  final String name;
  final double minClick;
  final double maxClick;
  final double clickStep;
  final String clickUnit;
}

/// Bottom sheet for creating/updating grinder configuration.
class GrinderFormSheet extends StatefulWidget {
  const GrinderFormSheet({super.key, this.initial});

  final Equipment? initial;

  @override
  State<GrinderFormSheet> createState() => _GrinderFormSheetState();
}

class _GrinderFormSheetState extends State<GrinderFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  late final TextEditingController _stepController;
  late final TextEditingController _unitController;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _minController = TextEditingController(
      text: initial?.grindMinClick?.toString() ?? '0',
    );
    _maxController = TextEditingController(
      text: initial?.grindMaxClick?.toString() ?? '40',
    );
    _stepController = TextEditingController(
      text: initial?.grindClickStep?.toString() ?? '1',
    );
    _unitController = TextEditingController(
      text: initial?.grindClickUnit?.trim().isNotEmpty == true
          ? initial!.grindClickUnit
          : 'clicks',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _stepController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.lg,
          AppSpacing.pageHorizontal,
          viewInsets.bottom + AppSpacing.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: AppSpacing.dragHandleWidth,
                  height: AppSpacing.dragHandleHeight,
                  decoration: BoxDecoration(
                    color: AppColors.textDisabled,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusCircle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _isEditing ? 'Edit Grinder' : 'Add Grinder',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                key: const Key('grinder-form-name'),
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter grinder name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('grinder-form-min'),
                      controller: _minController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Min click'),
                      validator: _validateMin,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      key: const Key('grinder-form-max'),
                      controller: _maxController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Max click'),
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
                      key: const Key('grinder-form-step'),
                      controller: _stepController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Step'),
                      validator: _validateStep,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      key: const Key('grinder-form-unit'),
                      controller: _unitController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: Text(_isEditing ? 'Save' : 'Create'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateMin(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    if (parsed == null) return 'Invalid';
    return null;
  }

  String? _validateMax(String? value) {
    final max = double.tryParse(value?.trim() ?? '');
    final min = double.tryParse(_minController.text.trim());
    if (max == null) return 'Invalid';
    if (min == null) return null;
    if (max <= min) return 'Must be > min';
    return null;
  }

  String? _validateStep(String? value) {
    final step = double.tryParse(value?.trim() ?? '');
    if (step == null) return 'Invalid';
    if (step <= 0) return 'Must be > 0';

    final min = double.tryParse(_minController.text.trim());
    final max = double.tryParse(_maxController.text.trim());
    if (min == null || max == null || max <= min) return null;

    final segments = (max - min) / step;
    if (!segments.isFinite || segments <= 0 || segments > _maxSegments) {
      return 'Range too large';
    }
    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final result = GrinderFormResult(
      name: _nameController.text.trim(),
      minClick: double.parse(_minController.text.trim()),
      maxClick: double.parse(_maxController.text.trim()),
      clickStep: double.parse(_stepController.text.trim()),
      clickUnit: _unitController.text.trim(),
    );
    Navigator.of(context).pop(result);
  }
}
