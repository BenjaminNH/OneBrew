import 'package:drift/drift.dart';

import 'brew_param_definition_model.dart';
import 'brew_record_model.dart';

/// Drift table for per-brew parameter values.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewParamValue
class BrewParamValues extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK to brew record.
  IntColumn get brewRecordId => integer().references(BrewRecords, #id)();

  /// FK to parameter definition.
  IntColumn get paramId => integer().references(BrewParamDefinitions, #id)();

  /// Numeric value (when ParamType == number).
  RealColumn get valueNumber => real().nullable()();

  /// Text value (when ParamType == text).
  TextColumn get valueText => text().nullable()();
}
