import '../entities/brew_summary.dart';
import '../entities/brew_detail.dart';

/// Filter criteria for querying brew history.
class BrewFilter {
  const BrewFilter({
    this.beanName,
    this.minScore,
    this.maxScore,
    this.from,
    this.to,
  });

  /// Filter by bean name (substring match, case-insensitive).
  final String? beanName;

  /// Minimum quick score (inclusive, 1–5).
  final int? minScore;

  /// Maximum quick score (inclusive, 1–5).
  final int? maxScore;

  /// Start of date range (inclusive).
  final DateTime? from;

  /// End of date range (inclusive).
  final DateTime? to;

  /// Returns `true` when no criteria have been set (i.e. "show all").
  bool get isEmpty =>
      beanName == null &&
      minScore == null &&
      maxScore == null &&
      from == null &&
      to == null;
}

/// Abstract Repository interface for brew history queries.
///
/// Combines brew records and their ratings into [BrewSummary] aggregates.
///
/// Ref: docs/01_Architecture.md § 4.1 — Repository pattern
abstract interface class HistoryRepository {
  /// Returns all brew summaries, newest-first.
  Future<List<BrewSummary>> getAllBrewSummaries();

  /// Returns brew summaries matching [filter], newest-first.
  Future<List<BrewSummary>> filterBrewSummaries(BrewFilter filter);

  /// Returns the top [limit] brew summaries ordered by quick score descending.
  Future<List<BrewSummary>> getTopBrews({int limit = 10});

  /// Returns the full detail aggregate for one brew record by [id].
  /// Returns `null` when no record exists.
  Future<BrewDetail?> getBrewDetailById(int id);
}
