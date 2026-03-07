import '../repositories/brew_repository.dart';

/// Use Case: delete a [BrewRecord] by its identifier.
///
/// Returns the number of rows deleted (0 if the record did not exist).
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — brew_logger use cases
class DeleteBrewRecord {
  const DeleteBrewRecord(this._repository);

  final BrewRepository _repository;

  /// Deletes the record with the given [id].
  Future<int> call(int id) => _repository.deleteBrewRecord(id);
}
