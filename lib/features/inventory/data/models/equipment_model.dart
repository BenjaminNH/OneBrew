import 'package:drift/drift.dart';

/// Drift Table definition for Equipment (器具/磨豆机).
///
/// Equipment is created on first use and tracked via [useCount].
/// When [isGrinder] is true, grind-click calibration fields are available,
/// enabling the "equipment-linked" grind mode in BrewRecord.
///
/// Ref: docs/01_Architecture.md § 3.2 — Equipment entity
/// Ref: docs/01_Architecture.md § ADR-004 — 研磨度三模式设计
class Equipments extends Table {
  /// Auto-incremented primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Equipment name, unique (e.g. "Comandante C40", "V60").
  TextColumn get name => text().unique()();

  /// Category: 'grinder' | 'dripper' | 'kettle' | 'other' (optional).
  TextColumn get category => text().nullable()();

  /// Whether this equipment is a grinder.
  /// When true, grind-click fields are shown and the equipment-linked
  /// grind mode becomes available in BrewRecord.
  BoolColumn get isGrinder => boolean().withDefault(const Constant(false))();

  /// Soft delete flag. Deleted equipment stays for historical records
  /// but is hidden from active inventory lists and suggestions.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  /// Minimum grind click value for grinders (e.g. 0).
  RealColumn get grindMinClick => real().nullable()();

  /// Maximum grind click value for grinders (e.g. 40).
  RealColumn get grindMaxClick => real().nullable()();

  /// Step size between clicks (e.g. 1.0 or 0.5 for half-clicks).
  RealColumn get grindClickStep => real().nullable()();

  /// Label for the click unit (e.g. "clicks", "格", "数字").
  TextColumn get grindClickUnit => text().nullable()();

  /// Timestamp when this equipment was first added.
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  /// Number of brew records that reference this equipment.
  IntColumn get useCount => integer().withDefault(const Constant(0))();
}
