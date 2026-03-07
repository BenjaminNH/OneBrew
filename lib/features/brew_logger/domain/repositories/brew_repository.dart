import '../entities/brew_record.dart';

/// Abstract Repository interface for BrewRecord persistence.
///
/// The Domain layer depends only on this interface.
/// The concrete implementation lives in the Data layer
/// (`brew_logger/data/repositories/brew_repository_impl.dart`).
///
/// Ref: docs/01_Architecture.md § 4.1 — Repository pattern
abstract interface class BrewRepository {
  /// Returns all brew records sorted newest-first.
  Future<List<BrewRecord>> getAllBrewRecords();

  /// Returns a reactive stream of all brew records (newest-first).
  Stream<List<BrewRecord>> watchAllBrewRecords();

  /// Returns a single brew record by [id], or `null` if not found.
  Future<BrewRecord?> getBrewRecordById(int id);

  /// Persists a new brew record and returns its assigned [BrewRecord.id].
  Future<int> createBrewRecord(BrewRecord record);

  /// Updates an existing brew record. Returns `true` if a row was changed.
  Future<bool> updateBrewRecord(BrewRecord record);

  /// Deletes a brew record by [id]. Returns the number of deleted rows.
  Future<int> deleteBrewRecord(int id);
}
