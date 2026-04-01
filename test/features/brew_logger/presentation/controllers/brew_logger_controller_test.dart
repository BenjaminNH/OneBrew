// Regression tests covering P1 fixes from CR_2026-03-08_Phase4_BrewLogger:
//
//  1. [P1] updateRecord must preserve originalBrewDate and originalCreatedAt.
//  2. [P1] saveNewRecord must call incrementBeanUseCount and
//     incrementEquipmentUseCount after a successful save.
//  3. [P1] setEquipmentByName must write the resolved equipmentId back to state.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// mockito used transitively via mock_repositories.mocks.dart
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_key.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_value.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_visibility.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/inventory/domain/entities/bean.dart';
import 'package:one_brew/features/inventory/domain/entities/equipment.dart';
import 'package:one_brew/features/inventory/inventory_providers.dart';

import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/fake_brew_param_repository.dart';

// ---------------------------------------------------------------------------
// A minimal fake BrewRepository that records the companion passed to update.
// ---------------------------------------------------------------------------
class _FakeBrewRepo extends MockBrewRepository {
  _FakeBrewRepo({Map<int, BrewRecord>? recordsById})
    : _recordsById = recordsById ?? const {};

  BrewRecord? lastCreatedRecord;
  BrewRecord? lastUpdatedRecord;
  final Map<int, BrewRecord> _recordsById;

  @override
  Future<int> createBrewRecord(BrewRecord? record) async {
    lastCreatedRecord = record;
    return 99;
  }

  @override
  Future<bool> updateBrewRecord(BrewRecord? record) async {
    lastUpdatedRecord = record;
    return true;
  }

  @override
  Stream<List<BrewRecord>> watchAllBrewRecords() => const Stream.empty();

  @override
  Future<BrewRecord?> getBrewRecordById(int? id) async {
    if (id == null) return null;
    return _recordsById[id];
  }
}

// ---------------------------------------------------------------------------
// A minimal fake InventoryRepository that records increment calls.
// ---------------------------------------------------------------------------
class _FakeInventoryRepo extends MockInventoryRepository {
  final List<int> beanIncrements = [];
  final List<int> equipmentIncrements = [];

  final List<Bean> _beans;
  final List<Equipment> _equipments;

  _FakeInventoryRepo({List<Bean>? beans, List<Equipment>? equipments})
    : _beans = beans ?? [],
      _equipments = equipments ?? [];

