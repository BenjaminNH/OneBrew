import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../brew_logger/domain/entities/brew_record.dart';

part 'brew_detail.freezed.dart';

/// Full-detail aggregate for a single brew record.
///
/// Combines brew record, bean metadata, equipment metadata, and optional
/// rating into one read model for the History detail page.
@freezed
abstract class BrewDetail with _$BrewDetail {
  const factory BrewDetail({
    required int id,
    required DateTime brewDate,
    required String beanName,
    String? roaster,
    String? origin,
    String? roastLevel,
    int? equipmentId,
    String? equipmentName,
    required GrindMode grindMode,
    double? grindClickValue,
    String? grindClickUnit,
    String? grindSimpleLabel,
    int? grindMicrons,
    required double coffeeWeightG,
    required double waterWeightG,
    double? waterTempC,
    required int brewDurationS,
    int? bloomTimeS,
    String? pourMethod,
    String? waterType,
    double? roomTempC,
    int? quickScore,
    String? emoji,
    double? acidity,
    double? sweetness,
    double? bitterness,
    double? body,
    String? flavorNotes,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BrewDetail;
}
