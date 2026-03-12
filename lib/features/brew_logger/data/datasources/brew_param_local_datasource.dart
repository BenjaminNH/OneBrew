import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/drift_database.dart';
import '../../../../shared/providers/database_providers.dart';

/// Local datasource for brew parameter configuration.
///
/// Delegates all database operations to [OneCoffeeDatabase].
class BrewParamLocalDatasource {
  const BrewParamLocalDatasource(this._db);

  final OneCoffeeDatabase _db;

  Future<List<BrewMethodConfig>> getMethodConfigs() => _db.getBrewMethodConfigs();

  Future<BrewMethodConfig?> getMethodConfigByMethod(String method) =>
      _db.getBrewMethodConfigByMethod(method);

  Future<int> insertMethodConfig(BrewMethodConfigsCompanion config) =>
      _db.insertBrewMethodConfig(config);

  Future<bool> updateMethodConfig(BrewMethodConfigsCompanion config) =>
      _db.updateBrewMethodConfig(config);

  Future<int> deleteMethodConfig(int id) => _db.deleteBrewMethodConfig(id);

  Future<int> countMethodConfigs() => _db.countBrewMethodConfigs();

  Future<List<BrewParamDefinition>> getParamDefinitionsByMethod(String method) =>
      _db.getBrewParamDefinitionsByMethod(method);

  Future<BrewParamDefinition?> getParamDefinitionById(int id) =>
      _db.getBrewParamDefinitionById(id);

  Future<int> insertParamDefinition(BrewParamDefinitionsCompanion definition) =>
      _db.insertBrewParamDefinition(definition);

  Future<bool> updateParamDefinition(BrewParamDefinitionsCompanion definition) =>
      _db.updateBrewParamDefinition(definition);

  Future<int> deleteParamDefinition(int id) => _db.deleteBrewParamDefinition(id);

  Future<int> deleteParamVisibilitiesByParamId(int paramId) =>
      _db.deleteBrewParamVisibilitiesByParamId(paramId);

  Future<int> deleteParamValuesByParamId(int paramId) =>
      _db.deleteBrewParamValuesByParamId(paramId);

  Future<int> countParamDefinitions() => _db.countBrewParamDefinitions();

  Future<List<BrewParamVisibility>> getParamVisibilitiesByMethod(String method) =>
      _db.getBrewParamVisibilitiesByMethod(method);

  Future<int> insertParamVisibility(BrewParamVisibilitiesCompanion visibility) =>
      _db.insertBrewParamVisibility(visibility);

  Future<bool> updateParamVisibility(BrewParamVisibilitiesCompanion visibility) =>
      _db.updateBrewParamVisibility(visibility);

  Future<int> deleteParamVisibility(int id) => _db.deleteBrewParamVisibility(id);

  Future<List<BrewParamValue>> getParamValuesForBrew(int brewRecordId) =>
      _db.getBrewParamValuesForBrew(brewRecordId);

  Future<int> insertParamValue(BrewParamValuesCompanion value) =>
      _db.insertBrewParamValue(value);

  Future<bool> updateParamValue(BrewParamValuesCompanion value) =>
      _db.updateBrewParamValue(value);

  Future<int> deleteParamValue(int id) => _db.deleteBrewParamValue(id);
}

final brewParamLocalDatasourceProvider = Provider<BrewParamLocalDatasource>((ref) {
  return BrewParamLocalDatasource(ref.watch(databaseProvider));
});