  @override
  Future<List<Bean>> searchBeans(String? query) async => _beans
      .where(
        (b) =>
            query == null || b.name.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();

  @override
  Future<List<Equipment>> getAllEquipments() async => _equipments;

  @override
  Future<List<Equipment>> searchEquipments(String? query) async => _equipments
      .where(
        (e) =>
            query == null || e.name.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();

  @override
  Future<void> incrementBeanUseCount(int? id) async {
    beanIncrements.add(id as int);
  }

  @override
  Future<void> incrementEquipmentUseCount(int? id) async {
    equipmentIncrements.add(id as int);
  }
}

// ---------------------------------------------------------------------------
// Helper to create a ProviderContainer with overrides
// ---------------------------------------------------------------------------
ProviderContainer _makeContainer({
  _FakeBrewRepo? brewRepo,
  _FakeInventoryRepo? inventoryRepo,
  FakeBrewParamRepository? brewParamRepo,
}) {
  final brew = brewRepo ?? _FakeBrewRepo();
  final inventory = inventoryRepo ?? _FakeInventoryRepo();
  final brewParam = brewParamRepo ?? FakeBrewParamRepository();
  return ProviderContainer(
    overrides: [
      brewRepositoryProvider.overrideWithValue(brew),
      inventoryRepositoryProvider.overrideWithValue(inventory),
      brewParamRepositoryProvider.overrideWithValue(brewParam),
    ],
  );
}

void main() {
  group('BrewLoggerController — P1 regression tests', () {
    // ────────────────────────────────────────────────────────────────────────
    // [P1-1] updateRecord timestamp preservation
    // ────────────────────────────────────────────────────────────────────────
    group('updateRecord preserves original timestamps', () {
      test(
        'brewDate and createdAt are taken from arguments, not DateTime.now()',
        () async {
          final fakeBrewRepo = _FakeBrewRepo();
          final container = _makeContainer(brewRepo: fakeBrewRepo);
          addTearDown(container.dispose);

          final originalBrewDate = DateTime(2024, 6, 15, 9, 0);
          final originalCreatedAt = DateTime(2024, 6, 15, 9, 0, 1);

          container
              .read(brewLoggerControllerProvider.notifier)
              .setBeanName('Ethiopia Yirgacheffe');

          await container
              .read(brewLoggerControllerProvider.notifier)
              .updateRecord(
                existingId: 7,
                elapsedSeconds: 200,
                originalBrewDate: originalBrewDate,
                originalCreatedAt: originalCreatedAt,
              );

          final saved = fakeBrewRepo.lastUpdatedRecord!;
          expect(
            saved.brewDate,
            equals(originalBrewDate),
            reason: 'brewDate must not be overwritten with DateTime.now()',
          );
          expect(
            saved.createdAt,
            equals(originalCreatedAt),
            reason: 'createdAt must not be overwritten with DateTime.now()',
          );
          // updatedAt should be fresh (just check it is after originalCreatedAt).
          expect(
            saved.updatedAt.isAfter(originalCreatedAt),
            isTrue,
            reason: 'updatedAt must be refreshed on every update',
          );
        },
      );
    });

    // ────────────────────────────────────────────────────────────────────────
    // [P1-3] useCount increments after saveNewRecord
    // ────────────────────────────────────────────────────────────────────────
    group('saveNewRecord increments use counts', () {
      late _FakeBrewRepo fakeBrewRepo;
      late _FakeInventoryRepo fakeInventoryRepo;
      late ProviderContainer container;

      final testBean = Bean(
        id: 10,
        name: 'Colombia',
        addedAt: DateTime(2024),
        useCount: 3,
      );
      final testEquipment = Equipment(
        id: 20,
        name: 'Comandante C40',
        isGrinder: true,
        addedAt: DateTime(2024),
        useCount: 1,
      );

      setUp(() {
        fakeBrewRepo = _FakeBrewRepo();
        fakeInventoryRepo = _FakeInventoryRepo(
          beans: [testBean],
          equipments: [testEquipment],
        );
        container = _makeContainer(
          brewRepo: fakeBrewRepo,
          inventoryRepo: fakeInventoryRepo,
        );
      });

      tearDown(() => container.dispose());

      test('bean useCount is incremented after save', () async {
        container
            .read(brewLoggerControllerProvider.notifier)
            .setBeanName('Colombia');

        await container
            .read(brewLoggerControllerProvider.notifier)
            .saveNewRecord(elapsedSeconds: 180);

        expect(
          fakeInventoryRepo.beanIncrements,
          contains(10),
          reason: 'incrementBeanUseCount(10) should be called after save',
        );
      });

      test(
        'equipment useCount is incremented when equipmentId is set',
        () async {
          final ctrl = container.read(brewLoggerControllerProvider.notifier);
          ctrl.setBeanName('Colombia');
          ctrl.setEquipmentId(20);

          await ctrl.saveNewRecord(elapsedSeconds: 180);

          expect(
            fakeInventoryRepo.equipmentIncrements,
            contains(20),
            reason:
                'incrementEquipmentUseCount(20) should be called after save',
          );
        },
      );

      test(
        'equipment useCount is NOT incremented when no equipment is set',
        () async {
          final ctrl = container.read(brewLoggerControllerProvider.notifier);
          ctrl.setBeanName('Colombia');
          // No equipment selected.

          await ctrl.saveNewRecord(elapsedSeconds: 180);

          expect(
            fakeInventoryRepo.equipmentIncrements,
            isEmpty,
            reason:
                'No equipment increment should fire when equipmentId is null',
          );
        },
      );
    });

    // ────────────────────────────────────────────────────────────────────────
    // [P1-2] setEquipmentByName resolves ID and sets state
    // ────────────────────────────────────────────────────────────────────────
    group('setEquipmentByName resolves equipment ID', () {
      test('sets equipmentId when a matching equipment is found', () async {
        final equip = Equipment(
          id: 5,
          name: 'Baratza Encore',
          isGrinder: true,
          addedAt: DateTime(2024),
          useCount: 0,
        );
        final fakeInventory = _FakeInventoryRepo(equipments: [equip]);
        final container = _makeContainer(inventoryRepo: fakeInventory);
        addTearDown(container.dispose);

        await container
            .read(brewLoggerControllerProvider.notifier)
            .setEquipmentByName('Baratza Encore');

        final state = container.read(brewLoggerControllerProvider);
        expect(state.equipmentId, equals(5));
        expect(state.selectedEquipmentName, equals('Baratza Encore'));
      });

      test('clears equipmentId when null is passed', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        final ctrl = container.read(brewLoggerControllerProvider.notifier);
        ctrl.setEquipmentId(99);

        await ctrl.setEquipmentByName(null);

        final state = container.read(brewLoggerControllerProvider);
        expect(state.equipmentId, isNull);
        expect(state.selectedEquipmentName, isNull);
      });

      test(
        'pre-populates grindClickValue at midpoint of click range',
        () async {
          final equip = Equipment(
            id: 3,
            name: 'Comandante C40',
            isGrinder: true,
            grindMinClick: 10,
            grindMaxClick: 30,
            grindClickStep: 0.5,
            grindClickUnit: '格',
            addedAt: DateTime(2024),
            useCount: 0,
          );
          final fakeInventory = _FakeInventoryRepo(equipments: [equip]);
          final container = _makeContainer(inventoryRepo: fakeInventory);
          addTearDown(container.dispose);

          await container
              .read(brewLoggerControllerProvider.notifier)
              .setEquipmentByName('Comandante C40');

          final state = container.read(brewLoggerControllerProvider);
          // Midpoint of [10, 30] == 20.
          expect(state.grindClickValue, equals(20.0));
          expect(state.grindMinClick, equals(10.0));
          expect(state.grindMaxClick, equals(30.0));
          expect(state.grindClickStep, equals(0.5));
          expect(state.grindClickUnit, equals('格'));
          expect(state.grindSliderDivisions, equals(40));
        },
      );

      test(
        'falls back to simple mode when selected equipment has no click config',
        () async {
          final equip = Equipment(
            id: 9,
            name: 'Uncalibrated Grinder',
            isGrinder: true,
            addedAt: DateTime(2024),
            useCount: 0,
          );
          final fakeInventory = _FakeInventoryRepo(equipments: [equip]);
          final container = _makeContainer(inventoryRepo: fakeInventory);
          addTearDown(container.dispose);

          await container
              .read(brewLoggerControllerProvider.notifier)
              .setEquipmentByName('Uncalibrated Grinder');

          final state = container.read(brewLoggerControllerProvider);
          expect(state.equipmentId, equals(9));
          expect(state.selectedEquipmentName, equals('Uncalibrated Grinder'));
          expect(state.grindMode, equals(GrindMode.simple));
          expect(state.grindClickValue, isNull);
          expect(state.hasValidGrindClickConfig, isFalse);
        },
      );

      test('setGrindClickValue snaps and clamps to configured step', () async {
        final equip = Equipment(
          id: 11,
          name: 'Stepped Grinder',
          isGrinder: true,
          grindMinClick: 10,
          grindMaxClick: 20,
          grindClickStep: 0.5,
          addedAt: DateTime(2024),
          useCount: 0,
        );
        final fakeInventory = _FakeInventoryRepo(equipments: [equip]);
        final container = _makeContainer(inventoryRepo: fakeInventory);
        addTearDown(container.dispose);

        final ctrl = container.read(brewLoggerControllerProvider.notifier);
        await ctrl.setEquipmentByName('Stepped Grinder');

        ctrl.setGrindClickValue(12.26);
        var state = container.read(brewLoggerControllerProvider);
        expect(state.grindClickValue, equals(12.5));

        ctrl.setGrindClickValue(25);
        state = container.read(brewLoggerControllerProvider);
        expect(state.grindClickValue, equals(20.0));
      });
    });

    group('applyTemplate keeps parameters consistent', () {
      test(
        'copies full brew parameters and resolves equipment name/config',
        () async {
          final equipment = Equipment(
            id: 88,
            name: 'Comandante C40',
            isGrinder: true,
            grindMinClick: 10,
            grindMaxClick: 30,
            grindClickStep: 0.5,
            grindClickUnit: '格',
            addedAt: DateTime(2024),
            useCount: 5,
          );
          final inventoryRepo = _FakeInventoryRepo(equipments: [equipment]);
          final brewParamRepo = FakeBrewParamRepository(
            definitions: {
              BrewMethod.pourOver: const [
                BrewParamDefinition(
                  id: 1,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.waterTemp,
                  name: 'Water Temp',
                  type: ParamType.number,
                  unit: '°C',
                  isSystem: true,
                  sortOrder: 1,
                ),
                BrewParamDefinition(
                  id: 2,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.bloomTime,
                  name: 'Bloom Time',
                  type: ParamType.number,
                  unit: 's',
                  isSystem: true,
                  sortOrder: 2,
                ),
                BrewParamDefinition(
                  id: 3,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.pourMethod,
                  name: 'Pour Method',
                  type: ParamType.text,
                  isSystem: true,
                  sortOrder: 3,
                ),
                BrewParamDefinition(
                  id: 4,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.grindSize,
                  name: 'Grind Size',
                  type: ParamType.text,
                  isSystem: true,
                  sortOrder: 4,
                ),
                BrewParamDefinition(
                  id: 5,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.waterWeight,
                  name: 'Water Weight',
                  type: ParamType.number,
                  unit: 'g',
                  isSystem: true,
                  sortOrder: 5,
                ),
              ],
            },
            visibilities: {
              BrewMethod.pourOver: const [
                BrewParamVisibility(
                  id: 11,
                  method: BrewMethod.pourOver,
                  paramId: 1,
                  isVisible: true,
                ),
                BrewParamVisibility(
                  id: 12,
                  method: BrewMethod.pourOver,
                  paramId: 2,
                  isVisible: true,
                ),
                BrewParamVisibility(
                  id: 13,
                  method: BrewMethod.pourOver,
                  paramId: 3,
                  isVisible: true,
                ),
                BrewParamVisibility(
                  id: 14,
                  method: BrewMethod.pourOver,
                  paramId: 4,
                  isVisible: true,
                ),
                BrewParamVisibility(
                  id: 15,
                  method: BrewMethod.pourOver,
                  paramId: 5,
                  isVisible: true,
                ),
              ],
            },
          );
          final container = _makeContainer(
            inventoryRepo: inventoryRepo,
            brewParamRepo: brewParamRepo,
          );
          addTearDown(container.dispose);

          final template = BrewRecord(
            id: 7,
            brewDate: DateTime(2026, 3, 7, 8, 30),
            beanName: 'Ethiopia Guji',
            equipmentId: 88,
            brewMethod: BrewMethod.pourOver,
            grindMode: GrindMode.equipment,
            grindClickValue: 24.0,
            grindSimpleLabel: null,
            grindMicrons: null,
            coffeeWeightG: 18.0,
            waterWeightG: 288.0,
            waterTempC: 92.0,
            brewDurationS: 195,
            bloomTimeS: 30,
            pourMethod: 'Pulse',
            waterType: 'Filtered',
            roomTempC: 24.0,
            notes: 'Sweet finish',
            createdAt: DateTime(2026, 3, 7, 8, 31),
            updatedAt: DateTime(2026, 3, 7, 8, 31),
          );

          await container
              .read(brewLoggerControllerProvider.notifier)
              .applyTemplate(template);

          final state = container.read(brewLoggerControllerProvider);
          expect(state.beanName, equals(template.beanName));
          expect(state.equipmentId, equals(template.equipmentId));
          expect(state.selectedEquipmentName, equals('Comandante C40'));
          expect(state.grindMode, equals(template.grindMode));
          expect(state.grindClickValue, equals(template.grindClickValue));
          expect(state.grindMinClick, equals(10.0));
          expect(state.grindMaxClick, equals(30.0));
          expect(state.grindClickStep, equals(0.5));
          expect(state.grindClickUnit, equals('格'));
          expect(state.coffeeWeightG, equals(template.coffeeWeightG));
          expect(state.waterWeightG, equals(template.waterWeightG));
          expect(state.waterTempC, equals(template.waterTempC));
          expect(state.brewDurationS, equals(template.brewDurationS));
          expect(state.bloomTimeS, equals(template.bloomTimeS));
          expect(state.pourMethod, equals(template.pourMethod));
          expect(state.waterType, isNull);
          expect(state.roomTempC, isNull);
          expect(state.notes, equals(template.notes));
        },
      );

      test(
        'falls back to simple mode when template equipment has no click config',
        () async {
          final equipment = Equipment(
            id: 88,
            name: 'Uncalibrated Grinder',
            isGrinder: true,
            addedAt: DateTime(2024),
            useCount: 5,
          );
          final inventoryRepo = _FakeInventoryRepo(equipments: [equipment]);
          final container = _makeContainer(inventoryRepo: inventoryRepo);
          addTearDown(container.dispose);

          final template = BrewRecord(
            id: 7,
            brewDate: DateTime(2026, 3, 7, 8, 30),
            beanName: 'Ethiopia Guji',
            equipmentId: 88,
            brewMethod: BrewMethod.pourOver,
            grindMode: GrindMode.equipment,
            grindClickValue: 24.0,
            grindSimpleLabel: null,
            grindMicrons: null,
            coffeeWeightG: 18.0,
            waterWeightG: 288.0,
            waterTempC: 92.0,
            brewDurationS: 195,
            bloomTimeS: 30,
            pourMethod: 'Pulse',
            waterType: 'Filtered',
            roomTempC: 24.0,
            notes: 'Sweet finish',
            createdAt: DateTime(2026, 3, 7, 8, 31),
            updatedAt: DateTime(2026, 3, 7, 8, 31),
          );

          await container
              .read(brewLoggerControllerProvider.notifier)
              .applyTemplate(template);

          final state = container.read(brewLoggerControllerProvider);
          expect(state.grindMode, equals(GrindMode.simple));
          expect(state.grindClickValue, isNull);
          expect(state.hasValidGrindClickConfig, isFalse);
        },
      );
    });

    group('visibility sanitization', () {
      test(
        'applyTemplate clears hidden system-bound values and hidden custom drafts',
        () async {
          final brewParamRepo = FakeBrewParamRepository(
            definitions: {
              BrewMethod.pourOver: [
                const BrewParamDefinition(
                  id: 1,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.waterTemp,
                  name: 'Water Temp',
                  type: ParamType.number,
                  unit: '°C',
                  isSystem: true,
                  sortOrder: 1,
                ),
                const BrewParamDefinition(
                  id: 2,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.bloomTime,
                  name: 'Bloom Time',
                  type: ParamType.number,
                  unit: 's',
                  isSystem: true,
                  sortOrder: 2,
                ),
                const BrewParamDefinition(
                  id: 3,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.pourMethod,
                  name: 'Pour Method',
                  type: ParamType.text,
                  isSystem: true,
                  sortOrder: 3,
                ),
                const BrewParamDefinition(
                  id: 4,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.grindSize,
                  name: 'Grind Size',
                  type: ParamType.text,
                  isSystem: true,
                  sortOrder: 4,
                ),
                const BrewParamDefinition(
                  id: 5,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.waterWeight,
                  name: 'Water Weight',
                  type: ParamType.number,
                  unit: 'g',
                  isSystem: true,
                  sortOrder: 5,
                ),
                BrewParamDefinition(
                  id: 501,
                  method: BrewMethod.pourOver,
                  paramKey: customParamKeyForId(501),
                  name: 'Agitation',
                  type: ParamType.text,
                  isSystem: false,
                  sortOrder: 6,
                ),
              ],
            },
            visibilities: {
              BrewMethod.pourOver: const [
                BrewParamVisibility(
                  id: 11,
                  method: BrewMethod.pourOver,
                  paramId: 1,
                  isVisible: false,
                ),
                BrewParamVisibility(
                  id: 12,
                  method: BrewMethod.pourOver,
                  paramId: 2,
                  isVisible: false,
                ),
                BrewParamVisibility(
                  id: 13,
                  method: BrewMethod.pourOver,
                  paramId: 3,
                  isVisible: false,
                ),
                BrewParamVisibility(
                  id: 14,
                  method: BrewMethod.pourOver,
                  paramId: 4,
                  isVisible: false,
                ),
                BrewParamVisibility(
                  id: 15,
                  method: BrewMethod.pourOver,
                  paramId: 5,
                  isVisible: true,
                ),
                BrewParamVisibility(
                  id: 16,
                  method: BrewMethod.pourOver,
                  paramId: 501,
                  isVisible: false,
                ),
              ],
            },
            valuesByBrew: {
              77: const [
                BrewParamValue(
                  id: 1,
                  brewRecordId: 77,
                  paramId: 501,
                  valueText: 'Swirl',
                ),
              ],
            },
          );
          final equipment = Equipment(
            id: 88,
            name: 'Comandante C40',
            isGrinder: true,
            grindMinClick: 10,
            grindMaxClick: 30,
            grindClickStep: 0.5,
            addedAt: DateTime(2024),
            useCount: 0,
          );
          final inventoryRepo = _FakeInventoryRepo(equipments: [equipment]);
          final container = _makeContainer(
            inventoryRepo: inventoryRepo,
            brewParamRepo: brewParamRepo,
          );
          addTearDown(container.dispose);

          final template = BrewRecord(
            id: 77,
            brewDate: DateTime(2026, 3, 7, 8, 30),
            beanName: 'Ethiopia Guji',
            equipmentId: 88,
            brewMethod: BrewMethod.pourOver,
            grindMode: GrindMode.equipment,
            grindClickValue: 24.0,
            grindSimpleLabel: null,
            grindMicrons: null,
            coffeeWeightG: 18.0,
            waterWeightG: 288.0,
            waterTempC: 92.0,
            brewDurationS: 195,
            bloomTimeS: 30,
            pourMethod: 'Pulse',
            waterType: 'Filtered',
            roomTempC: 24.0,
            notes: 'Sweet finish',
            createdAt: DateTime(2026, 3, 7, 8, 31),
            updatedAt: DateTime(2026, 3, 7, 8, 31),
          );

          await container
              .read(brewLoggerControllerProvider.notifier)
              .applyTemplate(template);

          final state = container.read(brewLoggerControllerProvider);
          expect(state.waterTempC, isNull);
          expect(state.bloomTimeS, isNull);
          expect(state.pourMethod, isNull);
          expect(state.equipmentId, isNull);
          expect(state.selectedEquipmentName, isNull);
          expect(state.grindClickValue, isNull);
          expect(state.paramValues, isEmpty);
          expect(state.waterType, isNull);
          expect(state.roomTempC, isNull);
        },
      );

      test(
        'saveNewRecord strips hidden direct fields before persistence',
        () async {
          final fakeBrewRepo = _FakeBrewRepo();
          final brewParamRepo = FakeBrewParamRepository(
            definitions: {
              BrewMethod.pourOver: const [
                BrewParamDefinition(
                  id: 1,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.waterTemp,
                  name: 'Water Temp',
                  type: ParamType.number,
                  unit: '°C',
                  isSystem: true,
                  sortOrder: 1,
                ),
                BrewParamDefinition(
                  id: 2,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.bloomTime,
                  name: 'Bloom Time',
                  type: ParamType.number,
                  unit: 's',
                  isSystem: true,
                  sortOrder: 2,
                ),
                BrewParamDefinition(
                  id: 3,
                  method: BrewMethod.pourOver,
                  paramKey: BrewParamKeys.pourMethod,
                  name: 'Pour Method',
                  type: ParamType.text,
                  isSystem: true,
                  sortOrder: 3,
                ),
              ],
            },
            visibilities: {
              BrewMethod.pourOver: const [
                BrewParamVisibility(
                  id: 11,
                  method: BrewMethod.pourOver,
                  paramId: 1,
                  isVisible: false,
                ),
                BrewParamVisibility(
                  id: 12,
                  method: BrewMethod.pourOver,
                  paramId: 2,
                  isVisible: false,
                ),
                BrewParamVisibility(
                  id: 13,
                  method: BrewMethod.pourOver,
                  paramId: 3,
                  isVisible: false,
                ),
              ],
            },
          );
          final container = _makeContainer(
            brewRepo: fakeBrewRepo,
            brewParamRepo: brewParamRepo,
          );
          addTearDown(container.dispose);

          final controller = container.read(
            brewLoggerControllerProvider.notifier,
          );
          controller.setBeanName('Ethiopia Guji');
          controller.setWaterTemp(92.0);
          controller.setBloomTime(30);
          controller.setPourMethod('Pulse');
          controller.setWaterType('Filtered');
          controller.setRoomTemp(24.0);

          await controller.saveNewRecord(elapsedSeconds: 195);

          final saved = fakeBrewRepo.lastCreatedRecord!;
          expect(saved.waterTempC, isNull);
          expect(saved.bloomTimeS, isNull);
          expect(saved.pourMethod, isNull);
          expect(saved.waterType, isNull);
          expect(saved.roomTempC, isNull);
        },
      );
    });

    group('applyTemplateByRecordId', () {
      test('loads brew by id and applies it as template', () async {
        final template = BrewRecord(
          id: 101,
          brewDate: DateTime(2026, 3, 8, 7, 0),
          beanName: 'Rwanda Gitesi',
          equipmentId: null,
          brewMethod: BrewMethod.pourOver,
          grindMode: GrindMode.simple,
          grindClickValue: null,
          grindSimpleLabel: 'Medium-Fine',
          grindMicrons: null,
          coffeeWeightG: 16.0,
          waterWeightG: 256.0,
          waterTempC: 91.0,
          brewDurationS: 180,
          bloomTimeS: 28,
          pourMethod: 'Center pour',
          waterType: 'Filtered',
          roomTempC: 23.0,
          notes: 'Balanced cup',
          createdAt: DateTime(2026, 3, 8, 7, 1),
          updatedAt: DateTime(2026, 3, 8, 7, 1),
        );
        final brewRepo = _FakeBrewRepo(recordsById: {101: template});
        final container = _makeContainer(brewRepo: brewRepo);
        addTearDown(container.dispose);

        final applied = await container
            .read(brewLoggerControllerProvider.notifier)
            .applyTemplateByRecordId(101);

        final state = container.read(brewLoggerControllerProvider);
        expect(applied, isTrue);
        expect(state.beanName, template.beanName);
        expect(state.grindMode, template.grindMode);
        expect(state.grindSimpleLabel, template.grindSimpleLabel);
        expect(state.coffeeWeightG, template.coffeeWeightG);
      });

      test('returns false and sets error when brew is missing', () async {
        final brewRepo = _FakeBrewRepo();
        final container = _makeContainer(brewRepo: brewRepo);
        addTearDown(container.dispose);

        final applied = await container
            .read(brewLoggerControllerProvider.notifier)
            .applyTemplateByRecordId(999);

        final state = container.read(brewLoggerControllerProvider);
        expect(applied, isFalse);
        expect(state.errorMessage, 'Template record not found.');
      });
    });
  });
}
