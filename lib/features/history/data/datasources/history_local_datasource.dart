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
  final String? notes;
}

/// Data transfer object for a single brew detail row joined from multiple
/// tables.
class HistoryBrewDetailRow {
  const HistoryBrewDetailRow({
    required this.id,
    required this.brewDate,
    required this.beanName,
    required this.roaster,
    required this.origin,
    required this.roastLevel,
    required this.equipmentId,
    required this.equipmentName,
    required this.grindMode,
    required this.grindClickValue,
    required this.grindClickUnit,
    required this.grindSimpleLabel,
    required this.grindMicrons,
    required this.coffeeWeightG,
    required this.waterWeightG,
    required this.waterTempC,
    required this.brewDurationS,
    required this.bloomTimeS,
    required this.pourMethod,
    required this.waterType,
    required this.roomTempC,
    required this.quickScore,
    required this.emoji,
    required this.acidity,
    required this.sweetness,
    required this.bitterness,
    required this.body,
    required this.flavorNotes,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final DateTime brewDate;
  final String beanName;
  final String? roaster;
  final String? origin;
  final String? roastLevel;
  final int? equipmentId;
  final String? equipmentName;
  final String grindMode;
  final double? grindClickValue;
  final String? grindClickUnit;
  final String? grindSimpleLabel;
  final int? grindMicrons;
  final double coffeeWeightG;
  final double waterWeightG;
  final double? waterTempC;
  final int brewDurationS;
  final int? bloomTimeS;
  final String? pourMethod;
  final String? waterType;
  final double? roomTempC;
  final int? quickScore;
  final String? emoji;
  final double? acidity;
  final double? sweetness;
  final double? bitterness;
  final double? body;
  final String? flavorNotes;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Local datasource for history feature queries.
///
/// Uses joined queries over brew records + ratings (+ bean metadata).
class HistoryLocalDatasource {
  const HistoryLocalDatasource(this._db);

  final OneBrewDatabase _db;

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

  Future<HistoryBrewDetailRow?> getBrewDetailById(int brewId) async {
    final query = _db.select(_db.brewRecords).join([
      leftOuterJoin(
        _db.brewRatings,
        _db.brewRatings.brewRecordId.equalsExp(_db.brewRecords.id),
      ),
      leftOuterJoin(
        _db.beans,
        _db.beans.name.equalsExp(_db.brewRecords.beanName),
      ),
      leftOuterJoin(
        _db.equipments,
        _db.equipments.id.equalsExp(_db.brewRecords.equipmentId),
      ),
    ]);

    query.where(_db.brewRecords.id.equals(brewId));

    final row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _mapDetailJoinedRow(row);
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
      notes: brew.notes,
    );
  }

  HistoryBrewDetailRow _mapDetailJoinedRow(TypedResult row) {
    final brew = row.readTable(_db.brewRecords);
    final rating = row.readTableOrNull(_db.brewRatings);
    final bean = row.readTableOrNull(_db.beans);
    final equipment = row.readTableOrNull(_db.equipments);

    return HistoryBrewDetailRow(
      id: brew.id,
      brewDate: brew.brewDate,
      beanName: brew.beanName,
      roaster: bean?.roaster,
      origin: bean?.origin,
      roastLevel: bean?.roastLevel,
      equipmentId: brew.equipmentId,
      equipmentName: equipment?.name,
      grindMode: brew.grindMode,
      grindClickValue: brew.grindClickValue,
      grindClickUnit: equipment?.grindClickUnit,
      grindSimpleLabel: brew.grindSimpleLabel,
      grindMicrons: brew.grindMicrons,
      coffeeWeightG: brew.coffeeWeightG,
      waterWeightG: brew.waterWeightG,
      waterTempC: brew.waterTempC,
      brewDurationS: brew.brewDurationS,
      bloomTimeS: brew.bloomTimeS,
      pourMethod: brew.pourMethod,
      waterType: brew.waterType,
      roomTempC: brew.roomTempC,
      quickScore: rating?.quickScore,
      emoji: rating?.emoji,
      acidity: rating?.acidity,
      sweetness: rating?.sweetness,
      bitterness: rating?.bitterness,
      body: rating?.body,
      flavorNotes: rating?.flavorNotes,
      notes: brew.notes,
      createdAt: brew.createdAt,
      updatedAt: brew.updatedAt,
    );
  }
}

final historyLocalDatasourceProvider = Provider<HistoryLocalDatasource>((ref) {
  return HistoryLocalDatasource(ref.watch(databaseProvider));
});
