import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventory/inventory_providers.dart';
import '../../../inventory/domain/entities/equipment.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../../domain/entities/brew_param_key.dart';
import '../../domain/entities/brew_param_value.dart';
import '../../domain/entities/brew_record.dart';
import '../../domain/repositories/brew_param_repository.dart';
import '../../domain/usecases/create_brew_record.dart';
import '../../domain/usecases/delete_brew_record.dart';
import '../../domain/usecases/update_brew_record.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';

class BrewParamValueDraft {
  const BrewParamValueDraft({
    required this.paramId,
    required this.type,
    this.valueNumber,
    this.valueText,
  });

  final int paramId;
  final ParamType type;
  final double? valueNumber;
  final String? valueText;

  BrewParamValueDraft copyWith({double? valueNumber, String? valueText}) {
    return BrewParamValueDraft(
      paramId: paramId,
      type: type,
      valueNumber: valueNumber ?? this.valueNumber,
      valueText: valueText ?? this.valueText,
    );
  }
}

/// Page-level state for the BrewLogger screen.
class BrewLoggerState {
  const BrewLoggerState({
    this.beanName = '',
    this.beanId,
    this.equipmentId,
    this.selectedEquipmentName,
    this.brewMethod = BrewMethod.pourOver,
    this.grindMode = GrindMode.equipment,
    this.grindClickValue,
    this.grindSimpleLabel,
    this.grindMicrons,
    this.grindMinClick,
    this.grindMaxClick,
    this.grindClickStep,
    this.grindClickUnit,
    this.coffeeWeightG = 15.0,
    this.waterWeightG = 225.0,
    this.waterTempC = 93.0,
    this.brewDurationS = 180,
    this.bloomTimeS,
    this.pourMethod,
    this.waterType,
    this.roomTempC,
    this.notes,
    this.paramValues = const {},
    this.isAdvancedExpanded = false,
    this.isSaving = false,
    this.savedRecordId,
    this.errorMessage,
    // Preserved from the original record on edit — null when creating new.
    this.originalBrewDate,
    this.originalCreatedAt,
  });

  final String beanName;
  final int? beanId;
  final int? equipmentId;

  /// Display name of the selected equipment (for the SmartTagField tags list).
  final String? selectedEquipmentName;

  /// Brew method selection (pour over / espresso / custom).
  final BrewMethod brewMethod;

  final GrindMode grindMode;
  final double? grindClickValue;
  final String? grindSimpleLabel;
  final int? grindMicrons;
  final double? grindMinClick;
  final double? grindMaxClick;
  final double? grindClickStep;
  final String? grindClickUnit;
  final double coffeeWeightG;
  final double waterWeightG;
  final double? waterTempC;
  final int brewDurationS;
  final int? bloomTimeS;
  final String? pourMethod;
  final String? waterType;
  final double? roomTempC;
  final String? notes;
  final Map<int, BrewParamValueDraft> paramValues;
  final bool isAdvancedExpanded;
  final bool isSaving;
  final int? savedRecordId;
  final String? errorMessage;

  /// Original brew date, preserved when editing an existing record.
  final DateTime? originalBrewDate;

  /// Original creation timestamp, preserved when editing an existing record.
  final DateTime? originalCreatedAt;

  double get ratio => coffeeWeightG > 0 ? waterWeightG / coffeeWeightG : 0;

  bool get hasValidGrindClickConfig {
    final min = grindMinClick;
    final max = grindMaxClick;
    final step = grindClickStep;
    return min != null && max != null && step != null && max > min && step > 0;
  }

  double get grindSliderMin => grindMinClick ?? 0;
  double get grindSliderMax => grindMaxClick ?? 50;
  double get grindSliderStep => grindClickStep ?? 0.5;

  String get grindSliderUnit {
    final unit = grindClickUnit?.trim();
    if (unit == null || unit.isEmpty) return 'clicks';
    return unit;
  }

  int get grindSliderDivisions {
    if (!hasValidGrindClickConfig) return 100;
    final raw = (grindSliderMax - grindSliderMin) / grindSliderStep;
    final rounded = raw.round();
    return rounded <= 0 ? 1 : rounded;
  }

