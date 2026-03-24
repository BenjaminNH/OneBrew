import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../../domain/entities/brew_param_key.dart';
import '../../domain/entities/brew_param_visibility.dart';
import '../../domain/repositories/brew_param_repository.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';

class BrewParamItem {
  const BrewParamItem({required this.definition, required this.visibility});

  final BrewParamDefinition definition;
  final BrewParamVisibility visibility;

  bool get isVisible => visibility.isVisible;
  bool get isSystem => definition.isSystem;
}

class BrewPreferencesState {
  const BrewPreferencesState({
    this.isLoading = false,
    this.isFirstRun = false,
    this.selectedMethod = BrewMethod.pourOver,
    this.methodConfigs = const <BrewMethodConfig>[],
    this.paramDefinitions = const <BrewMethod, List<BrewParamDefinition>>{},
    this.paramVisibilities = const <BrewMethod, List<BrewParamVisibility>>{},
    this.errorMessage,
  });

  final bool isLoading;
  final bool isFirstRun;
  final BrewMethod selectedMethod;
  final List<BrewMethodConfig> methodConfigs;
  final Map<BrewMethod, List<BrewParamDefinition>> paramDefinitions;
  final Map<BrewMethod, List<BrewParamVisibility>> paramVisibilities;
  final String? errorMessage;

  List<BrewMethodConfig> get enabledMethodConfigs =>
      methodConfigs.where((config) => config.isEnabled).toList();

  BrewMethodConfig? get customMethodConfig {
    for (final config in methodConfigs) {
      if (config.method == BrewMethod.custom) return config;
    }
    return null;
  }

  bool get hasEnabledMethod => methodConfigs.any((config) => config.isEnabled);

  BrewPreferencesState copyWith({
    bool? isLoading,
    bool? isFirstRun,
    BrewMethod? selectedMethod,
    List<BrewMethodConfig>? methodConfigs,
    Map<BrewMethod, List<BrewParamDefinition>>? paramDefinitions,
    Map<BrewMethod, List<BrewParamVisibility>>? paramVisibilities,
    Object? errorMessage = _sentinel,
  }) {
    return BrewPreferencesState(
      isLoading: isLoading ?? this.isLoading,
      isFirstRun: isFirstRun ?? this.isFirstRun,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      methodConfigs: methodConfigs ?? this.methodConfigs,
      paramDefinitions: paramDefinitions ?? this.paramDefinitions,
      paramVisibilities: paramVisibilities ?? this.paramVisibilities,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  List<BrewParamItem> paramItemsFor(BrewMethod method) {
    final defs = paramDefinitions[method] ?? const <BrewParamDefinition>[];
    final vis = paramVisibilities[method] ?? const <BrewParamVisibility>[];
    final visibilityByParamId = {
      for (final visibility in vis) visibility.paramId: visibility,
    };

    final items = defs.map((def) {
      final visibility =
          visibilityByParamId[def.id] ??
          BrewParamVisibility(
            id: 0,
            method: method,
            paramId: def.id,
            isVisible: true,
          );
      return BrewParamItem(definition: def, visibility: visibility);
    }).toList();
    items.sort(
      (a, b) => a.definition.sortOrder.compareTo(b.definition.sortOrder),
    );
    return items;
  }
}

const _sentinel = Object();

class BrewPreferencesController extends Notifier<BrewPreferencesState> {
  @override
  BrewPreferencesState build() {
    Future.microtask(() => load(showLoading: true));
    return const BrewPreferencesState(isLoading: true);
  }

  Future<void> load({bool showLoading = false}) async {
    final shouldShowLoading = showLoading || state.methodConfigs.isEmpty;
    if (shouldShowLoading) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    } else {
      state = state.copyWith(errorMessage: null);
    }
    try {
      final isFirstRun = await ref.read(brewParamBootstrapProvider.future);
      final repo = ref.read(brewParamRepositoryProvider);

      final configs = await repo.getMethodConfigs();
      for (final config in configs) {
        if (config.method == BrewMethod.custom && config.isEnabled) {
          await _ensureCustomParamDefaults(repo);
          break;
        }
      }
      final definitions = <BrewMethod, List<BrewParamDefinition>>{};
      final visibilities = <BrewMethod, List<BrewParamVisibility>>{};

      for (final method in BrewMethod.values) {
        definitions[method] = await repo.getParamDefinitions(method);
        visibilities[method] = await repo.getParamVisibilities(method);
      }

      final enabledMethods = configs.where((c) => c.isEnabled).toList();
      final currentSelected = state.selectedMethod;
      final resolvedSelected =
          enabledMethods.any((c) => c.method == currentSelected)
          ? currentSelected
          : (enabledMethods.isNotEmpty
                ? enabledMethods.first.method
                : BrewMethod.pourOver);

      state = state.copyWith(
        isLoading: false,
        isFirstRun: isFirstRun,
        methodConfigs: configs,
        paramDefinitions: definitions,
        paramVisibilities: visibilities,
        selectedMethod: resolvedSelected,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load preferences: $e',
      );
    }
  }

  void selectMethod(BrewMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  Future<void> toggleMethodEnabled(
    BrewMethod method,
    bool isEnabled, {
    String? displayName,
  }) async {
    final configs = state.methodConfigs;
    BrewMethodConfig? current;
    for (final config in configs) {
      if (config.method == method) {
        current = config;
        break;
      }
    }

    final enabledCount = configs.where((c) => c.isEnabled).length;
    if (current != null &&
        current.isEnabled &&
        !isEnabled &&
        enabledCount <= 1) {
      state = state.copyWith(
        errorMessage: 'At least one brew method must stay enabled.',
      );
      return;
    }
    final trimmedName = displayName?.trim();
    if (trimmedName != null && trimmedName.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter a name for the custom method.',
      );
      return;
    }

    try {
      final repo = ref.read(brewParamRepositoryProvider);
      if (method == BrewMethod.custom && isEnabled) {
        await _ensureCustomParamDefaults(repo);
      }
      if (current == null) {
        if (method != BrewMethod.custom) {
          state = state.copyWith(errorMessage: 'Method config not found.');
          return;
        }
        await repo.createMethodConfig(
          BrewMethodConfig(
            id: 0,
            method: BrewMethod.custom,
            displayName: trimmedName ?? 'Custom',
            isEnabled: isEnabled,
          ),
        );
      } else {
        final updated = current.copyWith(
          isEnabled: isEnabled,
          displayName: trimmedName ?? current.displayName,
        );
        await repo.updateMethodConfig(updated);
      }
      ref.invalidate(brewMethodConfigsProvider);
      await load();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update method: $e');
    }
  }

  Future<void> renameCustomMethod(String displayName) async {
    final custom = state.customMethodConfig;
    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter a name for the custom method.',
      );
      return;
    }

