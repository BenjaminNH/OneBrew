import 'package:freezed_annotation/freezed_annotation.dart';

import 'brew_method.dart';

export 'brew_method.dart';

part 'brew_record.freezed.dart';

/// Grind mode determines which grind-degree field is populated.
///
/// - [equipment]: user selected a grinder equipment and entered a click value.
/// - [simple]: user picked a coarse label (e.g. "medium-fine").
/// - [pro]: user entered a precise particle-size value in microns (μm).
///
/// Ref: docs/01_Architecture.md § ADR-004
enum GrindMode { equipment, simple, pro }

/// Pure-Dart Domain entity for a single brew session.
///
/// This class lives in the Domain layer and must NOT import Flutter, Drift,
/// or any infrastructure dependency.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewRecord entity
@freezed
abstract class BrewRecord with _$BrewRecord {
  const factory BrewRecord({
    /// Unique identifier (matches the Drift table PK).
    required int id,

    /// Timestamp of the brew session.
    required DateTime brewDate,

    /// Name of the coffee bean used (FK to Bean.name).
    required String beanName,

    /// Optional FK to equipment (grinder) used.
    int? equipmentId,

    /// Brew method classification for this record.
    required BrewMethod brewMethod,

    /// Which grind-mode was used for this brew.
    required GrindMode grindMode,

    /// Grinder click value when [grindMode] == [GrindMode.equipment].
    double? grindClickValue,

    /// Coarse label when [grindMode] == [GrindMode.simple].
    /// e.g. "medium-fine", "coarse".
    String? grindSimpleLabel,

    /// Particle size (μm) when [grindMode] == [GrindMode.pro].
    int? grindMicrons,

    /// Coffee dose in grams.
    required double coffeeWeightG,

    /// Water weight in grams.
    required double waterWeightG,

    /// Water temperature in °C (optional).
    double? waterTempC,

    /// Total brew duration in seconds.
    required int brewDurationS,

    /// Bloom (pre-infusion) time in seconds (optional).
    int? bloomTimeS,

    /// Pour method description (optional).
    String? pourMethod,

    /// Water type / source description (optional).
    String? waterType,

    /// Room temperature in °C (optional).
    double? roomTempC,

    /// Free-text notes (optional).
    String? notes,

    /// Record creation timestamp.
    required DateTime createdAt,

    /// Record last-update timestamp.
    required DateTime updatedAt,
  }) = _BrewRecord;
}
