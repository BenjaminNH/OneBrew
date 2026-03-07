import '../entities/brew_summary.dart';
import '../repositories/history_repository.dart';

/// Use Case: retrieve the top-scored brew sessions.
///
/// Results are ordered by quick score descending (highest first).
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — history use cases
class GetTopBrews {
  const GetTopBrews(this._repository);

  final HistoryRepository _repository;

  /// Returns the top [limit] brew summaries by score.
  ///
  /// Defaults to 10 entries; callers may specify a different [limit].
  Future<List<BrewSummary>> call({int limit = 10}) =>
      _repository.getTopBrews(limit: limit);
}
