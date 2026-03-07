import '../entities/brew_summary.dart';
import '../repositories/history_repository.dart';

/// Use Case: filter brew history by bean name, score range, or date range.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — history use cases
class FilterBrews {
  const FilterBrews(this._repository);

  final HistoryRepository _repository;

  /// Returns brew summaries matching [filter], newest-first.
  ///
  /// If [filter.isEmpty] is `true`, all summaries are returned (no filter
  /// overhead compared to [GetBrewHistory]).
  Future<List<BrewSummary>> call(BrewFilter filter) {
    if (filter.isEmpty) return _repository.getAllBrewSummaries();
    return _repository.filterBrewSummaries(filter);
  }
}
