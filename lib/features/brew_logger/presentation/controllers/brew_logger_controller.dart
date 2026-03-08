import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventory/inventory_providers.dart';
import '../../../inventory/domain/entities/equipment.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_record.dart';
import '../../domain/usecases/create_brew_record.dart';
import '../../domain/usecases/delete_brew_record.dart';
import '../../domain/usecases/update_brew_record.dart';

/// Page-level state for the BrewLogger screen.
class BrewLoggerState {
  const BrewLoggerState({
    this.beanName = '',
    this.equipmentId,
    this.selectedEquipmentName,
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
    this.isQuickMode = true,
    this.isAdvancedExpanded = false,
    this.isSaving = false,
    this.savedRecordId,
    this.errorMessage,
    // Preserved from the original record on edit — null when creating new.
    this.originalBrewDate,
    this.originalCreatedAt,
  });

  final String beanName;
  final int? equipmentId;

  /// Display name of the selected equipment (for the SmartTagField tags list).
  final String? selectedEquipmentName;

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
  final bool isQuickMode;
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
    Object? equipmentId = _sentinel,
    Object? selectedEquipmentName = _sentinel,
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
    bool? isQuickMode,
    bool? isAdvancedExpanded,
    bool? isSaving,
    Object? savedRecordId = _sentinel,
    Object? errorMessage = _sentinel,
    Object? originalBrewDate = _sentinel,
    Object? originalCreatedAt = _sentinel,
  }) {
    return BrewLoggerState(
      beanName: beanName ?? this.beanName,
      equipmentId: equipmentId == _sentinel
          ? this.equipmentId
          : equipmentId as int?,
      selectedEquipmentName: selectedEquipmentName == _sentinel
          ? this.selectedEquipmentName
          : selectedEquipmentName as String?,
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
      isQuickMode: isQuickMode ?? this.isQuickMode,
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

  @override
  BrewLoggerState build() {
    final repo = ref.watch(brewRepositoryProvider);
    _createBrewRecord = CreateBrewRecord(repo);
    _updateBrewRecord = UpdateBrewRecord(repo);
    _deleteBrewRecord = DeleteBrewRecord(repo);
    return const BrewLoggerState();
  }

  void setBeanName(String name) => state = state.copyWith(beanName: name);
  void setEquipmentId(int? id) => state = state.copyWith(equipmentId: id);

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
  void setCoffeeWeight(double grams) =>
      state = state.copyWith(coffeeWeightG: grams);
  void setWaterWeight(double grams) =>
      state = state.copyWith(waterWeightG: grams);
  void setWaterTemp(double celsius) =>
      state = state.copyWith(waterTempC: celsius);
  void setBrewDuration(int seconds) =>
      state = state.copyWith(brewDurationS: seconds);
  void setBloomTime(int? seconds) =>
      state = state.copyWith(bloomTimeS: seconds);
  void setPourMethod(String? method) =>
      state = state.copyWith(pourMethod: method);
  void setWaterType(String? type) => state = state.copyWith(waterType: type);
  void setRoomTemp(double? celsius) =>
      state = state.copyWith(roomTempC: celsius);
  void setNotes(String? notes) => state = state.copyWith(notes: notes);
  void setQuickMode(bool isQuick) =>
      state = state.copyWith(isQuickMode: isQuick);
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
      equipmentId: template.equipmentId,
      selectedEquipmentName: selectedEquipmentName,
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
      coffeeWeightG: template.coffeeWeightG,
      waterWeightG: template.waterWeightG,
      waterTempC: template.waterTempC,
      brewDurationS: template.brewDurationS,
      bloomTimeS: template.bloomTimeS,
      pourMethod: template.pourMethod,
      waterType: template.waterType,
      roomTempC: template.roomTempC,
      notes: template.notes,
      isQuickMode: template.isQuickMode,
      savedRecordId: null,
      errorMessage: null,
      originalBrewDate: null,
      originalCreatedAt: null,
    );
  }

  Future<int?> saveNewRecord({required int elapsedSeconds}) async {
    if (state.beanName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a bean name.');
      return null;
    }
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final now = DateTime.now();
      final record = BrewRecord(
        id: 0,
        brewDate: now,
        beanName: state.beanName.trim(),
        equipmentId: state.equipmentId,
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
        isQuickMode: state.isQuickMode,
        createdAt: now,
        updatedAt: now,
      );
      final id = await _createBrewRecord(record);

      // Increment use counts so autocomplete ranking stays accurate.
      await _incrementUseCounts();

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
      final record = BrewRecord(
        id: existingId,
        // Preserve the original brew date — only override editable fields.
        brewDate: originalBrewDate,
        beanName: state.beanName.trim(),
        equipmentId: state.equipmentId,
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
        isQuickMode: state.isQuickMode,
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
  Future<void> _incrementUseCounts() async {
    final inventoryRepo = ref.read(inventoryRepositoryProvider);
    // We don't have a beanId here; the inventory repo uses the name as the
    // unique lookup key when creating beans, so we search by name first.
    final beans = await inventoryRepo.searchBeans(state.beanName.trim());
    final matchedBean = beans.cast<dynamic>().firstWhere(
      (b) =>
          (b.name as String).toLowerCase() ==
          state.beanName.trim().toLowerCase(),
      orElse: () => null,
    );
    if (matchedBean != null) {
      await inventoryRepo.incrementBeanUseCount(matchedBean.id as int);
    }
    if (state.equipmentId != null) {
      await inventoryRepo.incrementEquipmentUseCount(state.equipmentId!);
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

const _recentTemplateLimit = 5;

/// Latest brew records used as "brew again" templates.
final recentBrewTemplatesProvider = StreamProvider<List<BrewRecord>>((ref) {
  final repo = ref.watch(brewRepositoryProvider);
  return repo.watchAllBrewRecords().map(
    (records) => records.take(_recentTemplateLimit).toList(growable: false),
  );
});
