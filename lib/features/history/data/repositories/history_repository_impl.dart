import '../../domain/entities/brew_summary.dart' as domain;
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._datasource);

  final HistoryLocalDatasource _datasource;

  domain.BrewSummary _toDomain(HistoryBrewRow row) => domain.BrewSummary(
    id: row.id,
    brewDate: row.brewDate,
    beanName: row.beanName,
    roaster: row.roaster,
    brewDurationS: row.brewDurationS,
    coffeeWeightG: row.coffeeWeightG,
    waterWeightG: row.waterWeightG,
    quickScore: row.quickScore,
    emoji: row.emoji,
    isQuickMode: row.isQuickMode,
    notes: row.notes,
  );

  @override
  Future<List<domain.BrewSummary>> getAllBrewSummaries() async {
    final rows = await _datasource.getAllBrewSummaries();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<domain.BrewSummary>> filterBrewSummaries(
    BrewFilter filter,
  ) async {
    final rows = await _datasource.filterBrewSummaries(
      beanName: filter.beanName,
      minScore: filter.minScore,
      maxScore: filter.maxScore,
      from: filter.from,
      to: filter.to,
    );
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<domain.BrewSummary>> getTopBrews({int limit = 10}) async {
    final rows = await _datasource.getTopBrews(limit: limit);
    return rows.map(_toDomain).toList();
  }
}
