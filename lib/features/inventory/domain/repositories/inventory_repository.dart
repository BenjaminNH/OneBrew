import '../entities/bean.dart';
import '../entities/equipment.dart';

/// Abstract Repository interface for inventory (Bean + Equipment) persistence.
///
/// Ref: docs/01_Architecture.md § 4.1 — Repository pattern
abstract interface class InventoryRepository {
  // ─── Bean operations ────────────────────────────────────────────────────

  /// Returns all beans ordered by [Bean.useCount] descending.
  Future<List<Bean>> getAllBeans();

  /// Returns beans whose name fuzzy-matches [query], ordered by use count.
  Future<List<Bean>> searchBeans(String query);

  /// Persists a new bean and returns its assigned ID.
  Future<int> createBean(Bean bean);

  /// Updates an existing bean. Returns `true` if a row was changed.
  Future<bool> updateBean(Bean bean);

  /// Deletes a bean by [id]. Returns the number of deleted rows.
  Future<int> deleteBean(int id);

  /// Increments [Bean.useCount] for the bean with [id].
  Future<void> incrementBeanUseCount(int id);

  // ─── Equipment operations ───────────────────────────────────────────────

  /// Returns all equipment ordered by [Equipment.useCount] descending.
  Future<List<Equipment>> getAllEquipments();

  /// Returns equipment whose name fuzzy-matches [query], ordered by use count.
  Future<List<Equipment>> searchEquipments(String query);

  /// Returns grinders only (`isGrinder == true`) ordered by use count.
  Future<List<Equipment>> getAllGrinders();

  /// Returns grinders whose name fuzzy-matches [query].
  Future<List<Equipment>> searchGrinders(String query);

  /// Persists a new equipment item and returns its assigned ID.
  Future<int> createEquipment(Equipment equipment);

  /// Updates an existing equipment item. Returns `true` if a row was changed.
  Future<bool> updateEquipment(Equipment equipment);

  /// Deletes an equipment item by [id]. Returns the number of deleted rows.
  Future<int> deleteEquipment(int id);

  /// Increments [Equipment.useCount] for the equipment with [id].
  Future<void> incrementEquipmentUseCount(int id);

  /// Renames bean [beanId] and propagates name changes to historical records.
  Future<bool> renameBeanAndPropagate({
    required int beanId,
    required String newName,
  });

  /// Updates grinder settings with domain validation.
  Future<bool> updateGrinder(Equipment grinder);

  /// Deletes grinder [grinderId] and detaches historical references first.
  /// Returns the number of deleted rows.
  Future<int> deleteGrinderWithGuard(int grinderId);
}
