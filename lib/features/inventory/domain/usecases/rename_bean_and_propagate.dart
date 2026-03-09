import '../repositories/inventory_repository.dart';

/// Use Case: rename a bean and propagate the renamed value to historical
/// brew records in one transactional operation.
class RenameBeanAndPropagate {
  const RenameBeanAndPropagate(this._repository);

  final InventoryRepository _repository;

  Future<bool> call({required int beanId, required String newName}) {
    return _repository.renameBeanAndPropagate(beanId: beanId, newName: newName);
  }
}
