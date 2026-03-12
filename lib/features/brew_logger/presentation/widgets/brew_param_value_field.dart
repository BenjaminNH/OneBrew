import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../controllers/brew_logger_controller.dart';

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
    if (widget.definition.type == ParamType.number) {
      final number = widget.value?.valueNumber;
      if (number == null) return '';
      return number % 1 == 0 ? number.toStringAsFixed(0) : number.toString();
    }
    return widget.value?.valueText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.definition.name;
    final unit = widget.definition.unit;
    final isNumber = widget.definition.type == ParamType.number;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSpacing.xxs),
        TextField(
          controller: _controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: isNumber ? 'Enter value' : 'Enter text',
            suffixText: unit,
          ),
          onChanged: (value) {
            if (isNumber) {
              widget.onNumberChanged(double.tryParse(value));
            } else {
              widget.onTextChanged(value);
            }
          },
        ),
      ],
    );
  }
}
