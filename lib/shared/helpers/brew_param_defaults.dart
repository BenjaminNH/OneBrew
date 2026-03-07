/// Brew Parameter Default Values
/// Provides sensible starting values for all brew parameters
/// based on standard pour-over / specialty coffee conventions.
///
/// Used by BrewLoggerController and form initialization
/// to pre-fill parameters, reducing friction for new records.
/// Ref: docs/01_Architecture.md § 3.3 — 参数默认值
abstract final class BrewParamDefaults {
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
  // Quick Mode Flag
  // ─────────────────────────────────────────

  /// Whether the app defaults to quick (minimal) mode
  static const bool isQuickMode = true;

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
  static const double minCoffeeWeight = 5.0;

  /// Maximum coffee weight (grams)
  static const double maxCoffeeWeight = 50.0;

  /// Minimum water weight (grams)
  static const double minWaterWeight = 50.0;

  /// Maximum water weight (grams)
  static const double maxWaterWeight = 1000.0;

  /// Minimum water temperature (degrees Celsius)
  static const double minWaterTemp = 60.0;

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
