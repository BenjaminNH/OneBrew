import 'package:one_coffee/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_coffee/features/history/domain/entities/brew_summary.dart';
import 'package:one_coffee/features/history/domain/entities/brew_detail.dart';
import 'package:one_coffee/features/inventory/domain/entities/bean.dart';
import 'package:one_coffee/features/inventory/domain/entities/equipment.dart';
import 'package:one_coffee/features/rating/domain/entities/brew_rating.dart';

/// Factory helpers that produce canonical test data for Domain layer tests.
///
/// Each method returns a valid entity with deterministic field values so that
/// test assertions are easy to write and stable across refactors.
///
/// Usage:
/// ```dart
/// final bean = TestFixtures.bean();
/// final record = TestFixtures.brewRecord(id: 42);
/// ```
class TestFixtures {
  TestFixtures._();

  // ─── Bean ────────────────────────────────────────────────────────────────

  static final _baseDate = DateTime(2024, 1, 1, 8, 0);

  /// Returns a [Bean] with sensible defaults.
  static Bean bean({
    int id = 1,
    String name = 'Ethiopia Yirgacheffe',
    String? roaster = 'Sample Roasters',
    String? origin = 'Ethiopia',
    String? roastLevel = 'Light',
    int useCount = 3,
  }) => Bean(
    id: id,
    name: name,
    roaster: roaster,
    origin: origin,
    roastLevel: roastLevel,
    addedAt: _baseDate,
    useCount: useCount,
  );

  // ─── Equipment ───────────────────────────────────────────────────────────

  /// Returns an [Equipment] representing a grinder with click-range.
  static Equipment grinder({
    int id = 1,
    String name = 'Comandante C40',
    double grindMinClick = 0,
    double grindMaxClick = 40,
    double grindClickStep = 1,
    String grindClickUnit = 'clicks',
    int useCount = 2,
  }) => Equipment(
    id: id,
    name: name,
    category: 'grinder',
    isGrinder: true,
    grindMinClick: grindMinClick,
    grindMaxClick: grindMaxClick,
    grindClickStep: grindClickStep,
    grindClickUnit: grindClickUnit,
    addedAt: _baseDate,
    useCount: useCount,
  );

  /// Returns a non-grinder [Equipment] (e.g. a dripper).
  static Equipment dripper({
    int id = 2,
    String name = 'V60 02',
    int useCount = 5,
  }) => Equipment(
    id: id,
    name: name,
    category: 'dripper',
    isGrinder: false,
    addedAt: _baseDate,
    useCount: useCount,
  );

  // ─── BrewRecord ──────────────────────────────────────────────────────────

  /// Returns a [BrewRecord] in quick mode using equipment grind.
  static BrewRecord brewRecord({
    int id = 1,
    String beanName = 'Ethiopia Yirgacheffe',
    int? equipmentId = 1,
    GrindMode grindMode = GrindMode.equipment,
    double? grindClickValue = 24.0,
    double coffeeWeightG = 15.0,
    double waterWeightG = 250.0,
    int brewDurationS = 180,
    bool isQuickMode = true,
  }) {
    final now = _baseDate;
    return BrewRecord(
      id: id,
      brewDate: now,
      beanName: beanName,
      equipmentId: equipmentId,
      grindMode: grindMode,
      grindClickValue: grindClickValue,
      coffeeWeightG: coffeeWeightG,
      waterWeightG: waterWeightG,
      brewDurationS: brewDurationS,
      isQuickMode: isQuickMode,
      createdAt: now,
      updatedAt: now,
    );
  }

  // ─── BrewRating ──────────────────────────────────────────────────────────

  /// Returns a quick [BrewRating] (score + emoji only).
  static BrewRating quickRating({
    int id = 1,
    int brewRecordId = 1,
    int quickScore = 4,
    String emoji = '😊',
  }) => BrewRating(
    id: id,
    brewRecordId: brewRecordId,
    quickScore: quickScore,
    emoji: emoji,
  );

  /// Returns a professional [BrewRating] with all sliders set.
  static BrewRating proRating({
    int id = 2,
    int brewRecordId = 1,
    double acidity = 7.0,
    double sweetness = 6.5,
    double bitterness = 3.0,
    double body = 5.0,
    String flavorNotes = 'jasmine,citrus',
  }) => BrewRating(
    id: id,
    brewRecordId: brewRecordId,
    acidity: acidity,
    sweetness: sweetness,
    bitterness: bitterness,
    body: body,
    flavorNotes: flavorNotes,
  );

  // ─── BrewSummary ─────────────────────────────────────────────────────────

  /// Returns a [BrewSummary] derived from the default brew + quick rating.
  static BrewSummary brewSummary({
    int id = 1,
    String beanName = 'Ethiopia Yirgacheffe',
    String? roaster = 'Sample Roasters',
    int brewDurationS = 180,
    double coffeeWeightG = 15.0,
    double waterWeightG = 250.0,
    int? quickScore = 4,
    String? emoji = '😊',
    bool isQuickMode = true,
  }) => BrewSummary(
    id: id,
    brewDate: _baseDate,
    beanName: beanName,
    roaster: roaster,
    brewDurationS: brewDurationS,
    coffeeWeightG: coffeeWeightG,
    waterWeightG: waterWeightG,
    quickScore: quickScore,
    emoji: emoji,
    isQuickMode: isQuickMode,
  );

  // ─── BrewDetail ──────────────────────────────────────────────────────────

  /// Returns a [BrewDetail] representing a full detail aggregate.
  static BrewDetail brewDetail({
    int id = 1,
    String beanName = 'Ethiopia Yirgacheffe',
    String? roaster = 'Sample Roasters',
    String? origin = 'Ethiopia',
    String? roastLevel = 'Light',
    int? equipmentId = 1,
    String? equipmentName = 'Comandante C40',
    GrindMode grindMode = GrindMode.equipment,
    double? grindClickValue = 24.0,
    String? grindClickUnit = 'clicks',
    String? grindSimpleLabel,
    int? grindMicrons,
    int? quickScore = 4,
    String? emoji = '😊',
  }) => BrewDetail(
    id: id,
    brewDate: _baseDate,
    beanName: beanName,
    roaster: roaster,
    origin: origin,
    roastLevel: roastLevel,
    equipmentId: equipmentId,
    equipmentName: equipmentName,
    grindMode: grindMode,
    grindClickValue: grindClickValue,
    grindClickUnit: grindClickUnit,
    grindSimpleLabel: grindSimpleLabel,
    grindMicrons: grindMicrons,
    coffeeWeightG: 15.0,
    waterWeightG: 240.0,
    waterTempC: 93.0,
    brewDurationS: 180,
    bloomTimeS: 30,
    pourMethod: 'Pulse',
    waterType: 'Filtered',
    roomTempC: 24.0,
    quickScore: quickScore,
    emoji: emoji,
    acidity: 3.5,
    sweetness: 4.0,
    bitterness: 2.0,
    body: 3.0,
    flavorNotes: 'jasmine,citrus',
    notes: 'Clean cup',
    isQuickMode: true,
    createdAt: _baseDate,
    updatedAt: _baseDate,
  );
}
