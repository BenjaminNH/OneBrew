import '../entities/bean.dart';
import '../repositories/inventory_repository.dart';

/// Use Case: create a new [Bean] in the inventory.
///
/// If the bean name already exists the repository implementation should
/// return the existing bean's ID without creating a duplicate.
///
/// Returns the ID of the created (or existing) bean.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — inventory use cases
class CreateBean {
  const CreateBean(this._repository);

  final InventoryRepository _repository;

  /// Creates [bean] in the repository.
  Future<int> call(Bean bean) => _repository.createBean(bean);
}
