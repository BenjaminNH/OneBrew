import '../entities/brew_summary.dart';
import '../repositories/history_repository.dart';

/// Use Case: retrieve the full brew history as a list of [BrewSummary].
///
/// Results are ordered newest-first.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — history use cases
class GetBrewHistory {
  const GetBrewHistory(this._repository);

  final HistoryRepository _repository;

  /// Returns all brew summaries, newest-first.
  Future<List<BrewSummary>> call() => _repository.getAllBrewSummaries();
}