    if (custom == null) {
      await toggleMethodEnabled(
        BrewMethod.custom,
        true,
        displayName: trimmedName,
      );
      return;
    }

    try {
      final repo = ref.read(brewParamRepositoryProvider);
      await _ensureCustomParamDefaults(repo);
      await repo.updateMethodConfig(
        custom.copyWith(isEnabled: true, displayName: trimmedName),
      );
      ref.invalidate(brewMethodConfigsProvider);
      await load();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to rename custom method: $e',
      );
    }
  }

  Future<void> deleteCustomMethod() async {
    final custom = state.customMethodConfig;
    if (custom == null) return;

    final enabledCount = state.methodConfigs.where((c) => c.isEnabled).length;
    if (custom.isEnabled && enabledCount <= 1) {
      state = state.copyWith(
        errorMessage: 'At least one brew method must stay enabled.',
      );
      return;
    }

    try {
      final repo = ref.read(brewParamRepositoryProvider);
      await repo.updateMethodConfig(
        custom.copyWith(isEnabled: false, displayName: 'Custom'),
      );
      ref.invalidate(brewMethodConfigsProvider);
      await load();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete custom method: $e',
      );
    }
  }

  Future<void> setParamVisibility(
    BrewMethod method,
    int paramId,
    bool isVisible,
  ) async {
    final visList = state.paramVisibilities[method] ?? const [];
    final existing = visList.firstWhere(
      (v) => v.paramId == paramId,
      orElse: () => BrewParamVisibility(
        id: 0,
        method: method,
        paramId: paramId,
        isVisible: true,
      ),
    );
    final updated = BrewParamVisibility(
      id: existing.id,
      method: method,
      paramId: paramId,
      isVisible: isVisible,
    );
    try {
      if (existing.id == 0) {
        await ref
            .read(brewParamRepositoryProvider)
            .createParamVisibility(updated);
      } else {
        await ref
            .read(brewParamRepositoryProvider)
            .updateParamVisibility(updated);
      }
      ref.invalidate(brewParamCatalogProvider);
      await load();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update parameter: $e');
    }
  }

  Future<void> addCustomParam({
    required BrewMethod method,
    required String name,
    required ParamType type,
    String? unit,
    double? numberMin,
    double? numberMax,
    double? numberStep,
    double? numberDefault,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(errorMessage: 'Parameter name is required.');
      return;
    }

    if (type == ParamType.number) {
      if (numberMin == null || numberMax == null) {
        state = state.copyWith(
          errorMessage:
              'Number parameters require both minimum and maximum values.',
        );
        return;
      }
      if (numberMax <= numberMin) {
        state = state.copyWith(
          errorMessage: 'Maximum value must be greater than minimum value.',
        );
        return;
      }
      if (numberStep != null && numberStep <= 0) {
        state = state.copyWith(errorMessage: 'Step must be greater than zero.');
        return;
      }
      if (numberDefault != null &&
          (numberDefault < numberMin || numberDefault > numberMax)) {
        state = state.copyWith(
          errorMessage: 'Default value must be within the min/max range.',
        );
        return;
      }
    }

    final defs = state.paramDefinitions[method] ?? const [];
    final exists = defs.any(
      (def) => def.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) {
      state = state.copyWith(errorMessage: 'Parameter already exists.');
      return;
    }

    final maxOrder = defs.isEmpty
        ? 0
        : defs.map((d) => d.sortOrder).reduce((a, b) => a > b ? a : b);

    try {
      final repo = ref.read(brewParamRepositoryProvider);
      final defId = await repo.createParamDefinition(
        BrewParamDefinition(
          id: 0,
          method: method,
          paramKey: null,
          name: trimmed,
          type: type,
          unit: unit?.trim().isEmpty == true ? null : unit?.trim(),
          numberMin: type == ParamType.number ? numberMin : null,
          numberMax: type == ParamType.number ? numberMax : null,
          numberStep: type == ParamType.number ? numberStep : null,
          numberDefault: type == ParamType.number ? numberDefault : null,
          isSystem: false,
          sortOrder: maxOrder + 1,
        ),
      );
      await repo.updateParamDefinition(
        BrewParamDefinition(
          id: defId,
          method: method,
          paramKey: customParamKeyForId(defId),
          name: trimmed,
          type: type,
          unit: unit?.trim().isEmpty == true ? null : unit?.trim(),
          numberMin: type == ParamType.number ? numberMin : null,
          numberMax: type == ParamType.number ? numberMax : null,
          numberStep: type == ParamType.number ? numberStep : null,
          numberDefault: type == ParamType.number ? numberDefault : null,
          isSystem: false,
          sortOrder: maxOrder + 1,
        ),
      );
      await repo.createParamVisibility(
        BrewParamVisibility(
          id: 0,
          method: method,
          paramId: defId,
          isVisible: true,
        ),
      );
      ref.invalidate(brewParamCatalogProvider);
      await load();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to add parameter: $e');
    }
  }

  Future<void> deleteCustomParam(BrewMethod method, int paramId) async {
    final defs = state.paramDefinitions[method] ?? const [];
    BrewParamDefinition? def;
    for (final candidate in defs) {
      if (candidate.id == paramId) {
        def = candidate;
        break;
      }
    }
    if (def == null) {
      state = state.copyWith(errorMessage: 'Parameter not found.');
      return;
    }
    if (def.isSystem) {
      state = state.copyWith(
        errorMessage: 'System parameters cannot be deleted.',
      );
      return;
    }

    try {
      await ref
          .read(brewParamRepositoryProvider)
          .deleteParamDefinition(paramId);
      ref.invalidate(brewParamCatalogProvider);
      await load();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete parameter: $e');
    }
  }

  void clearError() => state = state.copyWith(errorMessage: null);

  Future<void> _ensureCustomParamDefaults(BrewParamRepository repo) async {
    final existing = await repo.getParamDefinitions(BrewMethod.custom);
    if (existing.isNotEmpty) return;

    final templates = BrewParamDefaults.paramTemplates
        .where((template) => template.method == BrewMethod.custom)
        .toList();
    if (templates.isEmpty) return;

    for (final template in templates) {
      final defId = await repo.createParamDefinition(
        BrewParamDefinition(
          id: 0,
          method: BrewMethod.custom,
          paramKey: template.paramKey,
          name: template.name,
          type: template.type,
          unit: template.unit,
          numberMin: template.numberMin,
          numberMax: template.numberMax,
          numberStep: template.numberStep,
          numberDefault: template.numberDefault,
          isSystem: template.isSystem,
          sortOrder: template.sortOrder,
        ),
      );
      await repo.createParamVisibility(
        BrewParamVisibility(
          id: 0,
          method: BrewMethod.custom,
          paramId: defId,
          isVisible: template.isVisible,
        ),
      );
    }
  }
}

final brewPreferencesControllerProvider =
    NotifierProvider<BrewPreferencesController, BrewPreferencesState>(
      BrewPreferencesController.new,
    );
