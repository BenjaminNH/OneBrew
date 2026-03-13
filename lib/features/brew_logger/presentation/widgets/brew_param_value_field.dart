import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../controllers/brew_logger_controller.dart';
import 'number_param_control.dart';

class BrewParamValueField extends StatefulWidget {
  const BrewParamValueField({
    super.key,
    required this.definition,
    required this.value,
    required this.onNumberChanged,
    required this.onTextChanged,
  });

  final BrewParamDefinition definition;
  final BrewParamValueDraft? value;
  final ValueChanged<double?> onNumberChanged;
  final ValueChanged<String?> onTextChanged;

  @override
  State<BrewParamValueField> createState() => _BrewParamValueFieldState();
}

class _BrewParamValueFieldState extends State<BrewParamValueField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _initialText());
  }

  @override
  void didUpdateWidget(covariant BrewParamValueField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextText = _initialText();
    if (_controller.text != nextText) {
      _controller.text = nextText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _initialText() {
    return widget.value?.valueText ?? '';
  }

  BrewParamNumberRange _resolveNumberRange() {
    final definitionRange = widget.definition.numberRange;
    if (definitionRange != null) return definitionRange;

    final templateRange = BrewParamDefaults.numberRangeFor(
      method: widget.definition.method,
      name: widget.definition.name,
    );
    if (templateRange != null) return templateRange;

    final current = widget.value?.valueNumber;
    final fallbackMax = current == null || current <= 0 ? 100.0 : current * 2;
    return BrewParamNumberRange(
      min: 0.0,
      max: fallbackMax,
      step: 0.1,
      defaultValue: current,
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.definition.name;
    final unit = widget.definition.unit;
    final isNumber = widget.definition.type == ParamType.number;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNumber)
          NumberParamControl(
            label: label,
            value: widget.value?.valueNumber,
            unit: unit,
            range: _resolveNumberRange(),
            onChanged: widget.onNumberChanged,
            semanticLabel: '${label.toLowerCase()} value',
            allowClear: true,
          )
        else ...[
          Text(label, style: AppTextStyles.labelMedium),
          const SizedBox(height: AppSpacing.xxs),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter text',
              suffixText: unit,
            ),
            onChanged: (value) => widget.onTextChanged(value),
          ),
        ],
      ],
    );
  }
}
