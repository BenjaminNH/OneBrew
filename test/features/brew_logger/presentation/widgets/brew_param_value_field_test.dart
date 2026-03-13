import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/widgets/app_slider.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/widgets/brew_param_value_field.dart';

void main() {
  group('BrewParamValueField number mode', () {
    const definition = BrewParamDefinition(
      id: 1,
      method: BrewMethod.pourOver,
      name: 'Water Temp',
      type: ParamType.number,
      unit: 'C',
      numberMin: 80,
      numberMax: 100,
      numberStep: 1,
      numberDefault: 93,
      isSystem: true,
      sortOrder: 1,
    );

    testWidgets('uses unified slider control with range hint', (tester) async {
      double? changed;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrewParamValueField(
              definition: definition,
              value: const BrewParamValueDraft(
                paramId: 1,
                type: ParamType.number,
              ),
              onNumberChanged: (value) => changed = value,
              onTextChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppSlider), findsOneWidget);
      expect(find.textContaining('Range 80-100 C'), findsOneWidget);

      final slider = tester.widget<AppSlider>(find.byType(AppSlider));
      slider.onChanged(99.8);
      expect(changed, 100.0);
    });

    testWidgets('value editor enforces range constraints', (tester) async {
      double? changed;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrewParamValueField(
              definition: definition,
              value: const BrewParamValueDraft(
                paramId: 1,
                type: ParamType.number,
                valueNumber: 93,
              ),
              onNumberChanged: (value) => changed = value,
              onTextChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '120');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(find.textContaining('between 80.0 and 100.0'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '92.4');
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(changed, 92.0);
    });
  });
}
