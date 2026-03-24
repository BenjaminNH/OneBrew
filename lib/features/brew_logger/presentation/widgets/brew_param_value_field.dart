import 'package:flutter/material.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_input_style.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../../domain/entities/brew_param_key.dart';
import '../models/brew_param_display.dart';
import '../controllers/brew_logger_controller.dart';
import 'number_param_control.dart';

class BrewParamValueField extends StatefulWidget {
  const BrewParamValueField({
    super.key,
    required this.definition,
    required this.value,
    this.loadTextSuggestions,
    this.suggestionVisibility = AppSuggestionVisibility.enabled,
    required this.onNumberChanged,
    required this.onTextChanged,
  });

  final BrewParamDefinition definition;
  final BrewParamValueDraft? value;
  final Future<List<String>> Function(BrewParamDefinition definition)?
  loadTextSuggestions;
  final AppSuggestionVisibility suggestionVisibility;
  final ValueChanged<double?> onNumberChanged;
  final ValueChanged<String?> onTextChanged;

  @override
  State<BrewParamValueField> createState() => _BrewParamValueFieldState();
}

class _BrewParamValueFieldState extends State<BrewParamValueField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  List<String> _textSuggestions = const [];
  int _suggestionsRequestId = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _initialText());
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
    _loadTextSuggestions();
  }

  @override
  void didUpdateWidget(covariant BrewParamValueField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextText = _initialText();
    if (_controller.text != nextText) {
      _controller.text = nextText;
    }
    if (oldWidget.definition != widget.definition) {
      _loadTextSuggestions();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _initialText() {
    return widget.value?.valueText ?? '';
  }

  bool get _shouldRenderSuggestions {
    if (widget.definition.type != ParamType.text) {
      return false;
    }
    if (!widget.suggestionVisibility.shouldRenderSuggestions) {
      return false;
    }
    final key = widget.definition.resolvedParamKey;
    return key != null && key.isNotEmpty;
  }

  Future<void> _loadTextSuggestions() async {
    if (!_shouldRenderSuggestions || widget.loadTextSuggestions == null) {
      if (_textSuggestions.isNotEmpty && mounted) {
        setState(() => _textSuggestions = const []);
      }
      return;
    }

    final requestId = ++_suggestionsRequestId;
    final loaded = await widget.loadTextSuggestions!(widget.definition);
    if (!mounted || requestId != _suggestionsRequestId) {
      return;
    }
    setState(() => _textSuggestions = _normalizeSuggestions(loaded));
  }

  List<String> _normalizeSuggestions(List<String> suggestions) {
    final normalized = <String>[];
    final seen = <String>{};
    for (final raw in suggestions) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      final key = trimmed.toLowerCase();
      if (!seen.add(key)) continue;
      normalized.add(trimmed);
      if (normalized.length >= 3) break;
    }
    return normalized;
  }

  void _applyTextSuggestion(String suggestion) {
    _controller.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    widget.onTextChanged(suggestion);
    _focusNode.unfocus();
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus &&
        _textSuggestions.isEmpty &&
        widget.loadTextSuggestions != null) {
      _loadTextSuggestions();
    }
    if (mounted) {
      setState(() {});
    }
  }

  BrewParamNumberRange? _resolveNumberRange() {
    final definitionRange = widget.definition.numberRange;
    if (definitionRange != null) return definitionRange;

    final templateRange = BrewParamDefaults.numberRangeFor(
      method: widget.definition.method,
      paramKey: widget.definition.resolvedParamKey,
    );
    if (templateRange != null) return templateRange;

    return null;
  }

  double _resolveUnrangedStep() {
    final step = widget.definition.numberStep;
    if (step != null && step > 0) {
      return step;
    }
    return 0.1;
  }

  int _resolveUnrangedFractionDigits() {
    final activeStep = widget.definition.numberStep;
    if (activeStep == null || activeStep <= 0) {
      return 2;
    }
    final fixed = activeStep.toStringAsFixed(4);
    final fraction = fixed.split('.').last.replaceAll(RegExp(r'0+$'), '');
    return fraction.isEmpty ? 0 : fraction.length;
  }

  BoxBorder _suggestionBorder({required bool focused, bool dropTop = false}) {
    final color = focused
        ? AppInputStyle.focusBorderColor
        : AppInputStyle.borderColor;
    final width = focused ? 1.9 : 1.15;
    return Border(
      left: BorderSide(color: color, width: width),
      right: BorderSide(color: color, width: width),
      bottom: BorderSide(color: color, width: width),
      top: dropTop ? BorderSide.none : BorderSide(color: color, width: width),
    );
  }

  InputDecoration _textDecoration({
    required String label,
    required String hint,
    String? suffixText,
    required bool attachSuggestions,
  }) {
    final base = AppInputStyle.decoration(
      labelText: label,
      hintText: hint,
      suffixText: suffixText,
    );
    if (!attachSuggestions) return base;
    final radius = const BorderRadius.vertical(
      top: Radius.circular(AppSpacing.radiusSm),
    );
    return base.copyWith(
      border: AppInputStyle.borderFor(
        AppInputStyle.borderColor,
      ).copyWith(borderRadius: radius),
      enabledBorder: AppInputStyle.borderFor(
        AppInputStyle.borderColor,
      ).copyWith(borderRadius: radius),
      focusedBorder: AppInputStyle.borderFor(
        AppInputStyle.focusBorderColor,
        width: 1.9,
      ).copyWith(borderRadius: radius),
      disabledBorder: AppInputStyle.borderFor(
        AppInputStyle.disabledBorderColor,
      ).copyWith(borderRadius: radius),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = localizedParamLabelForDefinition(widget.definition, l10n);
    final unit = widget.definition.unit;
    final isNumber = widget.definition.type == ParamType.number;
    final numberRange = _resolveNumberRange();
    final showTextSuggestions =
        !isNumber && _focusNode.hasFocus && _textSuggestions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNumber)
          NumberParamControl(
            label: label,
            value: widget.value?.valueNumber,
            unit: unit,
            range: numberRange,
            onChanged: widget.onNumberChanged,
            semanticLabel: l10n.brewSemanticValue(label.toLowerCase()),
            allowClear: true,
            unrangedStep: _resolveUnrangedStep(),
            unrangedFractionDigits: _resolveUnrangedFractionDigits(),
          )
        else ...[
          KeyedSubtree(
            key: Key('brew-param-text-field-shell-${widget.definition.id}'),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.text,
              decoration: _textDecoration(
                label: label,
                hint: l10n.brewTextFieldHintEnterText,
                suffixText: unit,
                attachSuggestions: showTextSuggestions,
              ),
              onChanged: (value) => widget.onTextChanged(value),
            ),
          ),
          if (showTextSuggestions) ...[
            Transform.translate(
              offset: const Offset(0, -1),
              child: Container(
                key: Key('brew-param-suggestion-list-${widget.definition.id}'),
                decoration:
                    AppInputStyle.surfaceDecoration(
                      border: _suggestionBorder(
                        focused: _focusNode.hasFocus,
                        dropTop: true,
                      ),
                      backgroundColor: AppInputStyle.shellColor,
                    ).copyWith(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(AppSpacing.radiusSm),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark.withValues(alpha: 0.14),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < _textSuggestions.length;
                      index++
                    )
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            key: Key(
                              'brew-param-suggestion-${widget.definition.id}-${_textSuggestions[index]}',
                            ),
                            onTap: () =>
                                _applyTextSuggestion(_textSuggestions[index]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _textSuggestions[index],
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < _textSuggestions.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.shadowDark.withValues(
                                alpha: 0.2,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