  int get grindValueFractionDigits {
    final step = grindClickStep;
    if (step == null || step <= 0) return 1;
    final text = step.toString();
    if (!text.contains('.')) return 0;
    final fraction = text.split('.').last.replaceAll(RegExp(r'0+$'), '');
    if (fraction.isEmpty) return 0;
    if (fraction.length > 3) return 3;
    return fraction.length;
  }

  BrewLoggerState copyWith({
    String? beanName,
    Object? beanId = _sentinel,
    Object? equipmentId = _sentinel,
    Object? selectedEquipmentName = _sentinel,
    BrewMethod? brewMethod,
    GrindMode? grindMode,
    Object? grindClickValue = _sentinel,
    Object? grindSimpleLabel = _sentinel,
    Object? grindMicrons = _sentinel,
    Object? grindMinClick = _sentinel,
    Object? grindMaxClick = _sentinel,
    Object? grindClickStep = _sentinel,
    Object? grindClickUnit = _sentinel,
    double? coffeeWeightG,
    double? waterWeightG,
    Object? waterTempC = _sentinel,
    int? brewDurationS,
    Object? bloomTimeS = _sentinel,
    Object? pourMethod = _sentinel,
    Object? waterType = _sentinel,
    Object? roomTempC = _sentinel,
    Object? notes = _sentinel,
    Map<int, BrewParamValueDraft>? paramValues,
    bool? isAdvancedExpanded,
    bool? isSaving,
    Object? savedRecordId = _sentinel,
    Object? errorMessage = _sentinel,
    Object? originalBrewDate = _sentinel,
    Object? originalCreatedAt = _sentinel,
  }) {
    return BrewLoggerState(
      beanName: beanName ?? this.beanName,
      beanId: beanId == _sentinel ? this.beanId : beanId as int?,
      equipmentId: equipmentId == _sentinel
          ? this.equipmentId
          : equipmentId as int?,
      selectedEquipmentName: selectedEquipmentName == _sentinel
          ? this.selectedEquipmentName
          : selectedEquipmentName as String?,
      brewMethod: brewMethod ?? this.brewMethod,
      grindMode: grindMode ?? this.grindMode,
      grindClickValue: grindClickValue == _sentinel
          ? this.grindClickValue
          : grindClickValue as double?,
      grindSimpleLabel: grindSimpleLabel == _sentinel
          ? this.grindSimpleLabel
          : grindSimpleLabel as String?,
      grindMicrons: grindMicrons == _sentinel
          ? this.grindMicrons
          : grindMicrons as int?,
      grindMinClick: grindMinClick == _sentinel
          ? this.grindMinClick
          : grindMinClick as double?,
      grindMaxClick: grindMaxClick == _sentinel
          ? this.grindMaxClick
          : grindMaxClick as double?,
      grindClickStep: grindClickStep == _sentinel
          ? this.grindClickStep
          : grindClickStep as double?,
      grindClickUnit: grindClickUnit == _sentinel
          ? this.grindClickUnit
          : grindClickUnit as String?,
      coffeeWeightG: coffeeWeightG ?? this.coffeeWeightG,
      waterWeightG: waterWeightG ?? this.waterWeightG,
      waterTempC: waterTempC == _sentinel
          ? this.waterTempC
          : waterTempC as double?,
      brewDurationS: brewDurationS ?? this.brewDurationS,
      bloomTimeS: bloomTimeS == _sentinel
          ? this.bloomTimeS
          : bloomTimeS as int?,
      pourMethod: pourMethod == _sentinel
          ? this.pourMethod
          : pourMethod as String?,
      waterType: waterType == _sentinel ? this.waterType : waterType as String?,
      roomTempC: roomTempC == _sentinel ? this.roomTempC : roomTempC as double?,
      notes: notes == _sentinel ? this.notes : notes as String?,
      paramValues: paramValues ?? this.paramValues,
      isAdvancedExpanded: isAdvancedExpanded ?? this.isAdvancedExpanded,
      isSaving: isSaving ?? this.isSaving,
      savedRecordId: savedRecordId == _sentinel
          ? this.savedRecordId
          : savedRecordId as int?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      originalBrewDate: originalBrewDate == _sentinel
          ? this.originalBrewDate
          : originalBrewDate as DateTime?,
      originalCreatedAt: originalCreatedAt == _sentinel
          ? this.originalCreatedAt
          : originalCreatedAt as DateTime?,
    );
  }
}

