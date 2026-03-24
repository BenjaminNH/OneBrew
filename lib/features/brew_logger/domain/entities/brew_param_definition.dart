import 'dart:math' as math;

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
    String? paramKey,
    required String name,
    required ParamType type,
    String? unit,
    double? numberMin,
    double? numberMax,
    double? numberStep,
    double? numberDefault,
    required bool isSystem,
    required int sortOrder,
  }) = _BrewParamDefinition;
}

class BrewParamNumberRange {
  const BrewParamNumberRange({
    required this.min,
    required this.max,
    this.step,
    this.defaultValue,
  }) : assert(max > min, 'max must be greater than min');

  final double min;
  final double max;
  final double? step;
  final double? defaultValue;

  bool get hasStep => step != null && step! > 0;

  int get fractionDigits {
    final activeStep = step;
    if (activeStep == null || activeStep <= 0) return 1;
    final fixed = activeStep.toStringAsFixed(4);
    final fraction = fixed.split('.').last.replaceAll(RegExp(r'0+$'), '');
    return fraction.isEmpty ? 0 : fraction.length;
  }

  int? get sliderDivisions {
    final activeStep = step;
    if (activeStep == null || activeStep <= 0) return null;
    final raw = (max - min) / activeStep;
    if (!raw.isFinite) return null;
    final rounded = raw.round();
    if (rounded <= 0 || rounded > 2000) return null;
    return rounded;
  }

  bool contains(double value) => value >= min && value <= max;

  double normalize(double value) {
    final bounded = value.clamp(min, max).toDouble();
    if (!hasStep) return _roundByFractionDigits(bounded, fractionDigits);

    final activeStep = step!;
    final steps = ((bounded - min) / activeStep).round();
    final snapped = min + (steps * activeStep);
    final normalized = snapped.clamp(min, max).toDouble();
    return _roundByFractionDigits(normalized, fractionDigits);
  }

  String format(double value) {
    final normalized = normalize(value);
    return normalized.toStringAsFixed(fractionDigits);
  }

  String boundsLabel({String? unit}) {
    final suffix = unit == null || unit.isEmpty ? '' : ' $unit';
    final stepLabel = hasStep
        ? ' • step ${step!.toStringAsFixed(fractionDigits)}'
        : '';
    return 'Range ${min.toStringAsFixed(fractionDigits)}-${max.toStringAsFixed(fractionDigits)}$suffix$stepLabel';
  }

  double initialValue(double? currentValue) {
    if (currentValue != null) return normalize(currentValue);
    if (defaultValue != null) return normalize(defaultValue!);
    return min;
  }

  double _roundByFractionDigits(double value, int digits) {
    final safeDigits = math.max(0, math.min(digits, 4));
    return double.parse(value.toStringAsFixed(safeDigits));
  }
}

extension BrewParamDefinitionNumberRangeX on BrewParamDefinition {
  BrewParamNumberRange? get numberRange {
    if (type != ParamType.number) return null;

    final min = numberMin;
    final max = numberMax;
    if (min == null || max == null || max <= min) return null;

    final safeStep = numberStep != null && numberStep! > 0 ? numberStep : null;
    return BrewParamNumberRange(
      min: min,
      max: max,
      step: safeStep,
      defaultValue: numberDefault,
    );
  }
}
