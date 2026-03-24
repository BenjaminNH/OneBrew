import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_input_style.dart';
import '../../../../features/inventory/presentation/widgets/smart_tag_field.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';
import '../../domain/entities/brew_record.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../../domain/entities/brew_param_key.dart';
import '../controllers/brew_logger_controller.dart';
import '../models/grind_simple_label_localizer.dart';
import 'brew_param_extra_inputs.dart';
import 'number_param_control.dart';

/// Advanced parameters panel — revealed after tapping "Show more".
///
/// Contains: temperature, bloom time, grind mode, equipment selector,
/// pour method, water type, room temperature and notes.
///
/// Ref: docs/03_UI_Specification.md § 4.2 — Progressive Disclosure Inputs
class AdvancedParamsPanel extends ConsumerStatefulWidget {
  const AdvancedParamsPanel({super.key});

  @override
  ConsumerState<AdvancedParamsPanel> createState() =>
      _AdvancedParamsPanelState();
}

class _AdvancedParamsPanelState extends ConsumerState<AdvancedParamsPanel> {
  late TextEditingController _pourMethodCtrl;
  late FocusNode _pourMethodFocusNode;
  List<String> _pourMethodSuggestions = const [];
  int _pourMethodSuggestionRequestId = 0;
  BrewMethod? _suggestionMethod;

  @override
  void initState() {
    super.initState();
    final state = ref.read(brewLoggerControllerProvider);
    _pourMethodCtrl = TextEditingController(text: state.pourMethod ?? '');
    _pourMethodFocusNode = FocusNode()..addListener(_handlePourMethodFocus);
    _suggestionMethod = state.brewMethod;
    _loadPourMethodSuggestions(state.brewMethod);
  }

  @override
  void dispose() {
    _pourMethodFocusNode.removeListener(_handlePourMethodFocus);
    _pourMethodFocusNode.dispose();
    _pourMethodCtrl.dispose();
    super.dispose();
  }

  /// Synchronise [TextEditingController]s with the current Riverpod state.
  ///
  /// This is required after [BrewLoggerController.resetForm] because the
  /// controllers are only initialised once in [initState] and would otherwise
  /// still display the old text.
  void _syncControllersFromState(BrewLoggerState state) {
    final pourMethod = state.pourMethod ?? '';
    if (_pourMethodCtrl.text != pourMethod) _pourMethodCtrl.text = pourMethod;
  }

