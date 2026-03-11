import 'package:freezed_annotation/freezed_annotation.dart';

import 'brew_method.dart';

part 'brew_param_definition.freezed.dart';

/// Domain entity for a parameter definition belonging to a brew method.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewParamDefinition
@freezed
abstract class BrewParamDefinition with _$BrewParamDefinition {
  const factory BrewParamDefinition({
    required int id,
    required BrewMethod method,
    required String name,
    required ParamType type,
    String? unit,
    required bool isSystem,
    required int sortOrder,
  }) = _BrewParamDefinition;
}
