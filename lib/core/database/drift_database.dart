import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/brew_logger/data/models/brew_record_model.dart';
import '../../features/brew_logger/data/models/brew_method_config_model.dart';
import '../../features/brew_logger/data/models/brew_param_definition_model.dart';
import '../../features/brew_logger/data/models/brew_param_visibility_model.dart';
import '../../features/brew_logger/data/models/brew_param_value_model.dart';
import '../../features/inventory/data/models/bean_model.dart';
import '../../features/inventory/data/models/equipment_model.dart';
import '../../features/rating/data/models/brew_rating_model.dart';

// Generated part — produced by `dart run build_runner build`
part 'drift_database.g.dart';

/// Opens the SQLite database file located in the device's application
/// documents directory. Uses WAL journal mode for better concurrent read
/// performance.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'one_brew.db'));
    return NativeDatabase.createInBackground(file);
  });
}

class _SystemParamRangeSeed {
  const _SystemParamRangeSeed({
    required this.method,
    required this.name,
    required this.min,
    required this.max,
    required this.step,
    required this.defaultValue,
  });

  final String method;
  final String name;
  final double min;
  final double max;
  final double step;
  final double defaultValue;
}

const List<_SystemParamRangeSeed> _systemParamRangeSeeds = [
  _SystemParamRangeSeed(
    method: 'pour_over',
    name: 'Coffee Weight',
    min: 8.0,
    max: 40.0,
    step: 0.1,
    defaultValue: 15.0,
  ),
  _SystemParamRangeSeed(
    method: 'pour_over',
    name: 'Water Weight',
    min: 120.0,
    max: 700.0,
    step: 1.0,
    defaultValue: 225.0,
  ),
  _SystemParamRangeSeed(
    method: 'pour_over',
    name: 'Brew Ratio',
    min: 10.0,
    max: 22.0,
    step: 0.1,
    defaultValue: 15.0,
  ),
  _SystemParamRangeSeed(
    method: 'pour_over',
    name: 'Water Temp',
    min: 80.0,
    max: 100.0,
    step: 1.0,
    defaultValue: 93.0,
  ),
  _SystemParamRangeSeed(
    method: 'pour_over',
    name: 'Brew Time',
    min: 30.0,
    max: 480.0,
    step: 1.0,
    defaultValue: 180.0,
  ),
  _SystemParamRangeSeed(
    method: 'pour_over',
    name: 'Bloom Time',
    min: 0.0,
    max: 90.0,
    step: 1.0,
    defaultValue: 30.0,
  ),
  _SystemParamRangeSeed(
    method: 'pour_over',
    name: 'Bloom Water',
    min: 0.0,
    max: 200.0,
    step: 1.0,
    defaultValue: 30.0,
  ),
  _SystemParamRangeSeed(
    method: 'espresso',
    name: 'Coffee Dose',
    min: 12.0,
    max: 24.0,
    step: 0.1,
    defaultValue: 18.0,
  ),
  _SystemParamRangeSeed(
    method: 'espresso',
    name: 'Yield',
    min: 18.0,
    max: 60.0,
    step: 0.5,
    defaultValue: 36.0,
  ),
  _SystemParamRangeSeed(
    method: 'espresso',
    name: 'Brew Ratio',
    min: 1.0,
    max: 4.0,
    step: 0.1,
    defaultValue: 2.0,
  ),
  _SystemParamRangeSeed(
    method: 'espresso',
    name: 'Extraction Time',
    min: 15.0,
    max: 45.0,
    step: 1.0,
    defaultValue: 30.0,
  ),
  _SystemParamRangeSeed(
    method: 'espresso',
    name: 'Pressure',
    min: 6.0,
    max: 11.0,
    step: 0.1,
    defaultValue: 9.0,
  ),
  _SystemParamRangeSeed(
    method: 'espresso',
    name: 'Water Temp',
    min: 85.0,
    max: 98.0,
    step: 1.0,
    defaultValue: 93.0,
  ),
  _SystemParamRangeSeed(
    method: 'espresso',
    name: 'Pre-infusion Time',
    min: 0.0,
    max: 20.0,
    step: 1.0,
    defaultValue: 8.0,
  ),
  _SystemParamRangeSeed(
    method: 'custom',
    name: 'Coffee Weight',
    min: 8.0,
    max: 40.0,
    step: 0.1,
    defaultValue: 15.0,
  ),
  _SystemParamRangeSeed(
    method: 'custom',
    name: 'Water Weight',
    min: 120.0,
    max: 700.0,
    step: 1.0,
    defaultValue: 225.0,
  ),
  _SystemParamRangeSeed(
    method: 'custom',
    name: 'Brew Ratio',
    min: 8.0,
    max: 24.0,
    step: 0.1,
    defaultValue: 15.0,
  ),
];