  void _handlePourMethodFocus() {
    if (_pourMethodFocusNode.hasFocus && _pourMethodSuggestions.isEmpty) {
      _loadPourMethodSuggestions(
        _suggestionMethod ?? ref.read(brewLoggerControllerProvider).brewMethod,
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadPourMethodSuggestions(BrewMethod method) async {
    final requestId = ++_pourMethodSuggestionRequestId;
    final suggestions = await ref
        .read(brewParamRepositoryProvider)
        .getTopTextParamSuggestions(
          method: method,
          paramKey: BrewParamKeys.pourMethod,
        );
    if (!mounted || requestId != _pourMethodSuggestionRequestId) {
      return;
    }
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
    setState(() => _pourMethodSuggestions = normalized);
  }

  void _applyPourMethodSuggestion(
    BrewLoggerController ctrl,
    String suggestion,
  ) {
    _pourMethodCtrl.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    ctrl.setPourMethod(suggestion);
    _pourMethodFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brewLoggerControllerProvider);
    final ctrl = ref.read(brewLoggerControllerProvider.notifier);
    final l10n = context.l10n;
    final catalogAsync = ref.watch(brewParamCatalogProvider(state.brewMethod));
    final catalog = catalogAsync.asData?.value;
    final showWaterTemp =
        catalog?.isVisibleByKey(BrewParamKeys.waterTemp) ?? true;
    final showBloomTime =
        catalog?.isVisibleByKey(BrewParamKeys.bloomTime) ?? true;
    final showGrindSize =
        catalog?.isVisibleByKey(BrewParamKeys.grindSize) ?? true;
    final showPourMethod =
        catalog?.isVisibleByKey(BrewParamKeys.pourMethod) ?? true;
    final showPourMethodSuggestions =
        _pourMethodFocusNode.hasFocus && _pourMethodSuggestions.isNotEmpty;
    if (_suggestionMethod != state.brewMethod) {
      _suggestionMethod = state.brewMethod;
      _loadPourMethodSuggestions(state.brewMethod);
    }
    final visibleDefinitions = catalog?.visibleDefinitions ?? const [];
    final waterTempDef = catalog?.definitionByKey(BrewParamKeys.waterTemp);
    final bloomDef = catalog?.definitionByKey(BrewParamKeys.bloomTime);
    final waterTempRange = _resolveNumberRange(
      method: state.brewMethod,
      paramKey: BrewParamKeys.waterTemp,
      definition: waterTempDef,
      fallback: const BrewParamNumberRange(
        min: 80.0,
        max: 100.0,
        step: 1.0,
        defaultValue: 93.0,
      ),
    );
    final bloomRange = _resolveNumberRange(
      method: state.brewMethod,
      paramKey: BrewParamKeys.bloomTime,
      definition: bloomDef,
      fallback: const BrewParamNumberRange(
        min: 0.0,
        max: 90.0,
        step: 1.0,
        defaultValue: 30.0,
      ),
    );

    // Keep text controllers in sync with state (handles resets).
    _syncControllersFromState(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionDivider(),

        // ── Water Temperature ─────────────────────────────────────────
        if (showWaterTemp) ...[
          NumberParamControl(
            label: l10n.brewAdvancedTempLabel,
            value: state.waterTempC,
            unit: '°C',
            range: waterTempRange,
            onChanged: (value) {
              if (value == null) return;
              ctrl.setWaterTemp(value);
            },
            semanticLabel: l10n.brewAdvancedTempSemantic,
            valueColor: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Bloom Time ────────────────────────────────────────────────
        if (showBloomTime) ...[
          NumberParamControl(
            label: l10n.brewAdvancedBloomLabel,
            value: state.bloomTimeS?.toDouble(),
            unit: 's',
            range: bloomRange,
            onChanged: (value) {
              if (value == null) {
                ctrl.setBloomTime(null);
                return;
              }
              final normalized = value.round();
              ctrl.setBloomTime(normalized <= 0 ? null : normalized);
            },
            semanticLabel: l10n.brewAdvancedBloomSemantic,
            valueColor: AppColors.textSecondary,
            allowClear: true,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Grind Mode ────────────────────────────────────────────────
        if (showGrindSize) ...[
          _GrindModeSection(state: state, ctrl: ctrl),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Equipment selector (only when grind mode = equipment) ────
        if (showGrindSize && state.grindMode == GrindMode.equipment) ...[
          SmartTagField(
            type: TagFieldType.equipment,
            // Show the currently selected equipment name as a tag.
            tags: state.selectedEquipmentName != null
                ? [state.selectedEquipmentName!]
                : [],
            labelText: l10n.brewAdvancedEquipmentLabel,
            hintText: l10n.brewAdvancedSelectGrinderHint,
            singleSelection: true,
            onTagsChanged: (tags) {
              // tags is empty when the user removes the selection.
              ctrl.setEquipmentByName(tags.isEmpty ? null : tags.first);
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Grind click value (visible once an equipment is linked) ─
          if (state.equipmentId != null && state.hasValidGrindClickConfig) ...[
            NumberParamControl(
              label: l10n.brewAdvancedGrindClicksLabel,
              value: state.grindClickValue,
              unit: state.grindSliderUnit,
              range: BrewParamNumberRange(
                min: state.grindSliderMin,
                max: state.grindSliderMax,
                step: state.grindSliderStep,
                defaultValue: state.grindClickValue,
              ),
              onChanged: ctrl.setGrindClickValue,
              semanticLabel: l10n.brewAdvancedGrindClicksSemantic,
              valueColor: AppColors.textSecondary,
              allowClear: true,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],

        // ── Pour Method ───────────────────────────────────────────────
        if (showPourMethod) ...[
          _LabeledTextField(
            controller: _pourMethodCtrl,
            focusNode: _pourMethodFocusNode,
            label: l10n.brewAdvancedPourMethodLabel,
            hint: l10n.brewAdvancedPourMethodHint,
            attachSuggestions: showPourMethodSuggestions,
            onChanged: ctrl.setPourMethod,
          ),
          if (showPourMethodSuggestions) ...[
            Transform.translate(
              offset: const Offset(0, -1),
              child: Container(
                key: const Key('pour-method-suggestion-list'),
                decoration:
                    _suggestionDecoration(
                      focused: _pourMethodFocusNode.hasFocus,
                      backgroundColor: AppInputStyle.shellColor,
                      dropTop: true,
                    ).copyWith(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < _pourMethodSuggestions.length;
                      index++
                    )
                      Column(
                        children: [
                          InkWell(
                            onTap: () => _applyPourMethodSuggestion(
                              ctrl,
                              _pourMethodSuggestions[index],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _pourMethodSuggestions[index],
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < _pourMethodSuggestions.length - 1)
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
          const SizedBox(height: AppSpacing.md),
        ],

        BrewParamExtraInputs(definitions: visibleDefinitions),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Grind Mode Sub-section
// ─────────────────────────────────────────────────────────────────────────────

const _grindSimpleLabels = [
  'Extra Fine',
  'Fine',
  'Medium Fine',
  'Medium',
  'Medium Coarse',
  'Coarse',
  'Extra Coarse',
];

class _GrindModeSection extends StatelessWidget {
  const _GrindModeSection({required this.state, required this.ctrl});
  final BrewLoggerState state;
  final BrewLoggerController ctrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.brewGrindModeLabel, style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        // Mode toggle buttons (equal-width, same structure as Brew Method)
        Row(
          children: [
            for (int index = 0; index < GrindMode.values.length; index++) ...[
              Expanded(
                child: _GrindModeOptionButton(
                  label: _grindModeLabel(context, GrindMode.values[index]),
                  selected: state.grindMode == GrindMode.values[index],
                  onPressed: () => ctrl.setGrindMode(GrindMode.values[index]),
                ),
              ),
              if (index < GrindMode.values.length - 1)
                const SizedBox(width: AppSpacing.xs),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Mode-specific input
        if (state.grindMode == GrindMode.simple) ...[
          _GrindInputShell(
            child: InputDecorator(
              decoration: _inputDecoration(l10n.brewAdvancedCoarsenessLabel),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.grindSimpleLabel,
                  hint: Text(l10n.brewAdvancedCoarsenessHint),
                  isExpanded: true,
                  isDense: true,
                  items: _grindSimpleLabels
                      .map(
                        (l) => DropdownMenuItem(
                          value: l,
                          child: Text(localizeGrindSimpleLabel(l10n, l)),
                        ),
                      )
                      .toList(),
                  onChanged: ctrl.setGrindSimpleLabel,
                ),
              ),
            ),
          ),
        ] else if (state.grindMode == GrindMode.pro) ...[
          _GrindInputShell(
            child: TextFormField(
              initialValue: state.grindMicrons?.toString() ?? '',
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(l10n.brewAdvancedGrindSizeLabel),
              onChanged: (v) => ctrl.setGrindMicrons(int.tryParse(v)),
            ),
          ),
        ],
      ],
    );
  }

  String _grindModeLabel(BuildContext context, GrindMode mode) {
    final l10n = context.l10n;
    switch (mode) {
      case GrindMode.equipment:
        return l10n.brewAdvancedGrindModeGrinder;
      case GrindMode.simple:
        return l10n.brewAdvancedGrindModeSimple;
      case GrindMode.pro:
        return l10n.brewAdvancedGrindModePro;
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: AppTextStyles.labelSmall.copyWith(
      color: AppColors.textSecondary,
    ),
    hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
  ).applyDefaults(AppInputStyle.theme());
}

class _GrindModeOptionButton extends StatelessWidget {
  const _GrindModeOptionButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: AppSpacing.buttonSmallHeight,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.shadowDark,
        ),
        boxShadow: selected ? AppColors.softShadow : const [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GrindInputShell extends StatelessWidget {
  const _GrindInputShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppInputStyle.surfaceDecoration(
        backgroundColor: AppInputStyle.shellColor,
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helper widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(
        color: AppColors.shadowDark.withValues(alpha: 0.5),
        thickness: 1,
      ),
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.attachSuggestions,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final bool attachSuggestions;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: 1,
      decoration: _pourMethodDecoration(
        label: label,
        hint: hint,
        attachSuggestions: attachSuggestions,
      ),
      onChanged: onChanged,
    );
  }
}

BoxDecoration _suggestionDecoration({
  required bool focused,
  required Color backgroundColor,
  required bool dropTop,
}) {
  final color = focused
      ? AppInputStyle.focusBorderColor
      : AppInputStyle.borderColor;
  final width = focused ? 1.9 : 1.15;
  return AppInputStyle.surfaceDecoration(
    backgroundColor: backgroundColor,
    border: Border(
      left: BorderSide(color: color, width: width),
      right: BorderSide(color: color, width: width),
      bottom: BorderSide(color: color, width: width),
      top: dropTop ? BorderSide.none : BorderSide(color: color, width: width),
    ),
  ).copyWith(
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowDark.withValues(alpha: 0.14),
        offset: const Offset(0, 4),
        blurRadius: 8,
      ),
    ],
  );
}

InputDecoration _pourMethodDecoration({
  required String label,
  required String hint,
  required bool attachSuggestions,
}) {
  final base = AppInputStyle.decoration(labelText: label, hintText: hint);
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

BrewParamNumberRange _resolveNumberRange({
  required BrewMethod method,
  required String paramKey,
  required BrewParamDefinition? definition,
  required BrewParamNumberRange fallback,
}) {
  final fromDefinition = definition?.numberRange;
  if (fromDefinition != null) return fromDefinition;
  final fromTemplate = BrewParamDefaults.numberRangeFor(
    method: method,
    paramKey: paramKey,
  );
  return fromTemplate ?? fallback;
}
