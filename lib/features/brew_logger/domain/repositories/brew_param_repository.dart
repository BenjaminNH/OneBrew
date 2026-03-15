import '../entities/brew_method_config.dart';
import '../entities/brew_param_definition.dart';
import '../entities/brew_param_value.dart';
import '../entities/brew_param_visibility.dart';
import '../entities/brew_method.dart';

/// Repository interface for brew parameter configuration and values.
///
/// Ref: docs/05_Development_Plan.md § Phase 7D
abstract interface class BrewParamRepository {
  // Brew method configs
  Future<List<BrewMethodConfig>> getMethodConfigs();
  Future<BrewMethodConfig?> getMethodConfigByMethod(BrewMethod method);
  Future<int> createMethodConfig(BrewMethodConfig config);
  Future<bool> updateMethodConfig(BrewMethodConfig config);
  Future<int> deleteMethodConfig(int id);
  Future<bool> hasAnyMethodConfigs();

  // Param definitions
  Future<List<BrewParamDefinition>> getParamDefinitions(BrewMethod method);
  Future<BrewParamDefinition?> getParamDefinitionById(int id);
  Future<int> createParamDefinition(BrewParamDefinition definition);
  Future<bool> updateParamDefinition(BrewParamDefinition definition);
  Future<int> deleteParamDefinition(int id);
  Future<bool> hasAnyParamDefinitions();

  // Param visibility
  Future<List<BrewParamVisibility>> getParamVisibilities(BrewMethod method);
  Future<int> createParamVisibility(BrewParamVisibility visibility);
  Future<bool> updateParamVisibility(BrewParamVisibility visibility);
  Future<int> deleteParamVisibility(int id);

  // Param values
  Future<List<BrewParamValue>> getParamValuesForBrew(int brewRecordId);
  Future<int> createParamValue(BrewParamValue value);
  Future<bool> updateParamValue(BrewParamValue value);
  Future<int> deleteParamValue(int id);

  // Onboarding completion
  Future<bool> hasCompletedOnboarding();
  Future<void> setOnboardingCompleted(bool completed);
}
