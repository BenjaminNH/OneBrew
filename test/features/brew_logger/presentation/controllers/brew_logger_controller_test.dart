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
import 'package:one_coffee/features/brew_logger/data/repositories/brew_repository_impl.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_coffee/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_coffee/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:one_coffee/features/inventory/domain/entities/bean.dart';
import 'package:one_coffee/features/inventory/domain/entities/equipment.dart';

import '../../../../helpers/mock_repositories.mocks.dart';

// ---------------------------------------------------------------------------
// A minimal fake BrewRepository that records the companion passed to update.
// ---------------------------------------------------------------------------
class _FakeBrewRepo extends MockBrewRepository {
  BrewRecord? lastCreatedRecord;
  BrewRecord? lastUpdatedRecord;

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
}) {
  final brew = brewRepo ?? _FakeBrewRepo();
  final inventory = inventoryRepo ?? _FakeInventoryRepo();
  return ProviderContainer(
    overrides: [
      brewRepositoryProvider.overrideWithValue(brew),
      inventoryRepositoryProvider.overrideWithValue(inventory),
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
        },
      );
    });
  });
}
