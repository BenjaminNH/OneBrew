import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/presentation/models/brew_param_names.dart';

void main() {
  group('brew_param_names rules', () {
    test('custom defaults can be toggled in custom method', () {
      expect(
        canToggleParam(
          method: BrewMethod.custom,
          name: BrewParamNames.coffeeWeight,
        ),
        isTrue,
      );
      expect(
        canToggleParam(
          method: BrewMethod.custom,
          name: BrewParamNames.waterWeight,
        ),
        isTrue,
      );
      expect(
        canToggleParam(
          method: BrewMethod.custom,
          name: BrewParamNames.brewRatio,
        ),
        isTrue,
      );
    });

    test('essential defaults remain locked for non-custom methods', () {
      expect(
        canToggleParam(
          method: BrewMethod.pourOver,
          name: BrewParamNames.coffeeWeight,
        ),
        isFalse,
      );
      expect(
        canToggleParam(
          method: BrewMethod.espresso,
          name: BrewParamNames.yieldAmount,
        ),
        isFalse,
      );
    });
  });
}
