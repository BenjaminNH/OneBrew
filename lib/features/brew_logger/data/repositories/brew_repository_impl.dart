import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/drift_database.dart' as db;
import '../../domain/entities/brew_record.dart' as domain;
import '../../domain/repositories/brew_repository.dart';
import '../datasources/brew_local_datasource.dart';

/// Concrete implementation of [BrewRepository] backed by Drift (SQLite).
///
/// Converts between the Drift-generated [db.BrewRecord] rows and the
/// pure-Dart [domain.BrewRecord] entity used by the domain/presentation
/// layers.
///
/// Ref: docs/01_Architecture.md § 4.1 — brewRepositoryProvider
class BrewRepositoryImpl implements BrewRepository {
  const BrewRepositoryImpl(this._datasource);

  final BrewLocalDatasource _datasource;

  // ── Mapping helpers ────────────────────────────────────────────────────

  domain.BrewRecord _toDomain(db.BrewRecord row) => domain.BrewRecord(
    id: row.id,
    brewDate: row.brewDate,
    beanName: row.beanName,
    equipmentId: row.equipmentId,
    grindMode: _grindModeToDomain(row.grindMode),
    grindClickValue: row.grindClickValue,
    grindSimpleLabel: row.grindSimpleLabel,
    grindMicrons: row.grindMicrons,
    coffeeWeightG: row.coffeeWeightG,
    waterWeightG: row.waterWeightG,
    waterTempC: row.waterTempC,
    brewDurationS: row.brewDurationS,
    bloomTimeS: row.bloomTimeS,
    pourMethod: row.pourMethod,
    waterType: row.waterType,
    roomTempC: row.roomTempC,
    notes: row.notes,
    isQuickMode: row.isQuickMode,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  domain.GrindMode _grindModeToDomain(String raw) {
    switch (raw) {
      case 'simple':
        return domain.GrindMode.simple;
      case 'pro':
        return domain.GrindMode.pro;
      default:
        return domain.GrindMode.equipment;
    }
  }

  String _grindModeToDb(domain.GrindMode mode) {
    switch (mode) {
      case domain.GrindMode.simple:
        return 'simple';
      case domain.GrindMode.pro:
        return 'pro';
      case domain.GrindMode.equipment:
        return 'equipment';
    }
  }

  db.BrewRecordsCompanion _toCompanion(domain.BrewRecord record) =>
      db.BrewRecordsCompanion(
        id: drift.Value(record.id),
        brewDate: drift.Value(record.brewDate),
        beanName: drift.Value(record.beanName),
        equipmentId: drift.Value(record.equipmentId),
        grindMode: drift.Value(_grindModeToDb(record.grindMode)),
        grindClickValue: drift.Value(record.grindClickValue),
        grindSimpleLabel: drift.Value(record.grindSimpleLabel),
        grindMicrons: drift.Value(record.grindMicrons),
        coffeeWeightG: drift.Value(record.coffeeWeightG),
        waterWeightG: drift.Value(record.waterWeightG),
        waterTempC: drift.Value(record.waterTempC),
        brewDurationS: drift.Value(record.brewDurationS),
        bloomTimeS: drift.Value(record.bloomTimeS),
        pourMethod: drift.Value(record.pourMethod),
        waterType: drift.Value(record.waterType),
        roomTempC: drift.Value(record.roomTempC),
        notes: drift.Value(record.notes),
        isQuickMode: drift.Value(record.isQuickMode),
        createdAt: drift.Value(record.createdAt),
        updatedAt: drift.Value(record.updatedAt),
      );

  db.BrewRecordsCompanion _toInsertCompanion(domain.BrewRecord record) =>
      db.BrewRecordsCompanion.insert(
        brewDate: record.brewDate,
        beanName: record.beanName,
        equipmentId: drift.Value(record.equipmentId),
        grindMode: drift.Value(_grindModeToDb(record.grindMode)),
        grindClickValue: drift.Value(record.grindClickValue),
        grindSimpleLabel: drift.Value(record.grindSimpleLabel),
        grindMicrons: drift.Value(record.grindMicrons),
        coffeeWeightG: record.coffeeWeightG,
        waterWeightG: record.waterWeightG,
        waterTempC: drift.Value(record.waterTempC),
        brewDurationS: record.brewDurationS,
        bloomTimeS: drift.Value(record.bloomTimeS),
        pourMethod: drift.Value(record.pourMethod),
        waterType: drift.Value(record.waterType),
        roomTempC: drift.Value(record.roomTempC),
        notes: drift.Value(record.notes),
        isQuickMode: drift.Value(record.isQuickMode),
        createdAt: drift.Value(record.createdAt),
        updatedAt: drift.Value(record.updatedAt),
      );

  // ── BrewRepository implementation ─────────────────────────────────────

  @override
  Future<List<domain.BrewRecord>> getAllBrewRecords() async {
    final rows = await _datasource.getAllBrewRecords();
    return rows.map(_toDomain).toList();
  }

  @override
  Stream<List<domain.BrewRecord>> watchAllBrewRecords() => _datasource
      .watchAllBrewRecords()
      .map((rows) => rows.map(_toDomain).toList());

  @override
  Future<domain.BrewRecord?> getBrewRecordById(int id) async {
    final row = await _datasource.getBrewRecordById(id);
    return row != null ? _toDomain(row) : null;
  }

  @override
  Future<int> createBrewRecord(domain.BrewRecord record) {
    final now = DateTime.now();
    final companion = _toInsertCompanion(
      record.copyWith(createdAt: now, updatedAt: now),
    );
    return _datasource.insertBrewRecord(companion);
  }

  @override
  Future<bool> updateBrewRecord(domain.BrewRecord record) {
    final companion = _toCompanion(record.copyWith(updatedAt: DateTime.now()));
    return _datasource.updateBrewRecord(companion);
  }

  @override
  Future<int> deleteBrewRecord(int id) => _datasource.deleteBrewRecord(id);
}

/// Riverpod provider for [BrewRepository].
final brewRepositoryProvider = Provider<BrewRepository>((ref) {
  return BrewRepositoryImpl(ref.watch(brewLocalDatasourceProvider));
});
