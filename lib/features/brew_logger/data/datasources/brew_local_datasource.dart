import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/drift_database.dart';
import '../../../../shared/providers/database_providers.dart';

/// Local data source for BrewRecord persistence using Drift.
///
/// All database-level operations are delegated to [OneBrewDatabase].
/// Repository implementations call this class; they never access the DB
/// directly.
///
/// Ref: docs/01_Architecture.md § 4.1 — brewLocalDatasourceProvider
class BrewLocalDatasource {
  const BrewLocalDatasource(this._db);

  final OneBrewDatabase _db;

  /// Returns all brew records sorted newest-first.
  Future<List<BrewRecord>> getAllBrewRecords() => _db.getAllBrewRecords();

  /// Returns a live stream of all brew records (newest-first).
  Stream<List<BrewRecord>> watchAllBrewRecords() => _db.watchAllBrewRecords();

  /// Returns a single brew record by [id], or `null` if not found.
  Future<BrewRecord?> getBrewRecordById(int id) => _db.getBrewRecordById(id);

  /// Inserts a new brew record row; returns the new row's id.
  Future<int> insertBrewRecord(BrewRecordsCompanion record) =>
      _db.insertBrewRecord(record);

  /// Updates an existing brew record. Returns `true` if a row was changed.
  Future<bool> updateBrewRecord(BrewRecordsCompanion record) =>
      _db.updateBrewRecord(record);

  /// Deletes a brew record by [id]; returns the number of deleted rows.
  Future<int> deleteBrewRecord(int id) => _db.deleteBrewRecord(id);
}

/// Riverpod provider for [BrewLocalDatasource].
///
/// Depends on [databaseProvider] for the singleton database instance.
final brewLocalDatasourceProvider = Provider<BrewLocalDatasource>((ref) {
  return BrewLocalDatasource(ref.watch(databaseProvider));
});
