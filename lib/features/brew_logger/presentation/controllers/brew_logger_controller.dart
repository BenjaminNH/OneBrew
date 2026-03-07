import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/brew_repository_impl.dart';
import '../../domain/entities/brew_record.dart';
import '../../domain/usecases/create_brew_record.dart';
import '../../domain/usecases/delete_brew_record.dart';
import '../../domain/usecases/update_brew_record.dart';

/// Page-level state for the BrewLogger screen.
class BrewLoggerState {
  const BrewLoggerState({
    this.beanName = '',
    this.equipmentId,
    this.grindMode = GrindMode.equipment,
    this.grindClickValue,
    this.grindSimpleLabel,
    this.grindMicrons,
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
  });

  final String beanName;
  final int? equipmentId;
  final GrindMode grindMode;
  final double? grindClickValue;
  final String? grindSimpleLabel;
  final int? grindMicrons;
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

  double get ratio => coffeeWeightG > 0 ? waterWeightG / coffeeWeightG : 0;

  BrewLoggerState copyWith({
    String? beanName,
    Object? equipmentId = _sentinel,
    GrindMode? grindMode,
    Object? grindClickValue = _sentinel,
    Object? grindSimpleLabel = _sentinel,
    Object? grindMicrons = _sentinel,
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
  }) {
    return BrewLoggerState(
      beanName: beanName ?? this.beanName,
      equipmentId: equipmentId == _sentinel
          ? this.equipmentId
          : equipmentId as int?,
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

  void setGrindMode(GrindMode mode) => state = state.copyWith(
    grindMode: mode,
    grindClickValue: null,
    grindSimpleLabel: null,
    grindMicrons: null,
  );

  void setGrindClickValue(double? value) =>
      state = state.copyWith(grindClickValue: value);
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
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final now = DateTime.now();
      final record = BrewRecord(
        id: existingId,
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
}

/// Riverpod provider for [BrewLoggerController].
final brewLoggerControllerProvider =
    NotifierProvider<BrewLoggerController, BrewLoggerState>(
      BrewLoggerController.new,
    );
