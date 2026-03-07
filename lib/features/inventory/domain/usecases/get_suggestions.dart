import '../entities/bean.dart';
import '../entities/equipment.dart';
import '../repositories/inventory_repository.dart';

/// Use Case: return autocomplete suggestions for beans and equipment.
///
/// Results are ordered by use-count (most-used first) and optionally
/// filtered by a search [query]. An empty query returns all items.
///
/// Ref: docs/05_Development_Plan.md § Phase 2 — inventory use cases
class GetSuggestions {
  const GetSuggestions(this._repository);

  final InventoryRepository _repository;

  /// Returns matching [Bean] suggestions for [query].
  Future<List<Bean>> beans(String query) {
    if (query.isEmpty) return _repository.getAllBeans();
    return _repository.searchBeans(query);
  }

  /// Returns matching [Equipment] suggestions for [query].
  Future<List<Equipment>> equipments(String query) {
    if (query.isEmpty) return _repository.getAllEquipments();
    return _repository.searchEquipments(query);
  }
}
