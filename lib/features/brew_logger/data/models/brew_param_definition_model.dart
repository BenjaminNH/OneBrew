import 'package:drift/drift.dart';

/// Drift table for brew parameter definitions.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewParamDefinition
class BrewParamDefinitions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Method identifier: 'pour_over' | 'espresso' | 'custom'.
  TextColumn get method => text()();

  /// Parameter display name (e.g. "Water Temp").
  TextColumn get name => text()();

  /// Stable semantic key for system params (e.g. "water_temp").
  TextColumn get paramKey => text().nullable()();

  /// Parameter type: 'number' | 'text'.
  TextColumn get type => text()();

  /// Optional unit label provided by user (e.g. "g", "C").
  TextColumn get unit => text().nullable()();

  /// Optional minimum value for number-type parameters.
  RealColumn get numberMin => real().nullable()();

  /// Optional maximum value for number-type parameters.
  RealColumn get numberMax => real().nullable()();

  /// Optional step used by slider/input snapping.
  RealColumn get numberStep => real().nullable()();

  /// Optional default value for number-type parameters.
  RealColumn get numberDefault => real().nullable()();

  /// Whether this is a system preset parameter.
  BoolColumn get isSystem => boolean().withDefault(const Constant(true))();

  /// Sort order within the method parameter list.
  IntColumn get sortOrder => integer()();
}
