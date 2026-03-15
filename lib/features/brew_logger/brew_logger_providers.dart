import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/brew_param_local_datasource.dart';
import 'data/datasources/brew_local_datasource.dart';
import 'data/repositories/brew_param_repository_impl.dart';
import 'data/repositories/brew_repository_impl.dart';
import 'domain/entities/brew_method.dart';
import 'domain/entities/brew_method_config.dart';
import 'domain/entities/brew_param_definition.dart';
import 'domain/entities/brew_param_visibility.dart';
import 'domain/repositories/brew_param_repository.dart';
import 'domain/repositories/brew_repository.dart';
import 'domain/usecases/initialize_default_brew_params.dart';

/// Composition-root provider for selecting [BrewRepository] implementation.
final brewRepositoryProvider = Provider<BrewRepository>((ref) {
  return BrewRepositoryImpl(ref.watch(brewLocalDatasourceProvider));
});

/// Composition-root provider for selecting [BrewParamRepository] implementation.
final brewParamRepositoryProvider = Provider<BrewParamRepository>((ref) {
  return BrewParamRepositoryImpl(ref.watch(brewParamLocalDatasourceProvider));
});

/// Bootstraps default brew parameter templates on first launch.
///
/// Returns `true` when the app should show onboarding (first run).
final brewParamBootstrapProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(brewParamRepositoryProvider);
  await InitializeDefaultBrewParams(repo).call();
  final hasCompletedOnboarding = await repo.hasCompletedOnboarding();
  return !hasCompletedOnboarding;
});

/// Loads all brew method configs (used by onboarding/preferences & brew page).
final brewMethodConfigsProvider = FutureProvider<List<BrewMethodConfig>>((
  ref,
) async {
  await ref.watch(brewParamBootstrapProvider.future);
  return ref.watch(brewParamRepositoryProvider).getMethodConfigs();
});

class BrewParamCatalog {
  BrewParamCatalog({
    required this.method,
    required this.definitions,
    required this.visibilities,
  });

  final BrewMethod method;
  final List<BrewParamDefinition> definitions;
  final List<BrewParamVisibility> visibilities;

  Map<int, BrewParamVisibility> get visibilityByParamId => {
    for (final visibility in visibilities) visibility.paramId: visibility,
  };

  BrewParamDefinition? definitionByName(String name) {
    for (final def in definitions) {
      if (def.name == name) return def;
    }
    return null;
  }

  bool isVisibleByName(String name) {
    final def = definitionByName(name);
    if (def == null) return false;
    return visibilityByParamId[def.id]?.isVisible ?? true;
  }

  List<BrewParamDefinition> get visibleDefinitions {
    final visibilityMap = visibilityByParamId;
    final visible = definitions
        .where((def) => visibilityMap[def.id]?.isVisible ?? true)
        .toList();
    visible.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return visible;
  }
}

/// Loads param definitions + visibility configuration for a brew method.
final brewParamCatalogProvider =
    FutureProvider.family<BrewParamCatalog, BrewMethod>((ref, method) async {
      await ref.watch(brewParamBootstrapProvider.future);
      final repo = ref.watch(brewParamRepositoryProvider);
      final defs = await repo.getParamDefinitions(method);
      final vis = await repo.getParamVisibilities(method);
      defs.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return BrewParamCatalog(
        method: method,
        definitions: defs,
        visibilities: vis,
      );
    });
