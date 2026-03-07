import 'package:drift/drift.dart';

import '../../../../features/brew_logger/data/models/brew_record_model.dart';

/// Drift Table definition for BrewRating (冲煮评价).
///
/// A 1-to-0..1 relationship with [BrewRecords] — each brew can have
/// at most one rating, covering both quick mode (star + emoji) and
/// professional mode (acidity, sweetness, bitterness, body, flavorNotes).
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewRating entity
class BrewRatings extends Table {
  /// Auto-incremented primary key.
  IntColumn get id => integer().autoIncrement()();

  /// FK to [BrewRecords.id] — the brew being rated.
  /// Cascade deletes: removing a brew record removes its rating automatically.
  IntColumn get brewRecordId => integer().unique().references(
    BrewRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// Quick star score (1–5). Null if the user skipped quick rating.
  IntColumn get quickScore => integer().nullable()();

  /// Emoji representing the tasting experience (e.g. "😊", "🥲").
  TextColumn get emoji => text().nullable()();

  /// Professional: acidity dimension (0.0–5.0).
  RealColumn get acidity => real().nullable()();

  /// Professional: sweetness dimension (0.0–5.0).
  RealColumn get sweetness => real().nullable()();

  /// Professional: bitterness dimension (0.0–5.0).
  RealColumn get bitterness => real().nullable()();

  /// Professional: body / mouthfeel dimension (0.0–5.0).
  RealColumn get body => real().nullable()();

  /// Comma-separated or JSON flavor note tags
  /// (e.g. "Citrus, Dark Chocolate, Floral").
  TextColumn get flavorNotes => text().nullable()();
}
