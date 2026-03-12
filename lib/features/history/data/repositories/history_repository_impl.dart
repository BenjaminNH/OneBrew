import '../../domain/entities/brew_summary.dart' as domain;
import '../../domain/entities/brew_detail.dart' as detail_domain;
import '../../../brew_logger/domain/entities/brew_record.dart' as brew_domain;
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
    notes: row.notes,
  );

  detail_domain.BrewDetail _toDetailDomain(HistoryBrewDetailRow row) =>
      detail_domain.BrewDetail(
        id: row.id,
        brewDate: row.brewDate,
        beanName: row.beanName,
        roaster: row.roaster,
        origin: row.origin,
        roastLevel: row.roastLevel,
        equipmentId: row.equipmentId,
        equipmentName: row.equipmentName,
        grindMode: _toGrindMode(row.grindMode),
        grindClickValue: row.grindClickValue,
        grindClickUnit: row.grindClickUnit,
        grindSimpleLabel: row.grindSimpleLabel,
        grindMicrons: row.grindMicrons,
        coffeeWeightG: row.coffeeWeightG,
        waterWeightG: row.waterWeightG,
        waterTempC: row.waterTempC,
        brewDurationS: row.brewDurationS,
        bloomTimeS: row.bloomTimeS,
        pourMethod: row.pourMethod,
        waterType: row.waterType,
        roomTempC: row.roomTempC,
        quickScore: row.quickScore,
        emoji: row.emoji,
        acidity: row.acidity,
        sweetness: row.sweetness,
        bitterness: row.bitterness,
        body: row.body,
        flavorNotes: row.flavorNotes,
        notes: row.notes,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  brew_domain.GrindMode _toGrindMode(String raw) {
    switch (raw) {
      case 'simple':
        return brew_domain.GrindMode.simple;
      case 'pro':
        return brew_domain.GrindMode.pro;
      default:
        return brew_domain.GrindMode.equipment;
    }
  }

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

  @override
  Future<detail_domain.BrewDetail?> getBrewDetailById(int id) async {
    final row = await _datasource.getBrewDetailById(id);
    if (row == null) {
      return null;
    }
    return _toDetailDomain(row);
  }
}
