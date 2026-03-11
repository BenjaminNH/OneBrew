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

  /// Parameter type: 'number' | 'text'.
  TextColumn get type => text()();

  /// Optional unit label provided by user (e.g. "g", "C").
  TextColumn get unit => text().nullable()();

  /// Whether this is a system preset parameter.
  BoolColumn get isSystem => boolean().withDefault(const Constant(true))();

  /// Sort order within the method parameter list.
  IntColumn get sortOrder => integer()();
}
