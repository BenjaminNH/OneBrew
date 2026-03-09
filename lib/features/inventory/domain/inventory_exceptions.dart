/// Base exception for inventory domain failures.
class InventoryException implements Exception {
  const InventoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Thrown when an operation violates uniqueness constraints.
class InventoryConflictException extends InventoryException {
  const InventoryConflictException(super.message);
}

/// Thrown when a request has invalid domain data.
class InventoryValidationException extends InventoryException {
  const InventoryValidationException(super.message);
}

/// Thrown when a delete/update is blocked by existing references.
class InventoryReferenceException extends InventoryException {
  const InventoryReferenceException(super.message);
}
