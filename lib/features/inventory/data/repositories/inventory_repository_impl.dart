import 'package:drift/drift.dart' as drift;

import '../../../../core/database/drift_database.dart' as db;
import '../../domain/entities/bean.dart' as domain;
import '../../domain/entities/equipment.dart' as domain;
import '../../domain/inventory_exceptions.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDatasource _datasource;
  static const int _maxGrinderSegments = 1000;

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
    isDeleted: e.isDeleted,
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
        isDeleted: drift.Value(e.isDeleted),
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
    final existing = await _datasource.getBeanByNameIgnoreCase(bean.name);
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
  Future<List<domain.Equipment>> getAllGrinders() async {
    final ds = await _datasource.getAllGrinders();
    return ds.map(_mapEquipmentToDomain).toList();
  }

  @override
  Future<List<domain.Equipment>> searchGrinders(String query) async {
    final ds = await _datasource.searchGrinders(query);
    return ds.map(_mapEquipmentToDomain).toList();
  }

  @override
  Future<int> createEquipment(domain.Equipment e) async {
    final existing = await _datasource.getEquipmentByNameIgnoreCase(e.name);
    if (existing != null) {
      if (!existing.isDeleted) return existing.id;

      final restored = e.copyWith(
        id: existing.id,
        isDeleted: false,
        addedAt: existing.addedAt,
        useCount: existing.useCount,
      );
      await _datasource.updateEquipment(_mapEquipmentToDb(restored));
      return existing.id;
    }

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
    final refs = await _datasource.countBrewRecordsByEquipmentId(id);
    if (refs > 0) {
      return _datasource.softDeleteEquipment(id);
    }
    return _datasource.deleteEquipment(id);
  }

  @override
  Future<void> incrementEquipmentUseCount(int id) async {
    return _datasource.incrementEquipmentUseCount(id);
  }

  @override
  Future<bool> renameBeanAndPropagate({
    required int beanId,
    required String newName,
  }) async {
    final normalizedName = newName.trim();
    if (normalizedName.isEmpty) {
      throw const InventoryValidationException('Bean name cannot be empty.');
    }

    final bean = await _datasource.getBeanById(beanId);
    if (bean == null) return false;

    final conflict = await _datasource.getBeanByNameIgnoreCase(normalizedName);
    if (conflict != null && conflict.id != beanId) {
      throw const InventoryConflictException(
        'A bean with the same name already exists.',
      );
    }

    return _datasource.renameBeanAndPropagate(
      beanId: beanId,
      newName: normalizedName,
    );
  }

  @override
  Future<bool> updateGrinder(domain.Equipment grinder) async {
    _validateGrinderConfig(grinder);
    return _datasource.updateEquipment(_mapEquipmentToDb(grinder));
  }

  @override
  Future<int> deleteGrinderWithGuard(int grinderId) async {
    final grinder = await _datasource.getEquipmentById(grinderId);
    if (grinder == null) return 0;
    if (!grinder.isGrinder) {
      throw const InventoryValidationException(
        'Only grinder equipment can be deleted from grinder management.',
      );
    }

    final refs = await _datasource.countBrewRecordsByEquipmentId(grinderId);
    if (refs > 0) {
      return _datasource.softDeleteEquipment(grinderId);
    }
    return _datasource.deleteEquipment(grinderId);
  }

  void _validateGrinderConfig(domain.Equipment grinder) {
    if (!grinder.isGrinder) {
      throw const InventoryValidationException(
        'Grinder update requires isGrinder=true.',
      );
    }

    final min = grinder.grindMinClick;
    final max = grinder.grindMaxClick;
    final step = grinder.grindClickStep;
    if (min == null || max == null || step == null) {
      throw const InventoryValidationException(
        'Grinder configuration requires min/max/step values.',
      );
    }

    if (max <= min) {
      throw const InventoryValidationException(
        'Grinder max click must be greater than min click.',
      );
    }

    if (step <= 0) {
      throw const InventoryValidationException(
        'Grinder click step must be greater than 0.',
      );
    }

    final segmentCount = (max - min) / step;
    if (!segmentCount.isFinite ||
        segmentCount <= 0 ||
        segmentCount > _maxGrinderSegments) {
      throw InventoryValidationException(
        'Grinder range is too large. Maximum segments: $_maxGrinderSegments.',
      );
    }
  }
}
