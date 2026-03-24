import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/presentation/models/brew_param_names.dart';

void main() {
  group('brew_param_names rules', () {
    test('custom param keys use stable custom prefix', () {
      expect(customParamKeyForId(42), 'custom:42');
      expect(isCustomParamKey('custom:42'), isTrue);
      expect(isCustomParamKey(BrewParamKeys.coffeeWeight), isFalse);
    });

    test('custom defaults can be toggled in custom method', () {
      expect(
        canToggleParam(
          method: BrewMethod.custom,
          paramKey: BrewParamKeys.coffeeWeight,
          name: 'Coffee Weight',
        ),
        isTrue,
      );
      expect(
        canToggleParam(
          method: BrewMethod.custom,
          paramKey: BrewParamKeys.waterWeight,
          name: 'Water Weight',
        ),
        isTrue,
      );
      expect(
        canToggleParam(
          method: BrewMethod.custom,
          paramKey: BrewParamKeys.brewRatio,
          name: 'Brew Ratio',
        ),
        isTrue,
      );
    });

    test('essential defaults remain locked for non-custom methods', () {
      expect(
        canToggleParam(
          method: BrewMethod.pourOver,
          paramKey: BrewParamKeys.coffeeWeight,
          name: 'Coffee Weight',
        ),
        isFalse,
      );
      expect(
        canToggleParam(
          method: BrewMethod.espresso,
          paramKey: BrewParamKeys.yieldAmount,
          name: 'Yield',
        ),
        isFalse,
      );
    });
  });
}
