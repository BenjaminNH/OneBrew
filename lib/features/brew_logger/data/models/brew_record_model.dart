import 'package:drift/drift.dart';

import '../../../../features/inventory/data/models/bean_model.dart';
import '../../../../features/inventory/data/models/equipment_model.dart';

/// The three grind recording modes.
///
/// - [equipment]: Linked to a grinder's click range (most precise for repeatability)
/// - [simple]: 7-level coarse label (入门友好)
/// - [pro]: Direct micron value input (hardcore usage)
///
/// Ref: docs/01_Architecture.md § ADR-004
enum GrindMode { equipment, simple, pro }

/// Drift Table definition for BrewRecord (冲煮记录).
///
/// Central entity that captures a single brew session.
/// Keeps [beanName] as immutable snapshot/fallback display text and optionally
/// links to [Beans] through [beanId] for stable metadata lookup.
/// Also optionally links to [Equipments] via [equipmentId].
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewRecord entity
class BrewRecords extends Table {
  /// Auto-incremented primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Brew datetime (when the brew started).
  DateTimeColumn get brewDate => dateTime()();

  /// Bean name used in this brew (references Beans.name, stored as string).
  /// Stored as a name rather than FK to allow deletion of beans without
  /// losing historical brew records.
  TextColumn get beanName => text()();

  /// Optional FK to beans table for stable linkage and metadata joins.
  IntColumn get beanId => integer().nullable().references(
    Beans,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Optional FK to Equipments — used for equipment-linked grind mode.
  IntColumn get equipmentId =>
      integer().nullable().references(Equipments, #id)();

  /// Brew method classification.
  /// One of: 'pour_over', 'espresso', 'custom'.
  TextColumn get brewMethod =>
      text().withDefault(const Constant('pour_over'))();

  /// Grind recording mode.
  /// Maps to [GrindMode] enum via text encoding.
  TextColumn get grindMode => text().withDefault(const Constant('equipment'))();

  /// Grind click value when grindMode == GrindMode.equipment.
  RealColumn get grindClickValue => real().nullable()();

  /// Grind label when grindMode == GrindMode.simple.
  /// One of the 7 standard labels (e.g. "Medium", "Fine").
  TextColumn get grindSimpleLabel => text().nullable()();

  /// Grind micron value when grindMode == GrindMode.pro.
  IntColumn get grindMicrons => integer().nullable()();

  /// Coffee powder weight in grams.
  RealColumn get coffeeWeightG => real()();

  /// Water weight in grams.
  RealColumn get waterWeightG => real()();

  /// Water temperature in Celsius (optional).
  RealColumn get waterTempC => real().nullable()();

  /// Total brew duration in seconds.
  IntColumn get brewDurationS => integer()();

  /// Bloom time in seconds (optional pre-infusion).
  IntColumn get bloomTimeS => integer().nullable()();

  /// Pour method description (e.g. "Spiral", "Pulse").
  TextColumn get pourMethod => text().nullable()();

  /// Water quality description (e.g. "Filtered", "Mineral").
  TextColumn get waterType => text().nullable()();

  /// Room temperature in Celsius at time of brew (optional).
  RealColumn get roomTempC => real().nullable()();

  /// Freeform notes about this brew.
  TextColumn get notes => text().nullable()();

  /// When this record row was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When this record row was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
