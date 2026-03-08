import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_slider.dart';
import '../../../../features/inventory/presentation/widgets/smart_tag_field.dart';
import '../../domain/entities/brew_record.dart';
import '../controllers/brew_logger_controller.dart';

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
  late TextEditingController _notesCtrl;
  late TextEditingController _pourMethodCtrl;
  late TextEditingController _waterTypeCtrl;

  @override
  void initState() {
    super.initState();
    final state = ref.read(brewLoggerControllerProvider);
    _notesCtrl = TextEditingController(text: state.notes ?? '');
    _pourMethodCtrl = TextEditingController(text: state.pourMethod ?? '');
    _waterTypeCtrl = TextEditingController(text: state.waterType ?? '');
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _pourMethodCtrl.dispose();
    _waterTypeCtrl.dispose();
    super.dispose();
  }

  /// Synchronise [TextEditingController]s with the current Riverpod state.
  ///
  /// This is required after [BrewLoggerController.resetForm] because the
  /// controllers are only initialised once in [initState] and would otherwise
  /// still display the old text.
  void _syncControllersFromState(BrewLoggerState state) {
    final notes = state.notes ?? '';
    if (_notesCtrl.text != notes) _notesCtrl.text = notes;

    final pourMethod = state.pourMethod ?? '';
    if (_pourMethodCtrl.text != pourMethod) _pourMethodCtrl.text = pourMethod;

    final waterType = state.waterType ?? '';
    if (_waterTypeCtrl.text != waterType) _waterTypeCtrl.text = waterType;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brewLoggerControllerProvider);
    final ctrl = ref.read(brewLoggerControllerProvider.notifier);

    // Keep text controllers in sync with state (handles resets).
    _syncControllersFromState(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionDivider(),

        // ── Water Temperature ─────────────────────────────────────────
        _ParamRow(
          label: 'Temp',
          valueText: state.waterTempC != null
              ? '${state.waterTempC!.round()}°C'
              : 'off',
          child: AppSlider(
            value: state.waterTempC ?? 93.0,
            min: 60.0,
            max: 100.0,
            divisions: 40,
            unit: '°C',
            onChanged: ctrl.setWaterTemp,
            semanticLabel: 'Water temperature',
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Bloom Time ────────────────────────────────────────────────
        _ParamRow(
          label: 'Bloom',
          valueText: state.bloomTimeS != null ? '${state.bloomTimeS}s' : 'off',
          child: AppSlider(
            value: (state.bloomTimeS ?? 0).toDouble(),
            min: 0,
            max: 90,
            divisions: 18,
            unit: 's',
            onChanged: (v) =>
                ctrl.setBloomTime(v.round() == 0 ? null : v.round()),
            semanticLabel: 'Bloom time in seconds',
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Grind Mode ────────────────────────────────────────────────
        _GrindModeSection(state: state, ctrl: ctrl),
        const SizedBox(height: AppSpacing.md),

        // ── Equipment selector (only when grind mode = equipment) ────
        if (state.grindMode == GrindMode.equipment) ...[
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
            _ParamRow(
              label: 'Grind Clicks',
              valueText: _formatGrindClickValue(state),
              child: AppSlider(
                value: state.grindClickValue ?? state.grindSliderMin,
                min: state.grindSliderMin,
                max: state.grindSliderMax,
                divisions: state.grindSliderDivisions,
                unit: state.grindSliderUnit,
                onChanged: ctrl.setGrindClickValue,
                semanticLabel: 'Grind click value',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],

        // ── Pour Method ───────────────────────────────────────────────
        _LabeledTextField(
          controller: _pourMethodCtrl,
          label: 'Pour Method',
          hint: 'e.g. Spiral, Pulse, Centre',
          onChanged: ctrl.setPourMethod,
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Water Type ────────────────────────────────────────────────
        _LabeledTextField(
          controller: _waterTypeCtrl,
          label: 'Water Type',
          hint: 'e.g. Filtered, Mineral',
          onChanged: ctrl.setWaterType,
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Room Temperature ──────────────────────────────────────────
        _ParamRow(
          label: 'Room Temp',
          valueText: state.roomTempC != null
              ? '${state.roomTempC!.round()}°C'
              : 'off',
          child: AppSlider(
            value: state.roomTempC ?? 22.0,
            min: 10.0,
            max: 40.0,
            divisions: 30,
            unit: '°C',
            onChanged: ctrl.setRoomTemp,
            semanticLabel: 'Room temperature',
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Notes ─────────────────────────────────────────────────────
        _LabeledTextField(
          controller: _notesCtrl,
          label: 'Notes',
          hint: 'Any observations...',
          maxLines: 3,
          onChanged: ctrl.setNotes,
        ),
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

String _formatGrindClickValue(BrewLoggerState state) {
  final clickValue = state.grindClickValue;
  if (clickValue == null) return '—';
  return '${clickValue.toStringAsFixed(state.grindValueFractionDigits)} '
      '${state.grindSliderUnit}';
}

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

class _ParamRow extends StatelessWidget {
  const _ParamRow({
    required this.label,
    required this.valueText,
    required this.child,
  });

  final String label;
  final String valueText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.labelMedium),
            Text(
              valueText,
              style: AppTextStyles.numericValue.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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
