import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/core/database/drift_database.dart';
import 'package:one_coffee/features/inventory/data/datasources/inventory_local_datasource.dart';
import 'package:one_coffee/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:one_coffee/features/inventory/domain/entities/bean.dart'
    as domain;
import 'package:one_coffee/features/inventory/domain/entities/equipment.dart'
    as domain;
import 'package:one_coffee/features/inventory/domain/inventory_exceptions.dart';

void main() {
  late OneCoffeeDatabase db;
  late InventoryLocalDatasourceImpl datasource;
  late InventoryRepositoryImpl repository;

  setUp(() {
    db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
    datasource = InventoryLocalDatasourceImpl(db);
    repository = InventoryRepositoryImpl(datasource);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertBrewForBean({
    required String beanName,
    int? equipmentId,
  }) async {
    final now = DateTime(2026, 1, 1, 8, 0);
    await db.insertBrewRecord(
      BrewRecordsCompanion.insert(
        brewDate: now,
        beanName: beanName,
        equipmentId: equipmentId == null
            ? const drift.Value.absent()
            : drift.Value(equipmentId),
        grindMode: const drift.Value('simple'),
        grindSimpleLabel: const drift.Value('Medium'),
        coffeeWeightG: 15,
        waterWeightG: 225,
        brewDurationS: 180,
        isQuickMode: const drift.Value(true),
        createdAt: drift.Value(now),
        updatedAt: drift.Value(now),
      ),
    );
  }

  group('InventoryRepositoryImpl Bean Tests', () {
    test('createBean and getAllBeans', () async {
      final bean = domain.Bean(
        id: 0,
        name: 'Ethiopia Yirgacheffe',
        roaster: 'Test Roaster',
        addedAt: DateTime.now(),
        useCount: 0,
      );

      final id = await repository.createBean(bean);
      expect(id, isPositive);

      final beans = await repository.getAllBeans();
      expect(beans.length, 1);
      expect(beans.first.id, id);
      expect(beans.first.name, 'Ethiopia Yirgacheffe');
    });

    test('getAllBeans sorts by useCount desc then addedAt desc', () async {
      await repository.createBean(
        domain.Bean(
          id: 0,
          name: 'Bean A',
          addedAt: DateTime(2026, 1, 1),
          useCount: 3,
        ),
      );
      await repository.createBean(
        domain.Bean(
          id: 0,
          name: 'Bean B',
          addedAt: DateTime(2026, 1, 2),
          useCount: 3,
        ),
      );
      await repository.createBean(
        domain.Bean(
          id: 0,
          name: 'Bean C',
          addedAt: DateTime(2026, 1, 3),
          useCount: 1,
        ),
      );

      final beans = await repository.getAllBeans();
      expect(beans.map((e) => e.name).toList(), ['Bean B', 'Bean A', 'Bean C']);
    });

    test('createBean skips duplication', () async {
      final bean1 = domain.Bean(
        id: 0,
        name: 'Duplicate Bean',
        addedAt: DateTime.now(),
        useCount: 0,
      );

      final id1 = await repository.createBean(bean1);
      final id2 = await repository.createBean(bean1);

      expect(id1, equals(id2));

      final beans = await repository.getAllBeans();
      expect(beans.length, 1);
    });

    test('createBean skips duplication case-insensitively', () async {
      final bean1 = domain.Bean(
        id: 0,
        name: 'Case Bean',
        addedAt: DateTime.now(),
        useCount: 0,
      );

      final id1 = await repository.createBean(bean1);
      final id2 = await repository.createBean(
        bean1.copyWith(name: 'case bean'),
      );

      expect(id1, equals(id2));
      final beans = await repository.getAllBeans();
      expect(beans, hasLength(1));
    });

    test('searchBeans and incrementBeanUseCount', () async {
      await repository.createBean(
        domain.Bean(id: 0, name: 'AAA', addedAt: DateTime.now(), useCount: 0),
      );
      final id = await repository.createBean(
        domain.Bean(id: 0, name: 'AAB', addedAt: DateTime.now(), useCount: 0),
      );
      await repository.createBean(
        domain.Bean(id: 0, name: 'CCC', addedAt: DateTime.now(), useCount: 0),
      );

      await repository.incrementBeanUseCount(id);

      final results = await repository.searchBeans('aa');
      expect(results.length, 2);
      expect(results.first.name, 'AAB');
      expect(results.first.useCount, 1);
    });

    test(
      'renameBeanAndPropagate renames bean and updates brew history',
      () async {
        final beanId = await repository.createBean(
          domain.Bean(
            id: 0,
            name: 'Old Bean',
            addedAt: DateTime.now(),
            useCount: 0,
          ),
        );
        await insertBrewForBean(beanName: 'Old Bean');

        final success = await repository.renameBeanAndPropagate(
          beanId: beanId,
          newName: 'New Bean',
        );

        expect(success, isTrue);
        final beans = await repository.searchBeans('new');
        expect(beans.single.name, 'New Bean');

        final brews = await db.getAllBrewRecords();
        expect(brews.single.beanName, 'New Bean');
      },
    );

    test('renameBeanAndPropagate blocks name conflict', () async {
      final keepId = await repository.createBean(
        domain.Bean(
          id: 0,
          name: 'Existing Bean',
          addedAt: DateTime.now(),
          useCount: 0,
        ),
      );
      final targetId = await repository.createBean(
        domain.Bean(
          id: 0,
          name: 'Target Bean',
          addedAt: DateTime.now(),
          useCount: 0,
        ),
      );
      expect(keepId, isNot(targetId));

      expect(
        () => repository.renameBeanAndPropagate(
          beanId: targetId,
          newName: 'existing bean',
        ),
        throwsA(isA<InventoryConflictException>()),
      );
    });

    test(
      'deleteBean allows deletion even when bean is referenced by brew history',
      () async {
        final beanId = await repository.createBean(
          domain.Bean(
            id: 0,
            name: 'Protected Bean',
            addedAt: DateTime.now(),
            useCount: 0,
          ),
        );
        await insertBrewForBean(beanName: 'Protected Bean');

        final deleted = await repository.deleteBean(beanId);
        expect(deleted, 1);

        final beans = await repository.getAllBeans();
        expect(beans.where((e) => e.id == beanId), isEmpty);

        final brews = await db.getAllBrewRecords();
        expect(brews.single.beanName, 'Protected Bean');
      },
    );
  });

  group('InventoryRepositoryImpl Equipment Tests', () {
    test('createEquipment and getAllEquipments', () async {
      final equip = domain.Equipment(
        id: 0,
        name: 'Comandante C40',
        isGrinder: true,
        grindMinClick: 0,
        grindMaxClick: 40,
        addedAt: DateTime.now(),
        useCount: 0,
      );

      final id = await repository.createEquipment(equip);
      expect(id, isPositive);

      final equips = await repository.getAllEquipments();
      expect(equips.length, 1);
      expect(equips.first.name, 'Comandante C40');
      expect(equips.first.isGrinder, isTrue);
    });

    test('createEquipment skips duplication', () async {
      final equip = domain.Equipment(
        id: 0,
        name: 'V60',
        isGrinder: false,
        addedAt: DateTime.now(),
        useCount: 0,
      );

      final id1 = await repository.createEquipment(equip);
      final id2 = await repository.createEquipment(equip);

      expect(id1, equals(id2));
    });

    test(
      'getAllGrinders returns only grinder equipment sorted by rules',
      () async {
        await repository.createEquipment(
          domain.Equipment(
            id: 0,
            name: 'V60',
            isGrinder: false,
            addedAt: DateTime(2026, 1, 3),
            useCount: 100,
          ),
        );
        await repository.createEquipment(
          domain.Equipment(
            id: 0,
            name: 'A Grinder',
            isGrinder: true,
            grindMinClick: 0,
            grindMaxClick: 40,
            grindClickStep: 1,
            addedAt: DateTime(2026, 1, 1),
            useCount: 2,
          ),
        );
        await repository.createEquipment(
          domain.Equipment(
            id: 0,
            name: 'B Grinder',
            isGrinder: true,
            grindMinClick: 0,
            grindMaxClick: 40,
            grindClickStep: 1,
            addedAt: DateTime(2026, 1, 2),
            useCount: 2,
          ),
        );

        final grinders = await repository.getAllGrinders();
        expect(grinders, hasLength(2));
        expect(grinders.map((e) => e.name).toList(), [
          'B Grinder',
          'A Grinder',
        ]);
      },
    );

    test('updateGrinder validates click range config', () async {
      final id = await repository.createEquipment(
        domain.Equipment(
          id: 0,
          name: 'K-Ultra',
          isGrinder: true,
          grindMinClick: 0,
          grindMaxClick: 100,
          grindClickStep: 1,
          addedAt: DateTime.now(),
          useCount: 0,
        ),
      );

      final invalid = domain.Equipment(
        id: id,
        name: 'K-Ultra',
        isGrinder: true,
        grindMinClick: 10,
        grindMaxClick: 10,
        grindClickStep: 1,
        addedAt: DateTime.now(),
        useCount: 0,
      );

      expect(
        () => repository.updateGrinder(invalid),
        throwsA(isA<InventoryValidationException>()),
      );
    });

    test(
      'deleteGrinderWithGuard soft-deletes grinder when referenced',
      () async {
        final grinderId = await repository.createEquipment(
          domain.Equipment(
            id: 0,
            name: 'Referenced Grinder',
            isGrinder: true,
            grindMinClick: 0,
            grindMaxClick: 40,
            grindClickStep: 1,
            addedAt: DateTime.now(),
            useCount: 0,
          ),
        );
        await insertBrewForBean(beanName: 'Some Bean', equipmentId: grinderId);

        final deleted = await repository.deleteGrinderWithGuard(grinderId);
        expect(deleted, 1);

        final allEquipments = await repository.getAllEquipments();
        expect(allEquipments.where((e) => e.id == grinderId), isEmpty);

        final brews = await db.getAllBrewRecords();
        expect(brews.single.equipmentId, grinderId);

        final stored = await db.getEquipmentById(grinderId);
        expect(stored, isNotNull);
        expect(stored!.isDeleted, isTrue);
      },
    );

    test('deleteGrinderWithGuard hard-deletes grinder when unreferenced', () async {
      final grinderId = await repository.createEquipment(
        domain.Equipment(
          id: 0,
          name: 'Unused Grinder',
          isGrinder: true,
          grindMinClick: 0,
          grindMaxClick: 40,
          grindClickStep: 1,
          addedAt: DateTime.now(),
          useCount: 0,
        ),
      );

      final deleted = await repository.deleteGrinderWithGuard(grinderId);
      expect(deleted, 1);

      final allEquipments = await repository.getAllEquipments();
      expect(allEquipments.where((e) => e.id == grinderId), isEmpty);

      final stored = await db.getEquipmentById(grinderId);
      expect(stored, isNull);
    });
  });
}
