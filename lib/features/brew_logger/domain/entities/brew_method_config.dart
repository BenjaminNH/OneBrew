import 'package:freezed_annotation/freezed_annotation.dart';

import 'brew_method.dart';

part 'brew_method_config.freezed.dart';

/// Domain entity representing a brew method configuration.
///
/// Ref: docs/01_Architecture.md § 3.2 — BrewMethodConfig
@freezed
abstract class BrewMethodConfig with _$BrewMethodConfig {
  const factory BrewMethodConfig({
    required int id,
    required BrewMethod method,
    required String displayName,
    required bool isEnabled,
  }) = _BrewMethodConfig;
}
