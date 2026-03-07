import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/drift_database.dart' as db;
import '../../domain/entities/bean.dart' as domain;
import '../../domain/entities/equipment.dart' as domain;
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDatasource _datasource;

  InventoryRepositoryImpl(this._datasource);

  domain.Bean _mapBeanToDomain(db.Bean b) => domain.Bean(
    id: b.id,
    name: b.name,
    roaster: b.roaster,
    origin: b.origin,
    roastLevel: b.roastLevel,
    addedAt: b.addedAt,
    useCount: b.useCount,
  );

  db.BeansCompanion _mapBeanToDb(domain.Bean b) => db.BeansCompanion(
    id: drift.Value(b.id),
    name: drift.Value(b.name),
    roaster: drift.Value(b.roaster),
    origin: drift.Value(b.origin),
    roastLevel: drift.Value(b.roastLevel),
    addedAt: drift.Value(b.addedAt),
    useCount: drift.Value(b.useCount),
  );

  domain.Equipment _mapEquipmentToDomain(db.Equipment e) => domain.Equipment(
    id: e.id,
    name: e.name,
    category: e.category,
    isGrinder: e.isGrinder,
    grindMinClick: e.grindMinClick,
    grindMaxClick: e.grindMaxClick,
    grindClickStep: e.grindClickStep,
    grindClickUnit: e.grindClickUnit,
    addedAt: e.addedAt,
    useCount: e.useCount,
  );

  db.EquipmentsCompanion _mapEquipmentToDb(domain.Equipment e) =>
      db.EquipmentsCompanion(
        id: drift.Value(e.id),
        name: drift.Value(e.name),
        category: drift.Value(e.category),
        isGrinder: drift.Value(e.isGrinder),
        grindMinClick: drift.Value(e.grindMinClick),
        grindMaxClick: drift.Value(e.grindMaxClick),
        grindClickStep: drift.Value(e.grindClickStep),
        grindClickUnit: drift.Value(e.grindClickUnit),
        addedAt: drift.Value(e.addedAt),
        useCount: drift.Value(e.useCount),
      );

  @override
  Future<List<domain.Bean>> getAllBeans() async {
    final ds = await _datasource.getAllBeans();
    return ds.map(_mapBeanToDomain).toList();
  }

  @override
  Future<List<domain.Bean>> searchBeans(String query) async {
    final ds = await _datasource.searchBeans(query);
    return ds.map(_mapBeanToDomain).toList();
  }

  @override
  Future<int> createBean(domain.Bean bean) async {
    final existing = await _datasource.getBeanByName(bean.name);
    if (existing != null) return existing.id;

    final companion = db.BeansCompanion.insert(
      name: bean.name,
      roaster: bean.roaster == null
          ? const drift.Value.absent()
          : drift.Value(bean.roaster),
      origin: bean.origin == null
          ? const drift.Value.absent()
          : drift.Value(bean.origin),
      roastLevel: bean.roastLevel == null
          ? const drift.Value.absent()
          : drift.Value(bean.roastLevel),
      addedAt: drift.Value(bean.addedAt),
      useCount: drift.Value(bean.useCount),
    );
    return _datasource.insertBean(companion);
  }

  @override
  Future<bool> updateBean(domain.Bean bean) async {
    return _datasource.updateBean(_mapBeanToDb(bean));
  }

  @override
  Future<int> deleteBean(int id) async {
    return _datasource.deleteBean(id);
  }

  @override
  Future<void> incrementBeanUseCount(int id) async {
    return _datasource.incrementBeanUseCount(id);
  }

  @override
  Future<List<domain.Equipment>> getAllEquipments() async {
    final ds = await _datasource.getAllEquipments();
    return ds.map(_mapEquipmentToDomain).toList();
  }

  @override
  Future<List<domain.Equipment>> searchEquipments(String query) async {
    final ds = await _datasource.searchEquipments(query);
    return ds.map(_mapEquipmentToDomain).toList();
  }

  @override
  Future<int> createEquipment(domain.Equipment e) async {
    final existing = await _datasource.getEquipmentByName(e.name);
    if (existing != null) return existing.id;

    final companion = db.EquipmentsCompanion.insert(
      name: e.name,
      category: e.category == null
          ? const drift.Value.absent()
          : drift.Value(e.category),
      isGrinder: drift.Value(e.isGrinder),
      grindMinClick: e.grindMinClick == null
          ? const drift.Value.absent()
          : drift.Value(e.grindMinClick),
      grindMaxClick: e.grindMaxClick == null
          ? const drift.Value.absent()
          : drift.Value(e.grindMaxClick),
      grindClickStep: e.grindClickStep == null
          ? const drift.Value.absent()
          : drift.Value(e.grindClickStep),
      grindClickUnit: e.grindClickUnit == null
          ? const drift.Value.absent()
          : drift.Value(e.grindClickUnit),
      addedAt: drift.Value(e.addedAt),
      useCount: drift.Value(e.useCount),
    );
    return _datasource.insertEquipment(companion);
  }

  @override
  Future<bool> updateEquipment(domain.Equipment equipment) async {
    return _datasource.updateEquipment(_mapEquipmentToDb(equipment));
  }

  @override
  Future<int> deleteEquipment(int id) async {
    return _datasource.deleteEquipment(id);
  }

  @override
  Future<void> incrementEquipmentUseCount(int id) async {
    return _datasource.incrementEquipmentUseCount(id);
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl(ref.watch(inventoryLocalDatasourceProvider));
});
