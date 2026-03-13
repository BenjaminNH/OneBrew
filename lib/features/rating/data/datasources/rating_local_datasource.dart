import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/drift_database.dart';
import '../../../../shared/providers/database_providers.dart';

/// Local data source for BrewRating persistence using Drift.
abstract interface class RatingLocalDatasource {
  Future<BrewRating?> getRatingForBrew(int brewRecordId);
  Future<int> insertRating(BrewRatingsCompanion rating);
  Future<bool> updateRating(BrewRatingsCompanion rating);
  Future<int> deleteRating(int id);
}

class RatingLocalDatasourceImpl implements RatingLocalDatasource {
  const RatingLocalDatasourceImpl(this._db);

  final OneBrewDatabase _db;

  @override
  Future<BrewRating?> getRatingForBrew(int brewRecordId) =>
      _db.getRatingForBrew(brewRecordId);

  @override
  Future<int> insertRating(BrewRatingsCompanion rating) =>
      _db.insertRating(rating);

  @override
  Future<bool> updateRating(BrewRatingsCompanion rating) =>
      _db.updateRating(rating);

  @override
  Future<int> deleteRating(int id) => _db.deleteRating(id);
}

final ratingLocalDatasourceProvider = Provider<RatingLocalDatasource>((ref) {
  return RatingLocalDatasourceImpl(ref.watch(databaseProvider));
});
