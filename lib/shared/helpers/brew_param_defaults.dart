/// Brew Parameter Default Values
library;

/// Provides sensible starting values for all brew parameters
/// based on standard pour-over / specialty coffee conventions.
///
/// Used by BrewLoggerController and form initialization
/// to pre-fill parameters, reducing friction for new records.
/// Ref: docs/01_Architecture.md § 3.3 — 参数默认值
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';

class BrewMethodConfigSeed {
  const BrewMethodConfigSeed({
    required this.method,
    required this.displayName,
    required this.isEnabled,
  });

  final BrewMethod method;
  final String displayName;
  final bool isEnabled;
}

class BrewParamTemplate {
  const BrewParamTemplate({
    required this.method,
    required this.name,
    required this.type,
    this.unit,
    this.numberMin,
    this.numberMax,
    this.numberStep,
    this.numberDefault,
    this.isSystem = true,
    this.isVisible = true,
    required this.sortOrder,
  });

  final BrewMethod method;
  final String name;
  final ParamType type;
  final String? unit;
  final double? numberMin;
  final double? numberMax;
  final double? numberStep;
  final double? numberDefault;
  final bool isSystem;
  final bool isVisible;
  final int sortOrder;

  BrewParamNumberRange? get numberRange {
    if (type != ParamType.number) return null;
    final min = numberMin;
    final max = numberMax;
    if (min == null || max == null || max <= min) return null;
    return BrewParamNumberRange(
      min: min,
      max: max,
      step: numberStep,
      defaultValue: numberDefault,
    );
  }
}

class BrewTimerTargetProfile {
  const BrewTimerTargetProfile({
    required this.recommendedTargetSeconds,
    required this.recommendedBloomSeconds,
  });

  /// Null means "no countdown target by default" (count-up mode).
  final int? recommendedTargetSeconds;

  /// Recommended bloom/pre-infusion duration in seconds.
  final int recommendedBloomSeconds;
}

abstract final class BrewParamDefaults {
  // ─────────────────────────────────────────
  // Default templates (Phase 7D)
  // ─────────────────────────────────────────

  static const List<BrewMethodConfigSeed> methodConfigSeeds = [
    BrewMethodConfigSeed(
      method: BrewMethod.pourOver,
      displayName: 'Pour Over',
      isEnabled: true,
    ),
    BrewMethodConfigSeed(
      method: BrewMethod.espresso,
      displayName: 'Espresso',
      isEnabled: true,
    ),
    BrewMethodConfigSeed(
      method: BrewMethod.custom,
      displayName: 'Custom',
      isEnabled: false,
    ),
  ];

