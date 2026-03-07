import '../entities/brew_rating.dart';

/// Abstract Repository interface for BrewRating persistence.
///
/// Ref: docs/01_Architecture.md § 4.1 — Repository pattern
abstract interface class RatingRepository {
  /// Returns the rating for a given [brewRecordId], or `null` if unrated.
  Future<BrewRating?> getRatingForBrew(int brewRecordId);

  /// Persists a new [rating] and returns its assigned ID.
  Future<int> createRating(BrewRating rating);

  /// Updates an existing [rating]. Returns `true` if a row was changed.
  Future<bool> updateRating(BrewRating rating);

  /// Deletes a rating by [id]. Returns the number of deleted rows.
  Future<int> deleteRating(int id);
}
