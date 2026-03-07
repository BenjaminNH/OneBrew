import '../entities/brew_rating.dart';
import '../repositories/rating_repository.dart';

/// Use Case: save (create or update) a [BrewRating] for a brew record.
///
/// If a rating already exists for [BrewRating.brewRecordId], it is updated;
/// otherwise a new rating row is created.
///
/// Returns the rating ID on success.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — rating use cases
class SaveRating {
  const SaveRating(this._repository);

  final RatingRepository _repository;

  /// Saves [rating]: updates if [rating.id] > 0, creates otherwise.
  Future<int> call(BrewRating rating) async {
    if (rating.id > 0) {
      await _repository.updateRating(rating);
      return rating.id;
    }
    return _repository.createRating(rating);
  }
}
