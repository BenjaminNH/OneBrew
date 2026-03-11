import 'package:freezed_annotation/freezed_annotation.dart';

import 'brew_method.dart';

part 'brew_param_visibility.freezed.dart';

/// Domain entity for parameter visibility configuration.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewParamVisibility
@freezed
abstract class BrewParamVisibility with _$BrewParamVisibility {
  const factory BrewParamVisibility({
    required int id,
    required BrewMethod method,
    required int paramId,
    required bool isVisible,
  }) = _BrewParamVisibility;
}
