import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/drift_database.dart';
import '../../../../shared/providers/database_providers.dart';

/// Local datasource interface for inventory.
abstract interface class InventoryLocalDatasource {
  Future<List<Bean>> getAllBeans();
  Future<List<Bean>> searchBeans(String query);
  Future<int> insertBean(BeansCompanion bean);
  Future<bool> updateBean(BeansCompanion bean);
  Future<int> deleteBean(int id);
  Future<void> incrementBeanUseCount(int id);
  Future<Bean?> getBeanById(int id);
  Future<Bean?> getBeanByName(String name);
  Future<Bean?> getBeanByNameIgnoreCase(String name);
  Future<bool> renameBeanAndPropagate({
    required int beanId,
    required String newName,
  });
  Future<int> countBrewRecordsByBeanName(String beanName);

  Future<List<Equipment>> getAllEquipments();
  Future<List<Equipment>> searchEquipments(String query);
  Future<List<Equipment>> getAllGrinders();
  Future<List<Equipment>> searchGrinders(String query);
  Future<int> insertEquipment(EquipmentsCompanion equipment);
  Future<bool> updateEquipment(EquipmentsCompanion equipment);
  Future<int> deleteEquipment(int id);
  Future<void> incrementEquipmentUseCount(int id);
  Future<Equipment?> getEquipmentById(int id);
  Future<Equipment?> getEquipmentByName(String name);
  Future<Equipment?> getEquipmentByNameIgnoreCase(String name);
  Future<int> countBrewRecordsByEquipmentId(int equipmentId);
}

/// Implementation wrapping the Drift database.
class InventoryLocalDatasourceImpl implements InventoryLocalDatasource {
  final OneCoffeeDatabase _db;

  InventoryLocalDatasourceImpl(this._db);

  @override
  Future<List<Bean>> getAllBeans() => _db.getAllBeans();

  @override
  Future<List<Bean>> searchBeans(String query) => _db.searchBeans(query);

  @override
  Future<int> insertBean(BeansCompanion bean) => _db.insertBean(bean);

  @override
  Future<bool> updateBean(BeansCompanion bean) => _db.updateBean(bean);

  @override
  Future<int> deleteBean(int id) => _db.deleteBean(id);

  @override
  Future<void> incrementBeanUseCount(int id) => _db.incrementBeanUseCount(id);

  @override
  Future<Bean?> getBeanById(int id) => _db.getBeanById(id);

  @override
  Future<Bean?> getBeanByName(String name) async {
    return (_db.select(
      _db.beans,
    )..where((b) => b.name.equals(name))).getSingleOrNull();
  }

  @override
  Future<Bean?> getBeanByNameIgnoreCase(String name) async {
    final normalized = name.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    final candidates = await _db.searchBeans(name);
    for (final bean in candidates) {
      if (bean.name.trim().toLowerCase() == normalized) {
        return bean;
      }
    }
    return null;
  }

  @override
  Future<bool> renameBeanAndPropagate({
    required int beanId,
    required String newName,
  }) => _db.renameBeanAndPropagate(beanId: beanId, newName: newName);

  @override
  Future<int> countBrewRecordsByBeanName(String beanName) =>
      _db.countBrewRecordsByBeanName(beanName);

  @override
  Future<List<Equipment>> getAllEquipments() => _db.getAllEquipments();

  @override
  Future<List<Equipment>> searchEquipments(String query) =>
      _db.searchEquipments(query);

  @override
  Future<List<Equipment>> getAllGrinders() => _db.getAllGrinders();

  @override
  Future<List<Equipment>> searchGrinders(String query) =>
      _db.searchGrinders(query);

  @override
  Future<int> insertEquipment(EquipmentsCompanion equipment) =>
      _db.insertEquipment(equipment);

  @override
  Future<bool> updateEquipment(EquipmentsCompanion equipment) =>
      _db.updateEquipment(equipment);

  @override
  Future<int> deleteEquipment(int id) => _db.deleteEquipment(id);

  @override
  Future<void> incrementEquipmentUseCount(int id) =>
      _db.incrementEquipmentUseCount(id);

  @override
  Future<Equipment?> getEquipmentById(int id) => _db.getEquipmentById(id);

  @override
  Future<Equipment?> getEquipmentByName(String name) async {
    return (_db.select(
      _db.equipments,
    )..where((e) => e.name.equals(name))).getSingleOrNull();
  }

  @override
  Future<Equipment?> getEquipmentByNameIgnoreCase(String name) async {
    final normalized = name.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    final candidates = await _db.searchEquipments(name);
    for (final equipment in candidates) {
      if (equipment.name.trim().toLowerCase() == normalized) {
        return equipment;
      }
    }
    return null;
  }

  @override
  Future<int> countBrewRecordsByEquipmentId(int equipmentId) =>
      _db.countBrewRecordsByEquipmentId(equipmentId);
}

final inventoryLocalDatasourceProvider = Provider<InventoryLocalDatasource>((
  ref,
) {
  return InventoryLocalDatasourceImpl(ref.watch(databaseProvider));
});
