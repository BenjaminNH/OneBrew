import '../../../../shared/helpers/brew_param_defaults.dart';
import '../entities/brew_method.dart';
import '../entities/brew_method_config.dart';
import '../entities/brew_param_definition.dart';
import '../entities/brew_param_visibility.dart';
import '../repositories/brew_param_repository.dart';

/// Use case: initialize default brew method templates and parameters.
///
/// Creates method configs, param definitions, and visibilities once.
class InitializeDefaultBrewParams {
  const InitializeDefaultBrewParams(this._repository);

  final BrewParamRepository _repository;

  Future<void> call() async {
    final hasMethods = await _repository.hasAnyMethodConfigs();
    if (!hasMethods) {
      for (final seed in BrewParamDefaults.methodConfigSeeds) {
        await _repository.createMethodConfig(
          BrewMethodConfig(
            id: 0,
            method: seed.method,
            displayName: seed.displayName,
            isEnabled: seed.isEnabled,
          ),
        );
      }
    }

    final hasDefinitions = await _repository.hasAnyParamDefinitions();
    if (!hasDefinitions) {
      for (final template in BrewParamDefaults.paramTemplates) {
        final definitionId = await _repository.createParamDefinition(
          BrewParamDefinition(
            id: 0,
            method: template.method,
            name: template.name,
            type: template.type,
            unit: template.unit,
            isSystem: template.isSystem,
            sortOrder: template.sortOrder,
          ),
        );
        await _repository.createParamVisibility(
          BrewParamVisibility(
            id: 0,
            method: template.method,
            paramId: definitionId,
            isVisible: template.isVisible,
          ),
        );
      }
    }
  }
}
