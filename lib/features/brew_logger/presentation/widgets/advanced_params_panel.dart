import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../features/inventory/presentation/widgets/smart_tag_field.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';
import '../../domain/entities/brew_record.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../controllers/brew_logger_controller.dart';
import '../models/brew_param_names.dart';
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

  @override
  void initState() {
    super.initState();
    final state = ref.read(brewLoggerControllerProvider);
    _pourMethodCtrl = TextEditingController(text: state.pourMethod ?? '');
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brewLoggerControllerProvider);
    final ctrl = ref.read(brewLoggerControllerProvider.notifier);
    final catalogAsync = ref.watch(brewParamCatalogProvider(state.brewMethod));
    final catalog = catalogAsync.asData?.value;
    final showWaterTemp =
        catalog?.isVisibleByName(BrewParamNames.waterTemp) ?? true;
    final showBloomTime =
        catalog?.isVisibleByName(BrewParamNames.bloomTime) ?? true;
    final showGrindSize =
        catalog?.isVisibleByName(BrewParamNames.grindSize) ?? true;
    final showPourMethod =
        catalog?.isVisibleByName(BrewParamNames.pourMethod) ?? true;
    final visibleDefinitions = catalog?.visibleDefinitions ?? const [];
    final waterTempDef = catalog?.definitionByName(BrewParamNames.waterTemp);
    final bloomDef = catalog?.definitionByName(BrewParamNames.bloomTime);
    final waterTempRange = _resolveNumberRange(
      method: state.brewMethod,
      name: BrewParamNames.waterTemp,
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
      name: BrewParamNames.bloomTime,
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
            label: 'Temp',
            value: state.waterTempC,
            unit: '°C',
            range: waterTempRange,
            onChanged: (value) {
              if (value == null) return;
              ctrl.setWaterTemp(value);
            },
            semanticLabel: 'Water temperature',
            valueColor: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Bloom Time ────────────────────────────────────────────────
        if (showBloomTime) ...[
          NumberParamControl(
            label: 'Bloom',
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
            semanticLabel: 'Bloom time in seconds',
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
            labelText: 'Grinder / Equipment',
            hintText: 'Select grinder...',
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
              label: 'Grind Clicks',
              value: state.grindClickValue,
              unit: state.grindSliderUnit,
              range: BrewParamNumberRange(
                min: state.grindSliderMin,
                max: state.grindSliderMax,
                step: state.grindSliderStep,
                defaultValue: state.grindClickValue,
              ),
              onChanged: ctrl.setGrindClickValue,
              semanticLabel: 'Grind click value',
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
            label: 'Pour Method',
            hint: 'e.g. Spiral, Pulse, Centre',
            onChanged: ctrl.setPourMethod,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grind Mode', style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        // Mode toggle chips
        Row(
          children: GrindMode.values.map((mode) {
            final selected = state.grindMode == mode;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: ChoiceChip(
                label: Text(_grindModeLabel(mode)),
                selected: selected,
                onSelected: (_) => ctrl.setGrindMode(mode),
                selectedColor: AppColors.primary,
                labelStyle: AppTextStyles.labelSmall.copyWith(
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
                side: BorderSide(
                  color: selected ? AppColors.primary : AppColors.shadowDark,
                ),
                backgroundColor: AppColors.background,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Mode-specific input
        if (state.grindMode == GrindMode.simple) ...[
          InputDecorator(
            decoration: _inputDecoration('Coarseness'),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.grindSimpleLabel,
                hint: const Text('Select coarseness'),
                isExpanded: true,
                isDense: true,
                items: _grindSimpleLabels
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: ctrl.setGrindSimpleLabel,
              ),
            ),
          ),
        ] else if (state.grindMode == GrindMode.pro) ...[
          TextFormField(
            initialValue: state.grindMicrons?.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Grind size (μm)'),
            onChanged: (v) => ctrl.setGrindMicrons(int.tryParse(v)),
          ),
        ],
      ],
    );
  }

  String _grindModeLabel(GrindMode mode) {
    switch (mode) {
      case GrindMode.equipment:
        return 'Grinder';
      case GrindMode.simple:
        return 'Simple';
      case GrindMode.pro:
        return 'Pro (μm)';
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    ),
    filled: true,
    fillColor: AppColors.surface,
  );
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
    required this.label,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
      onChanged: onChanged,
    );
  }
}

BrewParamNumberRange _resolveNumberRange({
  required BrewMethod method,
  required String name,
  required BrewParamDefinition? definition,
  required BrewParamNumberRange fallback,
}) {
  final fromDefinition = definition?.numberRange;
  if (fromDefinition != null) return fromDefinition;
  final fromTemplate = BrewParamDefaults.numberRangeFor(
    method: method,
    name: name,
  );
  return fromTemplate ?? fallback;
}
