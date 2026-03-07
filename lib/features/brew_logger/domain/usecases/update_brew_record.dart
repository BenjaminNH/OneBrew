import '../entities/brew_record.dart';
import '../repositories/brew_repository.dart';

/// Use Case: update an existing [BrewRecord].
///
/// Returns `true` if the record was found and updated.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — brew_logger use cases
class UpdateBrewRecord {
  const UpdateBrewRecord(this._repository);

  final BrewRepository _repository;

  /// Updates [record] in the repository.
  Future<bool> call(BrewRecord record) => _repository.updateBrewRecord(record);
}