const _sentinel = Object();

/// Controller for the BrewLogger page.
///
/// Uses [Notifier] from Riverpod 3.x for synchronous state management.
/// Ref: docs/05_Development_Plan.md § Phase 4 — brew_logger_controller
class BrewLoggerController extends Notifier<BrewLoggerState> {
  late CreateBrewRecord _createBrewRecord;
  late UpdateBrewRecord _updateBrewRecord;
  late DeleteBrewRecord _deleteBrewRecord;
  late BrewParamRepository _paramRepository;

  @override
  BrewLoggerState build() {
    final repo = ref.watch(brewRepositoryProvider);
    _paramRepository = ref.watch(brewParamRepositoryProvider);
    _createBrewRecord = CreateBrewRecord(repo);
    _updateBrewRecord = UpdateBrewRecord(repo);
    _deleteBrewRecord = DeleteBrewRecord(repo);
    return const BrewLoggerState();
  }

  void setBeanName(String name) {
    final trimmed = name.trim();
    final current = state.beanName.trim();
    final changed = trimmed.toLowerCase() != current.toLowerCase();
    state = state.copyWith(
      beanName: name,
      beanId: changed ? null : state.beanId,
    );
  }

  void setEquipmentId(int? id) => state = state.copyWith(equipmentId: id);
  void setBrewMethod(BrewMethod method) =>
      state = state.copyWith(brewMethod: method);

  /// Sets the selected equipment by name and resolves its ID from
  /// the inventory repository, then updates [grindClickValue] if the
  /// equipment has a defined click range.
  Future<void> setEquipmentByName(String? name) async {
    if (name == null || name.isEmpty) {
      state = state.copyWith(
        equipmentId: null,
        selectedEquipmentName: null,
        grindClickValue: null,
        grindMinClick: null,
        grindMaxClick: null,
        grindClickStep: null,
        grindClickUnit: null,
      );
      return;
    }
    final inventoryRepo = ref.read(inventoryRepositoryProvider);
    final equipments = await inventoryRepo.searchEquipments(name);
    Equipment? match;
    for (final equipment in equipments) {
      if (equipment.name.toLowerCase() == name.toLowerCase()) {
        match = equipment;
        break;
      }
    }

    if (match == null) {
      state = state.copyWith(
        selectedEquipmentName: name,
        equipmentId: null,
        grindClickValue: null,
        grindMinClick: null,
        grindMaxClick: null,
        grindClickStep: null,
        grindClickUnit: null,
      );
    } else {
      if (!_hasValidGrindClickConfig(match)) {
        // ADR-004 fallback: equipment without click calibration falls back
        // to simple mode.
        state = state.copyWith(
          selectedEquipmentName: match.name,
          equipmentId: match.id,
          grindMode: GrindMode.simple,
          grindClickValue: null,
          grindMinClick: null,
          grindMaxClick: null,
          grindClickStep: null,
          grindClickUnit: null,
        );
        return;
      }

      final min = match.grindMinClick!;
      final max = match.grindMaxClick!;
      final step = match.grindClickStep!;
      final defaultClick = _snapGrindClickValue(
        (min + max) / 2,
        min: min,
        max: max,
        step: step,
      );

      state = state.copyWith(
        selectedEquipmentName: match.name,
        equipmentId: match.id,
        grindClickValue: defaultClick,
        grindMinClick: min,
        grindMaxClick: max,
        grindClickStep: step,
        grindClickUnit: _normalizeGrindClickUnit(match.grindClickUnit),
      );
    }
  }