/// Main Drift database for OneBrew.
///
/// Contains all domain tables:
///   - [Beans]                — coffee bean inventory
///   - [Equipments]           — brew equipment / grinder inventory
///   - [BrewRecords]          — individual brew session records
///   - [BrewRatings]          — optional rating attached to a brew record
///   - [BrewMethodConfigs]    — brew method preferences
///   - [BrewParamDefinitions] — parameter definitions per method
///   - [BrewParamVisibilities]— per-method visibility rules
///   - [BrewParamValues]      — recorded parameter values per brew
///
/// Use [OneBrewDatabase.instance] (or the Riverpod provider from
/// `shared/providers/database_providers.dart`) to get a singleton.
///
/// Foreign-key enforcement is enabled via a pragma on connection open.
///
/// Ref: docs/01_Architecture.md § 4.1 — driftDatabaseProvider
@DriftDatabase(
  tables: [
    Beans,
    Equipments,
    BrewRecords,
    BrewRatings,
    BrewMethodConfigs,
    BrewParamDefinitions,
    BrewParamVisibilities,
    BrewParamValues,
  ],
)
class OneBrewDatabase extends _$OneBrewDatabase {
  /// Creates a database backed by the given [QueryExecutor].
  /// Use the named constructor [OneBrewDatabase.forTesting] for in-memory
  /// test databases.
  OneBrewDatabase() : super(_openConnection());

