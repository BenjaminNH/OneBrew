import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';

/// Pure-Dart Domain entity representing a brew equipment item (e.g. grinder,
/// dripper, kettle).
///
/// When [isGrinder] is `true`, the equipment exposes the optional click-range
/// fields used by the [GrindMode.equipment] flow.
///
/// Ref: docs/01_Architecture.md § 3.2 — Equipment entity / ADR-004
@freezed
abstract class Equipment with _$Equipment {
  const factory Equipment({
    /// Unique identifier.
    required int id,

    /// Equipment name, unique across the inventory (e.g. "Comandante C40").
    required String name,

    /// Category label (optional, e.g. "grinder", "dripper", "kettle").
    String? category,

    /// Whether this equipment is a grinder that exposes click-range config.
    required bool isGrinder,

    /// Minimum grinder click value (e.g. 0). Only relevant when [isGrinder].
    double? grindMinClick,

    /// Maximum grinder click value (e.g. 40). Only relevant when [isGrinder].
    double? grindMaxClick,

    /// Step size between clicks (e.g. 1.0 for full-click, 0.5 for half-click).
    double? grindClickStep,

    /// Unit label for the click display (e.g. "clicks", "格", "数字").
    String? grindClickUnit,

    /// Timestamp when this equipment was first added.
    required DateTime addedAt,

    /// Number of brew records referencing this equipment.
    required int useCount,
  }) = _Equipment;
}
