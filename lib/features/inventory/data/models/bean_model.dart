import 'package:drift/drift.dart';

/// Drift Table definition for Bean (咖啡豆).
///
/// Beans are automatically created when a user types a new bean name
/// for the first time. [useCount] tracks how often each bean is used,
/// enabling smart autocomplete sorted by frequency.
///
/// Ref: docs/01_Architecture.md § 3.2 — Bean entity
class Beans extends Table {
  /// Auto-incremented primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Bean name, unique across all beans (e.g. "Ethiopia Yirgacheffe").
  TextColumn get name => text().unique()();

  /// Roaster / producer name (optional).
  TextColumn get roaster => text().nullable()();

  /// Origin / country of origin (optional).
  TextColumn get origin => text().nullable()();

  /// Roast level description (optional, e.g. "Light", "Medium").
  TextColumn get roastLevel => text().nullable()();

  /// Timestamp when this bean was first added to the inventory.
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  /// Number of brew records that reference this bean.
  /// Used for smart autocomplete ordering.
  IntColumn get useCount => integer().withDefault(const Constant(0))();
}
