import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/drift_database.dart';
import '../../../../shared/providers/database_providers.dart';

/// Data transfer object for a joined history row.
class HistoryBrewRow {
  const HistoryBrewRow({
    required this.id,
    required this.brewDate,
    required this.beanName,
    required this.roaster,
    required this.brewDurationS,
    required this.coffeeWeightG,
    required this.waterWeightG,
    required this.quickScore,
    required this.emoji,
    required this.isQuickMode,
    required this.notes,
  });

  final int id;
  final DateTime brewDate;
  final String beanName;
  final String? roaster;
  final int brewDurationS;
  final double coffeeWeightG;
  final double waterWeightG;
  final int? quickScore;
  final String? emoji;
  final bool isQuickMode;
  final String? notes;
}

/// Local datasource for history feature queries.
///
/// Uses joined queries over brew records + ratings (+ bean metadata).
class HistoryLocalDatasource {
  const HistoryLocalDatasource(this._db);

  final OneCoffeeDatabase _db;

  Future<List<HistoryBrewRow>> getAllBrewSummaries() async {
    final query = _db.select(_db.brewRecords).join([
      leftOuterJoin(
        _db.brewRatings,
        _db.brewRatings.brewRecordId.equalsExp(_db.brewRecords.id),
      ),
      leftOuterJoin(
        _db.beans,
        _db.beans.name.equalsExp(_db.brewRecords.beanName),
      ),
    ]);

    query.orderBy([OrderingTerm.desc(_db.brewRecords.brewDate)]);

    final rows = await query.get();
    return rows.map(_mapJoinedRow).toList();
  }

  Future<List<HistoryBrewRow>> filterBrewSummaries({
    String? beanName,
    int? minScore,
    int? maxScore,
    DateTime? from,
    DateTime? to,
  }) async {
    final query = _db.select(_db.brewRecords).join([
      leftOuterJoin(
        _db.brewRatings,
        _db.brewRatings.brewRecordId.equalsExp(_db.brewRecords.id),
      ),
      leftOuterJoin(
        _db.beans,
        _db.beans.name.equalsExp(_db.brewRecords.beanName),
      ),
    ]);

    final normalizedBean = beanName?.trim().toLowerCase();
    if (normalizedBean != null && normalizedBean.isNotEmpty) {
      query.where(_db.brewRecords.beanName.lower().like('%$normalizedBean%'));
    }
    if (minScore != null) {
      query.where(_db.brewRatings.quickScore.isBiggerOrEqualValue(minScore));
    }
    if (maxScore != null) {
      query.where(_db.brewRatings.quickScore.isSmallerOrEqualValue(maxScore));
    }
    if (from != null) {
      query.where(_db.brewRecords.brewDate.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where(_db.brewRecords.brewDate.isSmallerOrEqualValue(to));
    }

    query.orderBy([OrderingTerm.desc(_db.brewRecords.brewDate)]);

    final rows = await query.get();
    return rows.map(_mapJoinedRow).toList();
  }

  Future<List<HistoryBrewRow>> getTopBrews({int limit = 10}) async {
    final query = _db.select(_db.brewRecords).join([
      leftOuterJoin(
        _db.brewRatings,
        _db.brewRatings.brewRecordId.equalsExp(_db.brewRecords.id),
      ),
      leftOuterJoin(
        _db.beans,
        _db.beans.name.equalsExp(_db.brewRecords.beanName),
      ),
    ]);

    query.where(_db.brewRatings.quickScore.isNotNull());
    query.orderBy([
      OrderingTerm.desc(_db.brewRatings.quickScore),
      OrderingTerm.desc(_db.brewRecords.brewDate),
    ]);
    query.limit(limit);

    final rows = await query.get();
    return rows.map(_mapJoinedRow).toList();
  }

  HistoryBrewRow _mapJoinedRow(TypedResult row) {
    final brew = row.readTable(_db.brewRecords);
    final rating = row.readTableOrNull(_db.brewRatings);
    final bean = row.readTableOrNull(_db.beans);

    return HistoryBrewRow(
      id: brew.id,
      brewDate: brew.brewDate,
      beanName: brew.beanName,
      roaster: bean?.roaster,
      brewDurationS: brew.brewDurationS,
      coffeeWeightG: brew.coffeeWeightG,
      waterWeightG: brew.waterWeightG,
      quickScore: rating?.quickScore,
      emoji: rating?.emoji,
      isQuickMode: brew.isQuickMode,
      notes: brew.notes,
    );
  }
}

final historyLocalDatasourceProvider = Provider<HistoryLocalDatasource>((ref) {
  return HistoryLocalDatasource(ref.watch(databaseProvider));
});
