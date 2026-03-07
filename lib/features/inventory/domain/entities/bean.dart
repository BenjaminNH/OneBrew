import 'package:freezed_annotation/freezed_annotation.dart';

part 'bean.freezed.dart';

/// Pure-Dart Domain entity representing a coffee bean in the inventory.
///
/// Beans are created automatically on first use and tracked by [useCount]
/// for smart autocomplete ordering.
///
/// Ref: docs/01_Architecture.md § 3.2 — Bean entity
@freezed
abstract class Bean with _$Bean {
  const factory Bean({
    /// Unique identifier.
    required int id,

    /// Bean display name, unique across the inventory.
    required String name,

    /// Roaster / producer (optional).
    String? roaster,

    /// Origin / country of origin (optional).
    String? origin,

    /// Roast level label (optional, e.g. "Light", "Medium-Dark").
    String? roastLevel,

    /// Timestamp when this bean was first added to the inventory.
    required DateTime addedAt,

    /// Number of brew records referencing this bean (autocomplete weight).
    required int useCount,
  }) = _Bean;
}
