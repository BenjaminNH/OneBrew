import 'package:freezed_annotation/freezed_annotation.dart';

part 'brew_rating.freezed.dart';

/// Pure-Dart Domain entity representing a user's rating for a brew session.
///
/// Supports two modes:
/// - **Quick mode**: [quickScore] (1–5) and/or an [emoji] label.
/// - **Professional mode**: individual sliders for [acidity], [sweetness],
///   [bitterness], [body] (each 0–10), plus [flavorNotes] tag text.
///
/// Both modes can coexist on the same record; the UI decides which fields
/// to surface based on user preference.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewRating entity
@freezed
abstract class BrewRating with _$BrewRating {
  const factory BrewRating({
    /// Unique identifier.
    required int id,

    /// FK: the brew record this rating belongs to.
    required int brewRecordId,

    /// Quick score 1–5 (optional).
    int? quickScore,

    /// Emoji label for quick feedback (optional, e.g. "😍").
    String? emoji,

    /// Acidity score 0–10 (professional mode, optional).
    double? acidity,

    /// Sweetness score 0–10 (professional mode, optional).
    double? sweetness,

    /// Bitterness score 0–10 (professional mode, optional).
    double? bitterness,

    /// Body / mouthfeel score 0–10 (professional mode, optional).
    double? body,

    /// Comma-separated (or JSON) flavor tag notes (optional).
    String? flavorNotes,
  }) = _BrewRating;
}
