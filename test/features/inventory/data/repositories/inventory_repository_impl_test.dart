import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/core/database/drift_database.dart';
import 'package:one_coffee/features/inventory/data/datasources/inventory_local_datasource.dart';
import 'package:one_coffee/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:one_coffee/features/inventory/domain/entities/bean.dart'
    as domain;
import 'package:one_coffee/features/inventory/domain/entities/equipment.dart'
    as domain;

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
  });
}
