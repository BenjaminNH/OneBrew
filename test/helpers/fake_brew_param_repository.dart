import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method_config.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_value.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_visibility.dart';
import 'package:one_brew/features/brew_logger/domain/repositories/brew_param_repository.dart';

class FakeBrewParamRepository implements BrewParamRepository {
  FakeBrewParamRepository({
    List<BrewMethodConfig>? methodConfigs,
    Map<BrewMethod, List<BrewParamDefinition>>? definitions,
    Map<BrewMethod, List<BrewParamVisibility>>? visibilities,
    Map<int, List<BrewParamValue>>? valuesByBrew,
  })  : _methodConfigs = methodConfigs ??
            [
              const BrewMethodConfig(
                id: 1,
                method: BrewMethod.pourOver,
                displayName: 'Pour Over',
                isEnabled: true,
              ),
              const BrewMethodConfig(
                id: 2,
                method: BrewMethod.espresso,
                displayName: 'Espresso',
                isEnabled: true,
              ),
            ],
        _definitions = definitions ??
            {
              BrewMethod.pourOver: [
                const BrewParamDefinition(
                  id: 1,
                  method: BrewMethod.pourOver,
                  name: 'Coffee Weight',
                  type: ParamType.number,
                  unit: 'g',
                  isSystem: true,
                  sortOrder: 1,
                ),
                const BrewParamDefinition(
                  id: 2,
                  method: BrewMethod.pourOver,
                  name: 'Water Weight',
                  type: ParamType.number,
                  unit: 'g',
                  isSystem: true,
                  sortOrder: 2,
                ),
                const BrewParamDefinition(
                  id: 3,
                  method: BrewMethod.pourOver,
                  name: 'Grind Size',
                  type: ParamType.text,
                  isSystem: true,
                  sortOrder: 3,
                ),
              ],
            },
        _visibilities = visibilities ??
            {
              BrewMethod.pourOver: [
                const BrewParamVisibility(
                  id: 1,
                  method: BrewMethod.pourOver,
                  paramId: 1,
                  isVisible: true,
                ),
                const BrewParamVisibility(
                  id: 2,
                  method: BrewMethod.pourOver,
                  paramId: 2,
                  isVisible: true,
                ),
                const BrewParamVisibility(
                  id: 3,
                  method: BrewMethod.pourOver,
                  paramId: 3,
                  isVisible: true,
                ),
              ],
            },
        _valuesByBrew = valuesByBrew ?? {};

  final List<BrewMethodConfig> _methodConfigs;
  final Map<BrewMethod, List<BrewParamDefinition>> _definitions;
  final Map<BrewMethod, List<BrewParamVisibility>> _visibilities;
  final Map<int, List<BrewParamValue>> _valuesByBrew;

  int _nextMethodId = 10;
  int _nextDefId = 100;
  int _nextVisId = 200;
  int _nextValueId = 300;

  // ── Brew method configs ──────────────────────────────────────────────

  @override
  Future<List<BrewMethodConfig>> getMethodConfigs() async =>
      List<BrewMethodConfig>.from(_methodConfigs);

  @override
  Future<BrewMethodConfig?> getMethodConfigByMethod(BrewMethod method) async {
    for (final config in _methodConfigs) {
      if (config.method == method) return config;
    }
    return null;
  }

  @override
  Future<int> createMethodConfig(BrewMethodConfig config) async {
    final id = _nextMethodId++;
    _methodConfigs.add(config.copyWith(id: id));
    return id;
  }

  @override
  Future<bool> updateMethodConfig(BrewMethodConfig config) async {
    final index = _methodConfigs.indexWhere((c) => c.id == config.id);
    if (index == -1) return false;
    _methodConfigs[index] = config;
    return true;
  }

  @override
  Future<int> deleteMethodConfig(int id) async {
    _methodConfigs.removeWhere((c) => c.id == id);
    return 1;
  }

  @override
  Future<bool> hasAnyMethodConfigs() async => _methodConfigs.isNotEmpty;

