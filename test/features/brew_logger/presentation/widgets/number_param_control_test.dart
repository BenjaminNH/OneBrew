import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/widgets/app_slider.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/presentation/widgets/number_param_control.dart';

import '../../../../helpers/localized_test_app.dart';

void main() {
  group('NumberParamControl ranged mode', () {
    testWidgets('renders slider for ranged values', (tester) async {
      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
          body: NumberParamControl(
            label: 'Water Temp',
            value: 93,
            unit: 'C',
            range: const BrewParamNumberRange(
              min: 80,
              max: 100,
              step: 1,
              defaultValue: 93,
            ),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppSlider), findsOneWidget);
      expect(find.byKey(const Key('unranged-number-input')), findsNothing);
    });
  });

  group('NumberParamControl unranged mode', () {
    testWidgets('renders stepper input and updates by step', (tester) async {
      double? changed;

      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
          body: NumberParamControl(
            label: 'Bypass',
            value: 1.0,
            unit: 'g',
            range: null,
            unrangedStep: 0.1,
            onChanged: (value) => changed = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppSlider), findsNothing);
      expect(find.byKey(const Key('unranged-number-input')), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      expect(changed, 1.1);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pumpAndSettle();
      expect(changed, 0.9);
    });

    testWidgets('precise editor snaps by step in unranged mode', (
      tester,
    ) async {
      double? changed;

      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
          body: NumberParamControl(
            label: 'Agitation',
            value: 1.0,
            unit: null,
            range: null,
            unrangedStep: 0.1,
            unrangedFractionDigits: 2,
            onChanged: (value) => changed = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      final dialogField = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(dialogField, '1.27');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(changed, 1.3);
    });
  });
}
