import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/inventory_local_datasource.dart';
import 'data/repositories/inventory_repository_impl.dart';
import 'domain/repositories/inventory_repository.dart';

/// Composition-root provider for selecting [InventoryRepository] implementation.
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl(ref.watch(inventoryLocalDatasourceProvider));
});