  // ── Param definitions ────────────────────────────────────────────────

  @override
  Future<List<BrewParamDefinition>> getParamDefinitions(
    BrewMethod method,
  ) async =>
      List<BrewParamDefinition>.from(_definitions[method] ?? const []);

  @override
  Future<BrewParamDefinition?> getParamDefinitionById(int id) async {
    for (final defs in _definitions.values) {
      for (final def in defs) {
        if (def.id == id) return def;
      }
    }
    return null;
  }

  @override
  Future<int> createParamDefinition(BrewParamDefinition definition) async {
    final id = _nextDefId++;
    final list = _definitions.putIfAbsent(
      definition.method,
      () => <BrewParamDefinition>[],
    );
    list.add(definition.copyWith(id: id));
    return id;
  }

  @override
  Future<bool> updateParamDefinition(BrewParamDefinition definition) async {
    final list = _definitions[definition.method];
    if (list == null) return false;
    final index = list.indexWhere((d) => d.id == definition.id);
    if (index == -1) return false;
    list[index] = definition;
    return true;
  }

  @override
  Future<int> deleteParamDefinition(int id) async {
    for (final entry in _definitions.entries) {
      entry.value.removeWhere((def) => def.id == id);
    }
    for (final entry in _visibilities.entries) {
      entry.value.removeWhere((vis) => vis.paramId == id);
    }
    for (final entry in _valuesByBrew.entries) {
      entry.value.removeWhere((value) => value.paramId == id);
    }
    return 1;
  }

  @override
  Future<bool> hasAnyParamDefinitions() async =>
      _definitions.values.any((list) => list.isNotEmpty);

  // ── Param visibility ────────────────────────────────────────────────

  @override
  Future<List<BrewParamVisibility>> getParamVisibilities(
    BrewMethod method,
  ) async =>
      List<BrewParamVisibility>.from(_visibilities[method] ?? const []);

  @override
  Future<int> createParamVisibility(BrewParamVisibility visibility) async {
    final id = _nextVisId++;
    final list = _visibilities.putIfAbsent(
      visibility.method,
      () => <BrewParamVisibility>[],
    );
    list.add(visibility.copyWith(id: id));
    return id;
  }

  @override
  Future<bool> updateParamVisibility(BrewParamVisibility visibility) async {
    final list = _visibilities[visibility.method];
    if (list == null) return false;
    final index = list.indexWhere((v) => v.id == visibility.id);
    if (index == -1) return false;
    list[index] = visibility;
    return true;
  }

  @override
  Future<int> deleteParamVisibility(int id) async {
    for (final entry in _visibilities.entries) {
      entry.value.removeWhere((v) => v.id == id);
    }
    return 1;
  }

  // ── Param values ────────────────────────────────────────────────────

  @override
  Future<List<BrewParamValue>> getParamValuesForBrew(int brewRecordId) async =>
      List<BrewParamValue>.from(_valuesByBrew[brewRecordId] ?? const []);

  @override
  Future<int> createParamValue(BrewParamValue value) async {
    final id = _nextValueId++;
    final list = _valuesByBrew.putIfAbsent(
      value.brewRecordId,
      () => <BrewParamValue>[],
    );
    list.add(
      BrewParamValue(
        id: id,
        brewRecordId: value.brewRecordId,
        paramId: value.paramId,
        valueNumber: value.valueNumber,
        valueText: value.valueText,
      ),
    );
    return id;
  }

  @override
  Future<bool> updateParamValue(BrewParamValue value) async {
    final list = _valuesByBrew[value.brewRecordId];
    if (list == null) return false;
    final index = list.indexWhere((v) => v.id == value.id);
    if (index == -1) return false;
    list[index] = value;
    return true;
  }

  @override
  Future<int> deleteParamValue(int id) async {
    for (final entry in _valuesByBrew.entries) {
      entry.value.removeWhere((v) => v.id == id);
    }
    return 1;
  }
}
