import 'package:drift/drift.dart' as drift;

import '../../../../core/database/drift_database.dart' as db;
import '../../domain/entities/brew_rating.dart' as domain;
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating_local_datasource.dart';

class RatingRepositoryImpl implements RatingRepository {
  const RatingRepositoryImpl(this._datasource);

  final RatingLocalDatasource _datasource;

  domain.BrewRating _toDomain(db.BrewRating row) {
    return domain.BrewRating(
      id: row.id,
      brewRecordId: row.brewRecordId,
      quickScore: row.quickScore,
      emoji: row.emoji,
      acidity: row.acidity,
      sweetness: row.sweetness,
      bitterness: row.bitterness,
      body: row.body,
      flavorNotes: row.flavorNotes,
    );
  }

  db.BrewRatingsCompanion _toCompanion(domain.BrewRating rating) {
    return db.BrewRatingsCompanion(
      id: drift.Value(rating.id),
      brewRecordId: drift.Value(rating.brewRecordId),
      quickScore: drift.Value(rating.quickScore),
      emoji: drift.Value(rating.emoji),
      acidity: drift.Value(rating.acidity),
      sweetness: drift.Value(rating.sweetness),
      bitterness: drift.Value(rating.bitterness),
      body: drift.Value(rating.body),
      flavorNotes: drift.Value(rating.flavorNotes),
    );
  }

  db.BrewRatingsCompanion _toInsertCompanion(domain.BrewRating rating) {
    return db.BrewRatingsCompanion.insert(
      brewRecordId: rating.brewRecordId,
      quickScore: rating.quickScore == null
          ? const drift.Value.absent()
          : drift.Value(rating.quickScore),
      emoji: rating.emoji == null
          ? const drift.Value.absent()
          : drift.Value(rating.emoji),
      acidity: rating.acidity == null
          ? const drift.Value.absent()
          : drift.Value(rating.acidity),
      sweetness: rating.sweetness == null
          ? const drift.Value.absent()
          : drift.Value(rating.sweetness),
      bitterness: rating.bitterness == null
          ? const drift.Value.absent()
          : drift.Value(rating.bitterness),
      body: rating.body == null
          ? const drift.Value.absent()
          : drift.Value(rating.body),
      flavorNotes: rating.flavorNotes == null
          ? const drift.Value.absent()
          : drift.Value(rating.flavorNotes),
    );
  }

  void _validateRating(domain.BrewRating rating) {
    final quickScore = rating.quickScore;
    if (quickScore != null && (quickScore < 1 || quickScore > 5)) {
      throw ArgumentError.value(quickScore, 'quickScore', 'must be 1-5');
    }
  }

  @override
  Future<domain.BrewRating?> getRatingForBrew(int brewRecordId) async {
    final row = await _datasource.getRatingForBrew(brewRecordId);
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<int> createRating(domain.BrewRating rating) async {
    _validateRating(rating);
    return _datasource.insertRating(_toInsertCompanion(rating));
  }

  @override
  Future<bool> updateRating(domain.BrewRating rating) async {
    if (rating.id <= 0) {
      throw ArgumentError.value(
        rating.id,
        'id',
        'must be > 0 for update operation',
      );
    }
    _validateRating(rating);
    return _datasource.updateRating(_toCompanion(rating));
  }

  @override
  Future<int> deleteRating(int id) => _datasource.deleteRating(id);
}
