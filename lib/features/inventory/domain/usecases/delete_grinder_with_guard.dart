import '../repositories/inventory_repository.dart';

/// Use Case: delete a grinder only when there are no historical references.
class DeleteGrinderWithGuard {
  const DeleteGrinderWithGuard(this._repository);

  final InventoryRepository _repository;

  Future<bool> call(int grinderId) async {
    final deleted = await _repository.deleteGrinderWithGuard(grinderId);
    return deleted > 0;
  }
}
