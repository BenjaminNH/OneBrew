import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/rating/presentation/widgets/flavor_sliders.dart';

import '../../../../helpers/localized_test_app.dart';

void main() {
  group('FlavorSliders', () {
    testWidgets('uses 0-5 slider scale and shows value labels as /5', (
      tester,
    ) async {
      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
          body: FlavorSliders(
            acidity: 4.5,
            sweetness: 3.0,
            bitterness: 2.5,
            body: 5.0,
            onAcidityChanged: (_) {},
            onSweetnessChanged: (_) {},
            onBitternessChanged: (_) {},
            onBodyChanged: (_) {},
          ),
        ),
      );

      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      expect(sliders, hasLength(4));
      for (final slider in sliders) {
        expect(slider.min, 0.0);
        expect(slider.max, 5.0);
        expect(slider.divisions, 10);
      }

      expect(find.text('4.5/5'), findsOneWidget);
      expect(find.text('3.0/5'), findsOneWidget);
      expect(find.text('2.5/5'), findsOneWidget);
      expect(find.text('5.0/5'), findsOneWidget);
    });
  });
}
