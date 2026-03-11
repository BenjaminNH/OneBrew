import 'package:drift/drift.dart';

/// Drift table for brew method configuration.
///
/// Defines which brew methods are enabled and their default record mode.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewMethodConfig
class BrewMethodConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Method identifier: 'pour_over' | 'espresso' | 'custom'.
  TextColumn get method => text().unique()();

  /// Display name shown in UI (e.g. "Pour Over").
  TextColumn get displayName => text()();

  /// Default record mode: 'quick' | 'detail' | 'pro'.
  TextColumn get defaultRecordMode => text()();

  /// Whether this brew method is enabled for the user.
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
}