  void setGrindMode(GrindMode mode) {
    if (mode == GrindMode.equipment &&
        state.equipmentId != null &&
        !state.hasValidGrindClickConfig) {
      state = state.copyWith(
        grindMode: GrindMode.simple,
        grindClickValue: null,
        grindSimpleLabel: null,
        grindMicrons: null,
      );
      return;
    }

    state = state.copyWith(
      grindMode: mode,
      grindClickValue: null,
      grindSimpleLabel: null,
      grindMicrons: null,
    );
  }

  void setGrindClickValue(double? value) {
    if (value == null) {
      state = state.copyWith(grindClickValue: null);
      return;
    }

    var normalized = value;
    if (state.grindMode == GrindMode.equipment &&
        state.hasValidGrindClickConfig) {
      normalized = _snapGrindClickValue(
        value,
        min: state.grindSliderMin,
        max: state.grindSliderMax,
        step: state.grindSliderStep,
      );
    }

    state = state.copyWith(grindClickValue: normalized);
  }

  void setGrindSimpleLabel(String? label) =>
      state = state.copyWith(grindSimpleLabel: label);
  void setGrindMicrons(int? microns) =>
      state = state.copyWith(grindMicrons: microns);
  void setCoffeeWeight(double grams) {
    final name = state.brewMethod == BrewMethod.espresso
        ? BrewParamKeys.coffeeDose
        : BrewParamKeys.coffeeWeight;
    state = state.copyWith(
      coffeeWeightG: _normalizeTemplateNumber(paramKey: name, value: grams),
    );
  }

  void setWaterWeight(double grams) {
    final name = state.brewMethod == BrewMethod.espresso
        ? BrewParamKeys.yieldAmount
        : BrewParamKeys.waterWeight;
    state = state.copyWith(
      waterWeightG: _normalizeTemplateNumber(paramKey: name, value: grams),
    );
  }

  void setWaterTemp(double celsius) {
    state = state.copyWith(
      waterTempC: _normalizeTemplateNumber(
        paramKey: BrewParamKeys.waterTemp,
        value: celsius,
      ),
    );
  }

  void setBrewDuration(int seconds) {
    final name = state.brewMethod == BrewMethod.espresso
        ? BrewParamKeys.extractionTime
        : BrewParamKeys.brewTime;
    final normalized = _normalizeTemplateNumber(
      paramKey: name,
      value: seconds.toDouble(),
    ).round();
    state = state.copyWith(brewDurationS: normalized);
  }

  void setBloomTime(int? seconds) {
    if (seconds == null) {
      state = state.copyWith(bloomTimeS: null);
      return;
    }
    final normalized = _normalizeTemplateNumber(
      paramKey: BrewParamKeys.bloomTime,
      value: seconds.toDouble(),
    ).round();
    state = state.copyWith(bloomTimeS: normalized <= 0 ? null : normalized);
  }

  void setPourMethod(String? method) =>
      state = state.copyWith(pourMethod: method);
  void setWaterType(String? type) => state = state.copyWith(waterType: type);
  void setRoomTemp(double? celsius) =>
      state = state.copyWith(roomTempC: celsius);
  void setNotes(String? notes) => state = state.copyWith(notes: notes);
  void setParamNumberValue(int paramId, double? value) {
    final updated = Map<int, BrewParamValueDraft>.from(state.paramValues);
    if (value == null) {
      updated.remove(paramId);
    } else {
      final existing = updated[paramId];
      final type = existing?.type ?? ParamType.number;
      updated[paramId] =
          (existing ?? BrewParamValueDraft(paramId: paramId, type: type))
              .copyWith(valueNumber: value, valueText: null);
    }
    state = state.copyWith(paramValues: updated);
  }

  void setParamNumberValueByDefinition(
    BrewParamDefinition definition,
    double? value,
  ) {
    if (value == null) {
      setParamNumberValue(definition.id, null);
      return;
    }
    final normalized = _normalizeNumberByDefinition(
      definition: definition,
      value: value,
    );
    setParamNumberValue(definition.id, normalized);
  }

