import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bean.dart';
import '../../domain/entities/equipment.dart';
import '../../domain/inventory_exceptions.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../../history/presentation/controllers/brew_detail_controller.dart';
import '../../../history/presentation/controllers/history_controller.dart';
import '../../domain/usecases/create_bean.dart';
import '../../domain/usecases/create_equipment.dart';
import '../../domain/usecases/delete_grinder_with_guard.dart';
import '../../domain/usecases/get_suggestions.dart';
import '../../domain/usecases/rename_bean_and_propagate.dart';
import '../../domain/usecases/update_grinder.dart';
import '../../inventory_providers.dart';

final getSuggestionsProvider = Provider<GetSuggestions>((ref) {
  return GetSuggestions(ref.watch(inventoryRepositoryProvider));
});

final createBeanProvider = Provider<CreateBean>((ref) {
  return CreateBean(ref.watch(inventoryRepositoryProvider));
});

final createEquipmentProvider = Provider<CreateEquipment>((ref) {
  return CreateEquipment(ref.watch(inventoryRepositoryProvider));
});

final renameBeanAndPropagateProvider = Provider<RenameBeanAndPropagate>((ref) {
  return RenameBeanAndPropagate(ref.watch(inventoryRepositoryProvider));
});

final updateGrinderProvider = Provider<UpdateGrinder>((ref) {
  return UpdateGrinder(ref.watch(inventoryRepositoryProvider));
});

final deleteGrinderWithGuardProvider = Provider<DeleteGrinderWithGuard>((ref) {
  return DeleteGrinderWithGuard(ref.watch(inventoryRepositoryProvider));
});

class InventoryController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is just empty
  }

  Future<List<Bean>> getBeanSuggestions(String query) {
    return ref.read(getSuggestionsProvider).beans(query);
  }

  Future<List<Equipment>> getEquipmentSuggestions(String query) {
    return ref.read(getSuggestionsProvider).equipments(query);
  }

  Future<List<Bean>> queryBeans(String query) {
    final repository = ref.read(inventoryRepositoryProvider);
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return repository.getAllBeans();
    }
    return repository.searchBeans(normalized);
  }

  Future<List<Equipment>> queryGrinders(String query) {
    final repository = ref.read(inventoryRepositoryProvider);
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return repository.getAllGrinders();
    }
    return repository.searchGrinders(normalized);
  }

  Future<int> addBean(String name) async {
    return _runMutation(() async {
      final bean = Bean(
        id: 0,
        name: name,
        addedAt: DateTime.now(),
        useCount: 0,
      );
      return ref.read(createBeanProvider).call(bean);
    });
  }

  Future<int> addEquipment(
    String name, {
    bool isGrinder = false,
    double? grindMinClick,
    double? grindMaxClick,
    double? grindClickStep,
    String? grindClickUnit,
  }) async {
    return _runMutation(() async {
      final equip = Equipment(
        id: 0,
        name: name,
        isGrinder: isGrinder,
        grindMinClick: isGrinder ? grindMinClick : null,
        grindMaxClick: isGrinder ? grindMaxClick : null,
        grindClickStep: isGrinder ? grindClickStep : null,
        grindClickUnit: isGrinder ? grindClickUnit : null,
        addedAt: DateTime.now(),
        useCount: 0,
      );
      return ref.read(createEquipmentProvider).call(equip);
    });
  }

  Future<void> saveBean({
    Bean? initial,
    required String name,
    String? roaster,
    String? origin,
    String? roastLevel,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw const InventoryValidationException('validation.bean_name_empty');
    }

    await _runMutation(() async {
      final repository = ref.read(inventoryRepositoryProvider);
      if (initial == null) {
        await ref
            .read(createBeanProvider)
            .call(
              Bean(
                id: 0,
                name: normalizedName,
                roaster: roaster,
                origin: origin,
                roastLevel: roastLevel,
                addedAt: DateTime.now(),
                useCount: 0,
              ),
            );
        return;
      }

      final renamed =
          initial.name.trim().toLowerCase() != normalizedName.toLowerCase();
      if (renamed) {
        await ref
            .read(renameBeanAndPropagateProvider)
            .call(beanId: initial.id, newName: normalizedName);
      }

      await repository.updateBean(
        initial.copyWith(
          name: normalizedName,
          roaster: roaster,
          origin: origin,
          roastLevel: roastLevel,
        ),
      );
    });
    ref.invalidate(historyControllerProvider);
    ref.invalidate(brewDetailControllerProvider);
  }

  Future<void> deleteBean(int beanId) async {
    await _runMutation(() async {
      await ref.read(inventoryRepositoryProvider).deleteBean(beanId);
    });
    ref.invalidate(historyControllerProvider);
    ref.invalidate(brewDetailControllerProvider);
  }

  Future<void> saveGrinder({
    Equipment? initial,
    required String name,
    required double minClick,
    required double maxClick,
    required double clickStep,
    required String clickUnit,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw const InventoryValidationException('validation.grinder_name_empty');
    }

    await _runMutation(() async {
      final repository = ref.read(inventoryRepositoryProvider);
      await _ensureGrinderNameNotConflict(
        repository: repository,
        name: normalizedName,
        editingId: initial?.id,
      );

      if (initial == null) {
        await ref
            .read(createEquipmentProvider)
            .call(
              Equipment(
                id: 0,
                name: normalizedName,
                category: 'grinder',
                isGrinder: true,
                grindMinClick: minClick,
                grindMaxClick: maxClick,
                grindClickStep: clickStep,
                grindClickUnit: clickUnit,
                addedAt: DateTime.now(),
                useCount: 0,
              ),
            );
        return;
      }

      await ref
          .read(updateGrinderProvider)
          .call(
            initial.copyWith(
              name: normalizedName,
              category: 'grinder',
              isGrinder: true,
              grindMinClick: minClick,
              grindMaxClick: maxClick,
              grindClickStep: clickStep,
              grindClickUnit: clickUnit,
            ),
          );
    });
  }

  Future<void> deleteGrinder(int grinderId) async {
    await _runMutation(() async {
      await ref.read(deleteGrinderWithGuardProvider).call(grinderId);
    });
  }

  Future<void> _ensureGrinderNameNotConflict({
    required String name,
    required int? editingId,
    required InventoryRepository repository,
  }) async {
    final candidates = await repository.searchGrinders(name);
    final normalized = name.trim().toLowerCase();
    for (final candidate in candidates) {
      if (candidate.name.trim().toLowerCase() != normalized) continue;
      if (editingId != null && candidate.id == editingId) continue;
      throw const InventoryConflictException('conflict.grinder_name_exists');
    }
  }

  Future<T> _runMutation<T>(Future<T> Function() action) async {
    state = const AsyncValue.loading();
    try {
      final result = await action();
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final inventoryControllerProvider =
    AsyncNotifierProvider<InventoryController, void>(InventoryController.new);
