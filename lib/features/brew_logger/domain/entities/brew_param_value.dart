import 'package:freezed_annotation/freezed_annotation.dart';

part 'brew_param_value.freezed.dart';

/// Domain entity for a recorded parameter value tied to a brew record.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewParamValue
@freezed
abstract class BrewParamValue with _$BrewParamValue {
  const factory BrewParamValue({
    required int id,
    required int brewRecordId,
    required int paramId,
    double? valueNumber,
    String? valueText,
  }) = _BrewParamValue;
}