  void setParamTextValue(int paramId, String? value) {
    final updated = Map<int, BrewParamValueDraft>.from(state.paramValues);
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      updated.remove(paramId);
    } else {
      final existing = updated[paramId];
      final type = existing?.type ?? ParamType.text;
      updated[paramId] =
          (existing ?? BrewParamValueDraft(paramId: paramId, type: type))
              .copyWith(valueText: trimmed, valueNumber: null);
    }
    state = state.copyWith(paramValues: updated);
  }

  void toggleAdvancedExpanded() =>
      state = state.copyWith(isAdvancedExpanded: !state.isAdvancedExpanded);

  /// Applies a historical brew record as a reusable template for the form.
  ///
  /// This enables the "brew again" workflow from docs/00_Product_Brief.md.
  Future<void> applyTemplate(BrewRecord template) async {
    String? selectedEquipmentName;
    Equipment? selectedEquipment;

    if (template.equipmentId != null) {
      final equipments = await ref
          .read(inventoryRepositoryProvider)
          .getAllEquipments();
      for (final equipment in equipments) {
        if (equipment.id == template.equipmentId) {
          selectedEquipmentName = equipment.name;
          selectedEquipment = equipment;
          break;
        }
      }
    }

    final hasGrindConfig =
        selectedEquipment != null &&
        _hasValidGrindClickConfig(selectedEquipment);

    final resolvedGrindMode =
        template.grindMode == GrindMode.equipment && !hasGrindConfig
        ? GrindMode.simple
        : template.grindMode;

    double? resolvedGrindClickValue = template.grindClickValue;
    if (resolvedGrindMode == GrindMode.equipment && selectedEquipment != null) {
      final min = selectedEquipment.grindMinClick!;
      final max = selectedEquipment.grindMaxClick!;
      final step = selectedEquipment.grindClickStep!;
      resolvedGrindClickValue = _snapGrindClickValue(
        template.grindClickValue ?? (min + max) / 2,
        min: min,
        max: max,
        step: step,
      );
    } else if (resolvedGrindMode != GrindMode.equipment) {
      resolvedGrindClickValue = null;
    }

    state = state.copyWith(
      beanName: template.beanName,
      beanId: template.beanId,
      equipmentId: template.equipmentId,
      selectedEquipmentName: selectedEquipmentName,
      brewMethod: template.brewMethod,
      grindMode: resolvedGrindMode,
      grindClickValue: resolvedGrindClickValue,
      grindSimpleLabel: template.grindSimpleLabel,
      grindMicrons: template.grindMicrons,
      grindMinClick: hasGrindConfig ? selectedEquipment.grindMinClick : null,
      grindMaxClick: hasGrindConfig ? selectedEquipment.grindMaxClick : null,
      grindClickStep: hasGrindConfig ? selectedEquipment.grindClickStep : null,
      grindClickUnit: hasGrindConfig
          ? _normalizeGrindClickUnit(selectedEquipment.grindClickUnit)
          : null,
      coffeeWeightG: _normalizeTemplateNumber(
        paramKey: template.brewMethod == BrewMethod.espresso
            ? BrewParamKeys.coffeeDose
            : BrewParamKeys.coffeeWeight,
        value: template.coffeeWeightG,
      ),
      waterWeightG: _normalizeTemplateNumber(
        paramKey: template.brewMethod == BrewMethod.espresso
            ? BrewParamKeys.yieldAmount
            : BrewParamKeys.waterWeight,
        value: template.waterWeightG,
      ),
      waterTempC: template.waterTempC == null
          ? null
          : _normalizeTemplateNumber(
              paramKey: BrewParamKeys.waterTemp,
              value: template.waterTempC!,
            ),
      brewDurationS: template.brewDurationS,
      bloomTimeS: template.bloomTimeS == null
          ? null
          : _normalizeTemplateNumber(
              paramKey: BrewParamKeys.bloomTime,
              value: template.bloomTimeS!.toDouble(),
            ).round(),
      pourMethod: template.pourMethod,
      waterType: template.waterType,
      roomTempC: template.roomTempC,
      notes: template.notes,
      savedRecordId: null,
      errorMessage: null,
      originalBrewDate: null,
      originalCreatedAt: null,
    );
    await loadParamValuesForRecord(template.id);
  }

  /// Loads a historical brew by id and applies it as a template.
  Future<bool> applyTemplateByRecordId(int recordId) async {
    final record = await ref
        .read(brewRepositoryProvider)
        .getBrewRecordById(recordId);
    if (record == null) {
      state = state.copyWith(errorMessage: 'Template record not found.');
      return false;
    }
    await applyTemplate(record);
    return true;
  }

  Future<void> loadParamValuesForRecord(int recordId) async {
    try {
      final values = await _paramRepository.getParamValuesForBrew(recordId);
      if (values.isEmpty) {
        state = state.copyWith(paramValues: const {});
        return;
      }
      final updated = <int, BrewParamValueDraft>{};
      for (final value in values) {
        final def = await _paramRepository.getParamDefinitionById(
          value.paramId,
        );
        final type =
            def?.type ??
            (value.valueNumber != null ? ParamType.number : ParamType.text);
        updated[value.paramId] = BrewParamValueDraft(
          paramId: value.paramId,
          type: type,
          valueNumber: value.valueNumber,
          valueText: value.valueText,
        );
      }
      state = state.copyWith(paramValues: updated);
    } catch (_) {
      // Ignore param load failures; core template data still applies.
    }
  }

  Future<int?> saveNewRecord({required int elapsedSeconds}) async {
    if (state.beanName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a bean name.');
      return null;
    }
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final now = DateTime.now();
      final resolvedBeanId = await _resolveBeanIdForPersist();
      final record = BrewRecord(
        id: 0,
        brewDate: now,
        beanName: state.beanName.trim(),
        beanId: resolvedBeanId,
        equipmentId: state.equipmentId,
        brewMethod: state.brewMethod,
        grindMode: state.grindMode,
        grindClickValue: state.grindClickValue,
        grindSimpleLabel: state.grindSimpleLabel,
        grindMicrons: state.grindMicrons,
        coffeeWeightG: state.coffeeWeightG,
        waterWeightG: state.waterWeightG,
        waterTempC: state.waterTempC,
        brewDurationS: elapsedSeconds,
        bloomTimeS: state.bloomTimeS,
        pourMethod: state.pourMethod,
        waterType: state.waterType,
        roomTempC: state.roomTempC,
        notes: state.notes,
        createdAt: now,
        updatedAt: now,
      );
      final id = await _createBrewRecord(record);

      await _persistParamValues(
        brewRecordId: id,
        elapsedSeconds: elapsedSeconds,
      );

      // Increment use counts so autocomplete ranking stays accurate.
      await _incrementUseCounts(beanId: resolvedBeanId);

      state = state.copyWith(isSaving: false, savedRecordId: id);
      return id;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save record: $e',
      );
      return null;
    }
  }

  Future<bool> updateRecord({
    required int existingId,
    required int elapsedSeconds,
    // These timestamps come from the record that was loaded for editing.
    // Passing them explicitly avoids storing extra mutable state in this
    // controller while still preserving the historical data.
    required DateTime originalBrewDate,
    required DateTime originalCreatedAt,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final now = DateTime.now();
      final resolvedBeanId = await _resolveBeanIdForPersist();
      final record = BrewRecord(
        id: existingId,
        // Preserve the original brew date — only override editable fields.
        brewDate: originalBrewDate,
        beanName: state.beanName.trim(),
        beanId: resolvedBeanId,
        equipmentId: state.equipmentId,
        brewMethod: state.brewMethod,
        grindMode: state.grindMode,
        grindClickValue: state.grindClickValue,
        grindSimpleLabel: state.grindSimpleLabel,
        grindMicrons: state.grindMicrons,
        coffeeWeightG: state.coffeeWeightG,
        waterWeightG: state.waterWeightG,
        waterTempC: state.waterTempC,
        brewDurationS: elapsedSeconds,
        bloomTimeS: state.bloomTimeS,
        pourMethod: state.pourMethod,
        waterType: state.waterType,
        roomTempC: state.roomTempC,
        notes: state.notes,
        // Preserve the original creation timestamp.
        createdAt: originalCreatedAt,
        updatedAt: now,
      );
      final success = await _updateBrewRecord(record);
      state = state.copyWith(isSaving: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update record: $e',
      );
      return false;
    }
  }

  Future<bool> deleteRecord(int id) async {
    try {
      final deleted = await _deleteBrewRecord(id);
      return deleted > 0;
    } catch (_) {
      return false;
    }
  }

  void resetForm() => state = const BrewLoggerState();
  void clearError() => state = state.copyWith(errorMessage: null);

  // ── Private helpers ─────────────────────────────────────────────────────

  /// Increments use counts after a successful save, keeping the autocomplete
  /// ranking accurate.
  Future<void> _incrementUseCounts({required int? beanId}) async {
    final inventoryRepo = ref.read(inventoryRepositoryProvider);
    if (beanId != null) {
      await inventoryRepo.incrementBeanUseCount(beanId);
    }
    if (state.equipmentId != null) {
      await inventoryRepo.incrementEquipmentUseCount(state.equipmentId!);
    }
  }

  Future<int?> _resolveBeanIdForPersist() async {
    if (state.beanId != null) {
      return state.beanId;
    }

    final normalizedName = state.beanName.trim();
    if (normalizedName.isEmpty) {
      return null;
    }

    final inventoryRepo = ref.read(inventoryRepositoryProvider);
    final beans = await inventoryRepo.searchBeans(normalizedName);
    for (final bean in beans) {
      if (bean.name.trim().toLowerCase() == normalizedName.toLowerCase()) {
        return bean.id;
      }
    }
    return null;
  }

  Future<void> _persistParamValues({
    required int brewRecordId,
    required int elapsedSeconds,
  }) async {
    final definitions = await _paramRepository.getParamDefinitions(
      state.brewMethod,
    );
    if (definitions.isEmpty) return;

    final visibilities = await _paramRepository.getParamVisibilities(
      state.brewMethod,
    );
    final visibilityById = {
      for (final visibility in visibilities) visibility.paramId: visibility,
    };

    for (final definition in definitions) {
      final isVisible = visibilityById[definition.id]?.isVisible ?? true;
      if (!isVisible) continue;

      final value = _buildParamValue(
        definition: definition,
        brewRecordId: brewRecordId,
        elapsedSeconds: elapsedSeconds,
      );
      if (value == null) continue;
      await _paramRepository.createParamValue(value);
    }
  }

  BrewParamValue? _buildParamValue({
    required BrewParamDefinition definition,
    required int brewRecordId,
    required int elapsedSeconds,
  }) {
    switch (definition.resolvedParamKey) {
      case BrewParamKeys.coffeeWeight:
      case BrewParamKeys.coffeeDose:
        final normalizedCoffee = _normalizeNumberByDefinition(
          definition: definition,
          value: state.coffeeWeightG,
        );
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueNumber: normalizedCoffee,
        );
      case BrewParamKeys.waterWeight:
      case BrewParamKeys.yieldAmount:
        final normalizedWater = _normalizeNumberByDefinition(
          definition: definition,
          value: state.waterWeightG,
        );
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueNumber: normalizedWater,
        );
      case BrewParamKeys.brewRatio:
        if (state.coffeeWeightG <= 0) return null;
        final normalizedRatio = _normalizeNumberByDefinition(
          definition: definition,
          value: state.ratio,
        );
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueNumber: normalizedRatio,
        );
      case BrewParamKeys.waterTemp:
        if (state.waterTempC == null) return null;
        final normalizedTemp = _normalizeNumberByDefinition(
          definition: definition,
          value: state.waterTempC!,
        );
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueNumber: normalizedTemp,
        );
      case BrewParamKeys.brewTime:
      case BrewParamKeys.extractionTime:
        if (elapsedSeconds <= 0) return null;
        final normalizedBrewTime = _normalizeNumberByDefinition(
          definition: definition,
          value: elapsedSeconds.toDouble(),
        );
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueNumber: normalizedBrewTime,
        );
      case BrewParamKeys.bloomTime:
        if (state.bloomTimeS == null) return null;
        final normalizedBloomTime = _normalizeNumberByDefinition(
          definition: definition,
          value: state.bloomTimeS!.toDouble(),
        );
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueNumber: normalizedBloomTime,
        );
      case BrewParamKeys.pourMethod:
        final method = state.pourMethod?.trim();
        if (method == null || method.isEmpty) return null;
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueText: method,
        );
      case BrewParamKeys.grindSize:
        final grindValue = _formatGrindValueForParam();
        if (grindValue == null || grindValue.isEmpty) return null;
        return BrewParamValue(
          id: 0,
          brewRecordId: brewRecordId,
          paramId: definition.id,
          valueText: grindValue,
        );
    }

    final draft = state.paramValues[definition.id];
    if (draft == null) return null;
    if (definition.type == ParamType.number) {
      final valueNumber = draft.valueNumber;
      if (valueNumber == null) return null;
      final normalized = _normalizeNumberByDefinition(
        definition: definition,
        value: valueNumber,
      );
      return BrewParamValue(
        id: 0,
        brewRecordId: brewRecordId,
        paramId: definition.id,
        valueNumber: normalized,
      );
    }

    final valueText = draft.valueText?.trim();
    if (valueText == null || valueText.isEmpty) return null;
    return BrewParamValue(
      id: 0,
      brewRecordId: brewRecordId,
      paramId: definition.id,
      valueText: valueText,
    );
  }

  double _normalizeTemplateNumber({
    required String? paramKey,
    required double value,
  }) {
    final range = BrewParamDefaults.numberRangeFor(
      method: state.brewMethod,
      paramKey: paramKey,
    );
    if (range == null) return value;
    return range.normalize(value);
  }

  double _normalizeNumberByDefinition({
    required BrewParamDefinition definition,
    required double value,
  }) {
    final range = definition.numberRange;
    if (range == null) return value;
    return range.normalize(value);
  }

  String? _formatGrindValueForParam() {
    switch (state.grindMode) {
      case GrindMode.equipment:
        final clickValue = state.grindClickValue;
        if (clickValue == null) return null;
        final name = state.selectedEquipmentName ?? 'Grinder';
        final unit = state.grindSliderUnit;
        final formatted = clickValue.toStringAsFixed(
          state.grindValueFractionDigits,
        );
        return '$name · $formatted $unit';
      case GrindMode.simple:
        return state.grindSimpleLabel;
      case GrindMode.pro:
        final microns = state.grindMicrons;
        if (microns == null) return null;
        return '$microns μm';
    }
  }

  bool _hasValidGrindClickConfig(Equipment equipment) {
    final min = equipment.grindMinClick;
    final max = equipment.grindMaxClick;
    final step = equipment.grindClickStep;
    return min != null && max != null && step != null && max > min && step > 0;
  }

  String _normalizeGrindClickUnit(String? unit) {
    final normalized = unit?.trim();
    if (normalized == null || normalized.isEmpty) return 'clicks';
    return normalized;
  }

  double _snapGrindClickValue(
    double value, {
    required double min,
    required double max,
    required double step,
  }) {
    final clamped = value.clamp(min, max).toDouble();
    final steps = ((clamped - min) / step).round();
    final snapped = min + (steps * step);
    final bounded = snapped.clamp(min, max).toDouble();
    return double.parse(bounded.toStringAsFixed(4));
  }
}

/// Riverpod provider for [BrewLoggerController].
final brewLoggerControllerProvider =
    NotifierProvider<BrewLoggerController, BrewLoggerState>(
      BrewLoggerController.new,
    );

const _recentTemplateLimit = 3;

/// Latest brew records used as "brew again" templates.
final recentBrewTemplatesProvider = StreamProvider<List<BrewRecord>>((ref) {
  final repo = ref.watch(brewRepositoryProvider);
  return repo.watchAllBrewRecords().map(
    (records) => records.take(_recentTemplateLimit).toList(growable: false),
  );
});
