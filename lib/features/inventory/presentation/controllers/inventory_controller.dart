import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bean.dart';
import '../../domain/entities/equipment.dart';
import '../../domain/usecases/create_bean.dart';
import '../../domain/usecases/create_equipment.dart';
import '../../domain/usecases/get_suggestions.dart';
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

  Future<int> addBean(String name) async {
    state = const AsyncValue.loading();
    try {
      final bean = Bean(
        id: 0,
        name: name,
        addedAt: DateTime.now(),
        useCount: 0,
      );
      final id = await ref.read(createBeanProvider).call(bean);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<int> addEquipment(
    String name, {
    bool isGrinder = false,
    double? grindMinClick,
    double? grindMaxClick,
    double? grindClickStep,
    String? grindClickUnit,
  }) async {
    state = const AsyncValue.loading();
    try {
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
      final id = await ref.read(createEquipmentProvider).call(equip);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final inventoryControllerProvider =
    AsyncNotifierProvider<InventoryController, void>(InventoryController.new);
