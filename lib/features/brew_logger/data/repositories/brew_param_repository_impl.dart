import 'package:drift/drift.dart' as drift;

import '../../../../core/database/drift_database.dart' as db;
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../../domain/entities/brew_param_value.dart';
import '../../domain/entities/brew_param_visibility.dart';
import '../../domain/repositories/brew_param_repository.dart';
import '../datasources/brew_param_local_datasource.dart';

/// Drift-backed implementation of [BrewParamRepository].
class BrewParamRepositoryImpl implements BrewParamRepository {
  const BrewParamRepositoryImpl(this._datasource);

  final BrewParamLocalDatasource _datasource;

  // ── Mapping helpers ────────────────────────────────────────────────────

  BrewMethod _methodFromDb(String raw) {
    switch (raw) {
      case 'espresso':
        return BrewMethod.espresso;
      case 'custom':
        return BrewMethod.custom;
      default:
        return BrewMethod.pourOver;
    }
  }

  String _methodToDb(BrewMethod method) {
    switch (method) {
      case BrewMethod.espresso:
        return 'espresso';
      case BrewMethod.custom:
        return 'custom';
      case BrewMethod.pourOver:
        return 'pour_over';
    }
  }


  ParamType _paramTypeFromDb(String raw) {
    switch (raw) {
      case 'text':
        return ParamType.text;
      default:
        return ParamType.number;
    }
  }

  String _paramTypeToDb(ParamType type) {
    switch (type) {
      case ParamType.text:
        return 'text';
      case ParamType.number:
        return 'number';
    }
  }

  BrewMethodConfig _methodConfigToDomain(db.BrewMethodConfig row) =>
      BrewMethodConfig(
        id: row.id,
        method: _methodFromDb(row.method),
        displayName: row.displayName,
        isEnabled: row.isEnabled,
      );

  db.BrewMethodConfigsCompanion _methodConfigToCompanion(
    BrewMethodConfig config,
  ) => db.BrewMethodConfigsCompanion(
    id: drift.Value(config.id),
    method: drift.Value(_methodToDb(config.method)),
    displayName: drift.Value(config.displayName),
    isEnabled: drift.Value(config.isEnabled),
  );

  db.BrewMethodConfigsCompanion _methodConfigToInsertCompanion(
    BrewMethodConfig config,
  ) => db.BrewMethodConfigsCompanion.insert(
    method: _methodToDb(config.method),
    displayName: config.displayName,
    isEnabled: drift.Value(config.isEnabled),
  );

  BrewParamDefinition _paramDefinitionToDomain(db.BrewParamDefinition row) =>
      BrewParamDefinition(
        id: row.id,
        method: _methodFromDb(row.method),
        name: row.name,
        type: _paramTypeFromDb(row.type),
        unit: row.unit,
        isSystem: row.isSystem,
        sortOrder: row.sortOrder,
      );

  db.BrewParamDefinitionsCompanion _paramDefinitionToCompanion(
    BrewParamDefinition def,
  ) => db.BrewParamDefinitionsCompanion(
    id: drift.Value(def.id),
    method: drift.Value(_methodToDb(def.method)),
    name: drift.Value(def.name),
    type: drift.Value(_paramTypeToDb(def.type)),
    unit: drift.Value(def.unit),
    isSystem: drift.Value(def.isSystem),
    sortOrder: drift.Value(def.sortOrder),
  );

  db.BrewParamDefinitionsCompanion _paramDefinitionToInsertCompanion(
    BrewParamDefinition def,
  ) => db.BrewParamDefinitionsCompanion.insert(
    method: _methodToDb(def.method),
    name: def.name,
    type: _paramTypeToDb(def.type),
    unit: drift.Value(def.unit),
    isSystem: drift.Value(def.isSystem),
    sortOrder: def.sortOrder,
  );

  BrewParamVisibility _paramVisibilityToDomain(db.BrewParamVisibility row) =>
      BrewParamVisibility(
        id: row.id,
        method: _methodFromDb(row.method),
        paramId: row.paramId,
        isVisible: row.isVisible,
      );

  db.BrewParamVisibilitiesCompanion _paramVisibilityToCompanion(
    BrewParamVisibility vis,
  ) => db.BrewParamVisibilitiesCompanion(
    id: drift.Value(vis.id),
    method: drift.Value(_methodToDb(vis.method)),
    paramId: drift.Value(vis.paramId),
    isVisible: drift.Value(vis.isVisible),
  );

  db.BrewParamVisibilitiesCompanion _paramVisibilityToInsertCompanion(
    BrewParamVisibility vis,
  ) => db.BrewParamVisibilitiesCompanion.insert(
    method: _methodToDb(vis.method),
    paramId: vis.paramId,
    isVisible: drift.Value(vis.isVisible),
  );

  BrewParamValue _paramValueToDomain(db.BrewParamValue row) => BrewParamValue(
    id: row.id,
    brewRecordId: row.brewRecordId,
    paramId: row.paramId,
    valueNumber: row.valueNumber,
    valueText: row.valueText,
  );

