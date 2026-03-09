import '../entities/equipment.dart';
import '../repositories/inventory_repository.dart';

/// Use Case: update grinder metadata and click-range configuration.
class UpdateGrinder {
  const UpdateGrinder(this._repository);

  final InventoryRepository _repository;

  Future<bool> call(Equipment grinder) {
    return _repository.updateGrinder(grinder);
  }
}
