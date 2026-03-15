import 'package:drift/drift.dart';

/// Drift key-value table for app-level persisted settings.
class AppSettings extends Table {
  TextColumn get key => text()();

  BoolColumn get boolValue => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {key};
}