  db.BrewParamValuesCompanion _paramValueToCompanion(BrewParamValue value) =>
      db.BrewParamValuesCompanion(
        id: drift.Value(value.id),
        brewRecordId: drift.Value(value.brewRecordId),
        paramId: drift.Value(value.paramId),
        valueNumber: drift.Value(value.valueNumber),
        valueText: drift.Value(value.valueText),
      );

  db.BrewParamValuesCompanion _paramValueToInsertCompanion(
    BrewParamValue value,
  ) => db.BrewParamValuesCompanion.insert(
    brewRecordId: value.brewRecordId,
    paramId: value.paramId,
    valueNumber: drift.Value(value.valueNumber),
    valueText: drift.Value(value.valueText),
  );

  // ── Brew method config ───────────────────────────────────────────────

  @override
  Future<List<BrewMethodConfig>> getMethodConfigs() async {
    final rows = await _datasource.getMethodConfigs();
    return rows.map(_methodConfigToDomain).toList();
  }

  @override
  Future<BrewMethodConfig?> getMethodConfigByMethod(BrewMethod method) async {
    final row = await _datasource.getMethodConfigByMethod(_methodToDb(method));
    return row == null ? null : _methodConfigToDomain(row);
  }

  @override
  Future<int> createMethodConfig(BrewMethodConfig config) {
    final companion = _methodConfigToInsertCompanion(config);
    return _datasource.insertMethodConfig(companion);
  }

  @override
  Future<bool> updateMethodConfig(BrewMethodConfig config) {
    return _datasource.updateMethodConfig(_methodConfigToCompanion(config));
  }

  @override
  Future<int> deleteMethodConfig(int id) => _datasource.deleteMethodConfig(id);

  @override
  Future<bool> hasAnyMethodConfigs() async {
    final count = await _datasource.countMethodConfigs();
    return count > 0;
  }

  // ── Param definitions ────────────────────────────────────────────────

  @override
  Future<List<BrewParamDefinition>> getParamDefinitions(BrewMethod method) async {
    final rows = await _datasource.getParamDefinitionsByMethod(
      _methodToDb(method),
    );
    return rows.map(_paramDefinitionToDomain).toList();
  }

  @override
  Future<BrewParamDefinition?> getParamDefinitionById(int id) async {
    final row = await _datasource.getParamDefinitionById(id);
    return row == null ? null : _paramDefinitionToDomain(row);
  }

  @override
  Future<int> createParamDefinition(BrewParamDefinition definition) {
    final companion = _paramDefinitionToInsertCompanion(definition);
    return _datasource.insertParamDefinition(companion);
  }

  @override
  Future<bool> updateParamDefinition(BrewParamDefinition definition) {
    return _datasource.updateParamDefinition(
      _paramDefinitionToCompanion(definition),
    );
  }

  @override
  Future<int> deleteParamDefinition(int id) async {
    await _datasource.deleteParamVisibilitiesByParamId(id);
    await _datasource.deleteParamValuesByParamId(id);
    return _datasource.deleteParamDefinition(id);
  }

  @override
  Future<bool> hasAnyParamDefinitions() async {
    final count = await _datasource.countParamDefinitions();
    return count > 0;
  }

  // ── Param visibility ────────────────────────────────────────────────

  @override
  Future<List<BrewParamVisibility>> getParamVisibilities(
    BrewMethod method,
  ) async {
    final rows = await _datasource.getParamVisibilitiesByMethod(
      _methodToDb(method),
    );
    return rows.map(_paramVisibilityToDomain).toList();
  }

  @override
  Future<int> createParamVisibility(BrewParamVisibility visibility) {
    final companion = _paramVisibilityToInsertCompanion(visibility);
    return _datasource.insertParamVisibility(companion);
  }

  @override
  Future<bool> updateParamVisibility(BrewParamVisibility visibility) {
    return _datasource.updateParamVisibility(
      _paramVisibilityToCompanion(visibility),
    );
  }

  @override
  Future<int> deleteParamVisibility(int id) =>
      _datasource.deleteParamVisibility(id);

  // ── Param values ────────────────────────────────────────────────────

  @override
  Future<List<BrewParamValue>> getParamValuesForBrew(int brewRecordId) async {
    final rows = await _datasource.getParamValuesForBrew(brewRecordId);
    return rows.map(_paramValueToDomain).toList();
  }

  @override
  Future<int> createParamValue(BrewParamValue value) {
    final companion = _paramValueToInsertCompanion(value);
    return _datasource.insertParamValue(companion);
  }

  @override
  Future<bool> updateParamValue(BrewParamValue value) {
    return _datasource.updateParamValue(_paramValueToCompanion(value));
  }

  @override
  Future<int> deleteParamValue(int id) => _datasource.deleteParamValue(id);
}
