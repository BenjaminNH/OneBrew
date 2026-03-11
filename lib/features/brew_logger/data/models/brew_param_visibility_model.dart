import 'package:drift/drift.dart';

import 'brew_param_definition_model.dart';

/// Drift table for per-method parameter visibility.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewParamVisibility
class BrewParamVisibilities extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Method identifier: 'pour_over' | 'espresso' | 'custom'.
  TextColumn get method => text()();

  /// FK to parameter definition.
  IntColumn get paramId => integer().references(BrewParamDefinitions, #id)();

  /// Whether this parameter is visible in the record UI.
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
}