  /// Creates an in-memory database for widget and unit tests.
  OneBrewDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(equipments, equipments.isDeleted);
      }
      if (from < 3) {
        await m.addColumn(brewRecords, brewRecords.brewMethod);
        await m.createTable(brewMethodConfigs);
        await m.createTable(brewParamDefinitions);
        await m.createTable(brewParamVisibilities);
        await m.createTable(brewParamValues);
      }
      if (from < 4) {
        // RecordMode (quick/detail/pro) was removed; reset tables that stored
        // the old columns to avoid schema mismatches.
        await m.deleteTable('brew_param_values');
        await m.deleteTable('brew_ratings');
        await m.deleteTable('brew_records');
        await m.deleteTable('brew_method_configs');

        await m.createTable(brewMethodConfigs);
        await m.createTable(brewRecords);
        await m.createTable(brewRatings);
        await m.createTable(brewParamValues);
      }
      if (from >= 3 && from < 5) {
        await m.addColumn(brewParamDefinitions, brewParamDefinitions.numberMin);
        await m.addColumn(brewParamDefinitions, brewParamDefinitions.numberMax);
        await m.addColumn(
          brewParamDefinitions,
          brewParamDefinitions.numberStep,
        );
        await m.addColumn(
          brewParamDefinitions,
          brewParamDefinitions.numberDefault,
        );
        await _backfillSystemParamRanges();
      }
    },
    beforeOpen: (details) async {
      // Enable foreign-key constraints on every connection.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _backfillSystemParamRanges() async {
    for (final seed in _systemParamRangeSeeds) {
      await customStatement(
        'UPDATE brew_param_definitions '
        'SET number_min = ?, number_max = ?, number_step = ?, number_default = ? '
        'WHERE method = ? AND name = ? AND type = ?',
        [
          seed.min,
          seed.max,
          seed.step,
          seed.defaultValue,
          seed.method,
          seed.name,
          'number',
        ],
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Bean queries
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns all beans ordered by [Beans.useCount] descending
  /// (most-used first — smart autocomplete order).
  Future<List<Bean>> getAllBeans() =>
      (select(beans)..orderBy([
            (b) => OrderingTerm.desc(b.useCount),
            (b) => OrderingTerm.desc(b.addedAt),
          ]))
          .get();

  /// Returns beans whose [Beans.name] contains [query] (case-insensitive).
  Future<List<Bean>> searchBeans(String query) =>
      (select(beans)
            ..where((b) => b.name.lower().contains(query.toLowerCase()))
            ..orderBy([
              (b) => OrderingTerm.desc(b.useCount),
              (b) => OrderingTerm.desc(b.addedAt),
            ]))
          .get();

  /// Returns a single bean by [id], or null when not found.
  Future<Bean?> getBeanById(int id) =>
      (select(beans)..where((b) => b.id.equals(id))).getSingleOrNull();

  /// Inserts a new bean; returns the new row's id.
  Future<int> insertBean(BeansCompanion bean) => into(beans).insert(bean);

  /// Updates an existing bean.
  Future<bool> updateBean(BeansCompanion bean) => update(beans).replace(bean);

  /// Deletes a bean by [id].
  Future<int> deleteBean(int id) =>
      (delete(beans)..where((b) => b.id.equals(id))).go();

  /// Increments [Beans.useCount] for the bean with the given [id].
  Future<void> incrementBeanUseCount(int id) async {
    await customStatement(
      'UPDATE beans SET use_count = use_count + 1 WHERE id = ?',
      [id],
    );
  }

  /// Renames a bean and propagates its name to historical brew records
  /// in one transaction.
  Future<bool> renameBeanAndPropagate({
    required int beanId,
    required String newName,
  }) async {
    return transaction(() async {
      final existingBean = await getBeanById(beanId);
      if (existingBean == null) return false;

      await (update(beans)..where((b) => b.id.equals(beanId))).write(
        BeansCompanion(name: Value(newName)),
      );
      await customStatement(
        'UPDATE brew_records SET bean_name = ? WHERE lower(bean_name) = lower(?)',
        [newName, existingBean.name],
      );
      return true;
    });
  }

  /// Counts brew records referencing the given bean name (case-insensitive).
  Future<int> countBrewRecordsByBeanName(String beanName) async {
    final row = await customSelect(
      'SELECT COUNT(*) AS ref_count FROM brew_records '
      'WHERE lower(bean_name) = lower(?)',
      variables: [Variable<String>(beanName)],
      readsFrom: {brewRecords},
    ).getSingle();
    return row.read<int>('ref_count');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Equipment queries
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns all equipment ordered by [Equipments.useCount] descending.
  Future<List<Equipment>> getAllEquipments() =>
      (select(equipments)
            ..where((e) => e.isDeleted.equals(false))
            ..orderBy([
              (e) => OrderingTerm.desc(e.useCount),
              (e) => OrderingTerm.desc(e.addedAt),
            ]))
          .get();

  /// Returns equipment whose [Equipments.name] contains [query].
  Future<List<Equipment>> searchEquipments(String query) =>
      (select(equipments)
            ..where(
              (e) =>
                  e.isDeleted.equals(false) &
                  e.name.lower().contains(query.toLowerCase()),
            )
            ..orderBy([
              (e) => OrderingTerm.desc(e.useCount),
              (e) => OrderingTerm.desc(e.addedAt),
            ]))
          .get();

  /// Returns grinder equipment ordered by use count then add time.
  Future<List<Equipment>> getAllGrinders() =>
      (select(equipments)
            ..where((e) => e.isGrinder.equals(true) & e.isDeleted.equals(false))
            ..orderBy([
              (e) => OrderingTerm.desc(e.useCount),
              (e) => OrderingTerm.desc(e.addedAt),
            ]))
          .get();

  /// Returns grinder equipment filtered by [query].
  Future<List<Equipment>> searchGrinders(String query) =>
      (select(equipments)
            ..where(
              (e) =>
                  e.isGrinder.equals(true) &
                  e.isDeleted.equals(false) &
                  e.name.lower().contains(query.toLowerCase()),
            )
            ..orderBy([
              (e) => OrderingTerm.desc(e.useCount),
              (e) => OrderingTerm.desc(e.addedAt),
            ]))
          .get();

  /// Returns a single equipment by [id], or null when not found.
  Future<Equipment?> getEquipmentById(int id) =>
      (select(equipments)..where((e) => e.id.equals(id))).getSingleOrNull();

  /// Inserts a new equipment row; returns the new row's id.
  Future<int> insertEquipment(EquipmentsCompanion equipment) =>
      into(equipments).insert(equipment);

  /// Updates an existing equipment row.
  Future<bool> updateEquipment(EquipmentsCompanion equipment) =>
      update(equipments).replace(equipment);

  /// Deletes equipment by [id].
  Future<int> deleteEquipment(int id) =>
      (delete(equipments)..where((e) => e.id.equals(id))).go();

  /// Soft-deletes equipment by [id] (kept for history joins).
  Future<int> softDeleteEquipment(int id) =>
      (update(equipments)..where((e) => e.id.equals(id))).write(
        const EquipmentsCompanion(isDeleted: Value(true)),
      );

  /// Increments [Equipments.useCount] for the equipment with [id].
  Future<void> incrementEquipmentUseCount(int id) async {
    await customStatement(
      'UPDATE equipments SET use_count = use_count + 1 WHERE id = ?',
      [id],
    );
  }

  /// Counts brew records referencing equipment [id].
  Future<int> countBrewRecordsByEquipmentId(int id) async {
    final row = await customSelect(
      'SELECT COUNT(*) AS ref_count FROM brew_records WHERE equipment_id = ?',
      variables: [Variable<int>(id)],
      readsFrom: {brewRecords},
    ).getSingle();
    return row.read<int>('ref_count');
  }

  /// Clears [BrewRecords.equipmentId] for rows that reference the given
  /// equipment id.
  Future<void> clearBrewRecordEquipmentReferences(int id) async {
    await customStatement(
      'UPDATE brew_records SET equipment_id = NULL WHERE equipment_id = ?',
      [id],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BrewRecord queries
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns all brew records, newest first.
  Future<List<BrewRecord>> getAllBrewRecords() => (select(
    brewRecords,
  )..orderBy([(r) => OrderingTerm.desc(r.brewDate)])).get();

  /// Returns a reactive stream of all brew records (newest first).
  /// Suitable for list pages that need live updates.
  Stream<List<BrewRecord>> watchAllBrewRecords() => (select(
    brewRecords,
  )..orderBy([(r) => OrderingTerm.desc(r.brewDate)])).watch();

  /// Returns a single brew record by [id], or null if not found.
  Future<BrewRecord?> getBrewRecordById(int id) =>
      (select(brewRecords)..where((r) => r.id.equals(id))).getSingleOrNull();

  /// Inserts a new brew record; returns the new row's id.
  Future<int> insertBrewRecord(BrewRecordsCompanion record) =>
      into(brewRecords).insert(record);

  /// Updates an existing brew record.
  Future<bool> updateBrewRecord(BrewRecordsCompanion record) =>
      update(brewRecords).replace(record);

  /// Deletes a brew record by [id].
  /// The associated [BrewRatings] row is deleted automatically via FK cascade.
  Future<int> deleteBrewRecord(int id) =>
      (delete(brewRecords)..where((r) => r.id.equals(id))).go();

  // ─────────────────────────────────────────────────────────────────────────
  // BrewRating queries
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns the rating for a given [brewRecordId], or null if unrated.
  Future<BrewRating?> getRatingForBrew(int brewRecordId) => (select(
    brewRatings,
  )..where((r) => r.brewRecordId.equals(brewRecordId))).getSingleOrNull();

  /// Inserts a new rating; returns the new row's id.
  Future<int> insertRating(BrewRatingsCompanion rating) =>
      into(brewRatings).insert(rating);

  /// Updates an existing rating.
  Future<bool> updateRating(BrewRatingsCompanion rating) =>
      update(brewRatings).replace(rating);

  /// Deletes a rating by [id].
  Future<int> deleteRating(int id) =>
      (delete(brewRatings)..where((r) => r.id.equals(id))).go();

  // ─────────────────────────────────────────────────────────────────────────
  // BrewMethodConfig queries
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<BrewMethodConfig>> getBrewMethodConfigs() =>
      select(brewMethodConfigs).get();

  Future<BrewMethodConfig?> getBrewMethodConfigByMethod(String method) =>
      (select(
        brewMethodConfigs,
      )..where((m) => m.method.equals(method))).getSingleOrNull();

  Future<int> insertBrewMethodConfig(BrewMethodConfigsCompanion config) =>
      into(brewMethodConfigs).insert(config);

  Future<bool> updateBrewMethodConfig(BrewMethodConfigsCompanion config) =>
      update(brewMethodConfigs).replace(config);

  Future<int> deleteBrewMethodConfig(int id) =>
      (delete(brewMethodConfigs)..where((m) => m.id.equals(id))).go();

  Future<int> countBrewMethodConfigs() async {
    final row = await customSelect(
      'SELECT COUNT(*) AS config_count FROM brew_method_configs',
      readsFrom: {brewMethodConfigs},
    ).getSingle();
    return row.read<int>('config_count');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BrewParamDefinition queries
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<BrewParamDefinition>> getBrewParamDefinitionsByMethod(
    String method,
  ) =>
      (select(brewParamDefinitions)
            ..where((p) => p.method.equals(method))
            ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
          .get();

  Future<BrewParamDefinition?> getBrewParamDefinitionById(int id) => (select(
    brewParamDefinitions,
  )..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> insertBrewParamDefinition(BrewParamDefinitionsCompanion def) =>
      into(brewParamDefinitions).insert(def);

  Future<bool> updateBrewParamDefinition(BrewParamDefinitionsCompanion def) =>
      update(brewParamDefinitions).replace(def);

  Future<int> deleteBrewParamDefinition(int id) =>
      (delete(brewParamDefinitions)..where((p) => p.id.equals(id))).go();

  Future<int> deleteBrewParamVisibilitiesByParamId(int paramId) => (delete(
    brewParamVisibilities,
  )..where((v) => v.paramId.equals(paramId))).go();

  Future<int> deleteBrewParamValuesByParamId(int paramId) =>
      (delete(brewParamValues)..where((v) => v.paramId.equals(paramId))).go();

  Future<int> countBrewParamDefinitions() async {
    final row = await customSelect(
      'SELECT COUNT(*) AS def_count FROM brew_param_definitions',
      readsFrom: {brewParamDefinitions},
    ).getSingle();
    return row.read<int>('def_count');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BrewParamVisibility queries
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<BrewParamVisibility>> getBrewParamVisibilitiesByMethod(
    String method,
  ) =>
      (select(brewParamVisibilities)
            ..where((v) => v.method.equals(method))
            ..orderBy([(v) => OrderingTerm.asc(v.id)]))
          .get();

  Future<int> insertBrewParamVisibility(BrewParamVisibilitiesCompanion vis) =>
      into(brewParamVisibilities).insert(vis);

  Future<bool> updateBrewParamVisibility(BrewParamVisibilitiesCompanion vis) =>
      update(brewParamVisibilities).replace(vis);

  Future<int> deleteBrewParamVisibility(int id) =>
      (delete(brewParamVisibilities)..where((v) => v.id.equals(id))).go();

  // ─────────────────────────────────────────────────────────────────────────
  // BrewParamValue queries
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<BrewParamValue>> getBrewParamValuesForBrew(int brewRecordId) =>
      (select(
        brewParamValues,
      )..where((v) => v.brewRecordId.equals(brewRecordId))).get();

  Future<int> insertBrewParamValue(BrewParamValuesCompanion value) =>
      into(brewParamValues).insert(value);

  Future<bool> updateBrewParamValue(BrewParamValuesCompanion value) =>
      update(brewParamValues).replace(value);

  Future<int> deleteBrewParamValue(int id) =>
      (delete(brewParamValues)..where((v) => v.id.equals(id))).go();
}
