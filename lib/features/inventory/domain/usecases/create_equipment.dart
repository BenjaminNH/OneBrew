import '../entities/equipment.dart';
import '../repositories/inventory_repository.dart';

/// Use Case: create a new [Equipment] item in the inventory.
///
/// Returns the ID of the newly created equipment row.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — inventory use cases
class CreateEquipment {
  const CreateEquipment(this._repository);

  final InventoryRepository _repository;

  /// Creates [equipment] in the repository.
  Future<int> call(Equipment equipment) =>
      _repository.createEquipment(equipment);
}
