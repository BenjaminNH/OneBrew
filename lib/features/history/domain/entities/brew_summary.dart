import 'package:freezed_annotation/freezed_annotation.dart';

part 'brew_summary.freezed.dart';

/// Aggregated view entity combining a brew record with its optional rating.
///
/// Used by the History feature to display the brew data wall without
/// requiring two separate lookups per list item.
///
/// Ref: docs/01_Architecture.md § 3.2 — History feature entities
@freezed
abstract class BrewSummary with _$BrewSummary {
  const factory BrewSummary({
    /// The brew record's unique identifier.
    required int id,

    /// Timestamp of the brew session.
    required DateTime brewDate,

    /// Name of the coffee bean used.
    required String beanName,

    /// Roaster name (if the bean has one recorded).
    String? roaster,

    /// Total brew duration in seconds.
    required int brewDurationS,

    /// Coffee dose in grams.
    required double coffeeWeightG,

    /// Water weight in grams.
    required double waterWeightG,

    /// Quick score (1–5) from the associated rating, if any.
    int? quickScore,

    /// Emoji label from the associated rating, if any.
    String? emoji,

    /// Whether the brew was created in quick mode.
    required bool isQuickMode,

    /// Free-text notes, if any.
    String? notes,
  }) = _BrewSummary;
}