  static const List<BrewParamTemplate> paramTemplates = [
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Coffee Weight',
      type: ParamType.number,
      unit: 'g',
      numberMin: 8.0,
      numberMax: 40.0,
      numberStep: 0.1,
      numberDefault: 15.0,
      sortOrder: 1,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Water Weight',
      type: ParamType.number,
      unit: 'g',
      numberMin: 120.0,
      numberMax: 700.0,
      numberStep: 1.0,
      numberDefault: 225.0,
      sortOrder: 2,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Brew Ratio',
      type: ParamType.number,
      numberMin: 10.0,
      numberMax: 22.0,
      numberStep: 0.1,
      numberDefault: 15.0,
      sortOrder: 3,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Water Temp',
      type: ParamType.number,
      unit: 'C',
      numberMin: 80.0,
      numberMax: 100.0,
      numberStep: 1.0,
      numberDefault: 93.0,
      sortOrder: 4,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Grind Size',
      type: ParamType.text,
      sortOrder: 5,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Brew Time',
      type: ParamType.number,
      unit: 's',
      numberMin: 30.0,
      numberMax: 480.0,
      numberStep: 1.0,
      numberDefault: 180.0,
      sortOrder: 6,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Bloom Time',
      type: ParamType.number,
      unit: 's',
      numberMin: 0.0,
      numberMax: 90.0,
      numberStep: 1.0,
      numberDefault: 30.0,
      sortOrder: 7,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Bloom Water',
      type: ParamType.number,
      unit: 'g',
      numberMin: 0.0,
      numberMax: 200.0,
      numberStep: 1.0,
      numberDefault: 30.0,
      sortOrder: 8,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Pour Method',
      type: ParamType.text,
      sortOrder: 9,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Agitation',
      type: ParamType.text,
      sortOrder: 10,
    ),
    BrewParamTemplate(
      method: BrewMethod.pourOver,
      name: 'Filter/Dripper',
      type: ParamType.text,
      sortOrder: 11,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Coffee Dose',
      type: ParamType.number,
      unit: 'g',
      numberMin: 12.0,
      numberMax: 24.0,
      numberStep: 0.1,
      numberDefault: 18.0,
      sortOrder: 1,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Yield',
      type: ParamType.number,
      unit: 'g',
      numberMin: 18.0,
      numberMax: 60.0,
      numberStep: 0.5,
      numberDefault: 36.0,
      sortOrder: 2,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Brew Ratio',
      type: ParamType.number,
      numberMin: 1.0,
      numberMax: 4.0,
      numberStep: 0.1,
      numberDefault: 2.0,
      sortOrder: 3,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Extraction Time',
      type: ParamType.number,
      unit: 's',
      numberMin: 15.0,
      numberMax: 45.0,
      numberStep: 1.0,
      numberDefault: 30.0,
      sortOrder: 4,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Pressure',
      type: ParamType.number,
      unit: 'bar',
      numberMin: 6.0,
      numberMax: 11.0,
      numberStep: 0.1,
      numberDefault: 9.0,
      sortOrder: 5,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Water Temp',
      type: ParamType.number,
      unit: 'C',
      numberMin: 85.0,
      numberMax: 98.0,
      numberStep: 1.0,
      numberDefault: 93.0,
      sortOrder: 6,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Pre-infusion Time',
      type: ParamType.number,
      unit: 's',
      numberMin: 0.0,
      numberMax: 20.0,
      numberStep: 1.0,
      numberDefault: 8.0,
      sortOrder: 7,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Grind Size',
      type: ParamType.text,
      sortOrder: 8,
    ),
    BrewParamTemplate(
      method: BrewMethod.espresso,
      name: 'Distribution/Tamping',
      type: ParamType.text,
      sortOrder: 9,
    ),
    BrewParamTemplate(
      method: BrewMethod.custom,
      name: 'Coffee Weight',
      type: ParamType.number,
      unit: 'g',
      numberMin: 8.0,
      numberMax: 40.0,
      numberStep: 0.1,
      numberDefault: 15.0,
      sortOrder: 1,
    ),
    BrewParamTemplate(
      method: BrewMethod.custom,
      name: 'Water Weight',
      type: ParamType.number,
      unit: 'g',
      numberMin: 120.0,
      numberMax: 700.0,
      numberStep: 1.0,
      numberDefault: 225.0,
      sortOrder: 2,
    ),
    BrewParamTemplate(
      method: BrewMethod.custom,
      name: 'Brew Ratio',
      type: ParamType.number,
      numberMin: 8.0,
      numberMax: 24.0,
      numberStep: 0.1,
      numberDefault: 15.0,
      sortOrder: 3,
    ),
  ];

  static BrewParamTemplate? templateFor({
    required BrewMethod method,
    required String name,
  }) {
    for (final template in paramTemplates) {
      if (template.method == method && template.name == name) return template;
    }
    return null;
  }

  static BrewParamNumberRange? numberRangeFor({
    required BrewMethod method,
    required String name,
  }) {
    return templateFor(method: method, name: name)?.numberRange;
  }
  // ─────────────────────────────────────────
  // Essential Parameters (always shown)
  // ─────────────────────────────────────────

  /// Default coffee dose in grams
  static const double coffeeWeightG = 15.0;

  /// Default water-to-coffee ratio (1:15)
  static const double waterToCoffeeRatio = 15.0;

  /// Default water amount in grams (coffeeWeight × ratio)
  static const double waterWeightG = coffeeWeightG * waterToCoffeeRatio; // 225g

  /// Default water temperature in Celsius (specialty standard)
  static const double waterTempC = 93.0;

  /// Default total brew duration in seconds (~3 minutes)
  static const int brewDurationS = 180;

  /// Default bloom time in seconds
  static const int bloomTimeS = 30;

  /// Method-specific timer target strategy.
  ///
  /// - Pour over: classic 3:00 target and 30s bloom.
  /// - Espresso: short extraction target.
  /// - Custom: no enforced countdown target.
  static const BrewTimerTargetProfile pourOverTimerProfile =
      BrewTimerTargetProfile(
        recommendedTargetSeconds: 180,
        recommendedBloomSeconds: 30,
      );
  static const BrewTimerTargetProfile espressoTimerProfile =
      BrewTimerTargetProfile(
        recommendedTargetSeconds: 30,
        recommendedBloomSeconds: 8,
      );
  static const BrewTimerTargetProfile customTimerProfile =
      BrewTimerTargetProfile(
        recommendedTargetSeconds: null,
        recommendedBloomSeconds: 0,
      );

  static BrewTimerTargetProfile timerProfileForMethod(BrewMethod method) {
    switch (method) {
      case BrewMethod.pourOver:
        return pourOverTimerProfile;
      case BrewMethod.espresso:
        return espressoTimerProfile;
      case BrewMethod.custom:
        return customTimerProfile;
    }
  }

  /// Clamps target to supported brew duration boundaries.
  static int clampTargetSeconds(int targetSeconds) {
    return targetSeconds.clamp(minBrewDuration, maxBrewDuration).toInt();
  }

  /// Clamps bloom duration and keeps it <= target when target exists.
  static int clampBloomSeconds({
    required int bloomSeconds,
    int? targetSeconds,
  }) {
    final lowerBounded = bloomSeconds.clamp(0, maxBrewDuration).toInt();
    if (targetSeconds == null) return lowerBounded.toInt();
    final normalizedTarget = clampTargetSeconds(targetSeconds);
    return lowerBounded.clamp(0, normalizedTarget).toInt();
  }

  // ─────────────────────────────────────────
  // Grind Mode Defaults
  // ─────────────────────────────────────────

  /// Default grind mode identifier
  /// 'equipment' | 'simple' | 'pro'
  static const String grindMode = 'equipment';

  /// Default simple grind label (7-point scale)
  static const String grindSimpleDefault = 'Medium';

  /// All simple grind labels in order from finest to coarsest
  static const List<String> grindSimpleLabels = [
    'Extra Fine', // 极细
    'Fine', // 较细
    'Medium Fine', // 中细
    'Medium', // 中
    'Medium Coarse', // 中粗
    'Coarse', // 较粗
    'Extra Coarse', // 极粗
  ];

  /// Default grind microns value (pro mode)
  /// 400–800 μm covers most pour-over use cases
  static const int grindMicrons = 600;

  // ─────────────────────────────────────────
  // Advanced Parameters (collapsed by default)
  // ─────────────────────────────────────────

  /// Default pour method
  static const String pourMethod = 'Spiral';

  /// Common pour method options
  static const List<String> pourMethodOptions = [
    'Center',
    'Spiral',
    'Pulse',
    'Single',
    'Custom',
  ];

  /// Default water type
  static const String waterType = 'Filtered';

  /// Common water type options
  static const List<String> waterTypeOptions = [
    'Tap',
    'Filtered',
    'Bottled',
    'Mineral',
    'RO',
  ];

  /// Default room temperature in Celsius
  static const double roomTempC = 22.0;

  // ─────────────────────────────────────────
  // Equipment Defaults
  // ─────────────────────────────────────────

  /// Default grinder min click
  static const double grinderMinClick = 0.0;

  /// Default grinder max click
  static const double grinderMaxClick = 40.0;

  /// Default grinder click step
  static const double grinderClickStep = 1.0;

  /// Default grinder click unit label
  static const String grinderClickUnit = 'clicks';

  // ─────────────────────────────────────────
  // Rating Defaults
  // ─────────────────────────────────────────

  /// Default quick score (unrated)
  static const int? quickScore = null;

  /// Default professional dimension: acidity (0-5 scale)
  static const double acidityDefault = 2.5;

  /// Default professional dimension: sweetness
  static const double sweetnessDefault = 2.5;

  /// Default professional dimension: bitterness
  static const double bitternessDefault = 1.5;

  /// Default professional dimension: body
  static const double bodyDefault = 2.5;

  // ─────────────────────────────────────────
  // Limits & Validation Ranges
  // ─────────────────────────────────────────

  /// Minimum coffee weight (grams)
  static const double minCoffeeWeight = 8.0;

  /// Maximum coffee weight (grams)
  static const double maxCoffeeWeight = 40.0;

  /// Minimum water weight (grams)
  static const double minWaterWeight = 120.0;

  /// Maximum water weight (grams)
  static const double maxWaterWeight = 700.0;

  /// Minimum water temperature (degrees Celsius)
  static const double minWaterTemp = 80.0;

  /// Maximum water temperature (degrees Celsius)
  static const double maxWaterTemp = 100.0;

  /// Minimum brew duration (seconds)
  static const int minBrewDuration = 30;

  /// Maximum brew duration (seconds) — 10 minutes
  static const int maxBrewDuration = 600;

  /// Quick score valid range
  static const int minQuickScore = 1;
  static const int maxQuickScore = 5;

  // ─────────────────────────────────────────
  // Helper: Compute Water Weight from Ratio
  // ─────────────────────────────────────────

  /// Calculates water weight given coffee weight and ratio.
  /// e.g. water = 15g coffee × 15 ratio = 225g water
  static double computeWaterWeight(double coffeeGrams, double ratio) {
    return (coffeeGrams * ratio).clamp(minWaterWeight, maxWaterWeight);
  }

  /// Calculates the water-to-coffee ratio from actual weights.
  static double computeRatio(double coffeeGrams, double waterGrams) {
    if (coffeeGrams <= 0) return waterToCoffeeRatio;
    return waterGrams / coffeeGrams;
  }

  /// Suggested bloom water (typically 2× coffee weight)
  static double suggestedBloomWater(double coffeeGrams) => coffeeGrams * 2.0;
}
