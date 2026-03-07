import '../entities/brew_record.dart';
import '../repositories/brew_repository.dart';

/// Use Case: create a new [BrewRecord] and persist it.
///
/// Returns the newly assigned record ID on success.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — brew_logger use cases
class CreateBrewRecord {
  const CreateBrewRecord(this._repository);

  final BrewRepository _repository;

  /// Creates [record] in the repository.
  ///
  /// Callers should supply a record with a placeholder [BrewRecord.id]
  /// (e.g. `0`); the actual persisted ID is returned.
  Future<int> call(BrewRecord record) => _repository.createBrewRecord(record);
}
