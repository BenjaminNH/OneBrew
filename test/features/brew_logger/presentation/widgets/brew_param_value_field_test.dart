import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/widgets/app_input_style.dart';
import 'package:one_brew/core/widgets/app_slider.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_key.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/widgets/brew_param_value_field.dart';

import '../../../../helpers/localized_test_app.dart';

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

    testWidgets('uses unified slider control without inline range hint', (
      tester,
    ) async {
      double? changed;

      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
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
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppSlider), findsOneWidget);
      expect(find.textContaining('Range 80-100 C'), findsNothing);

      final slider = tester.widget<AppSlider>(find.byType(AppSlider));
      expect(slider.showValueLabel, isFalse);
      slider.onChanged(99.8);
      expect(changed, 100.0);
    });

    testWidgets('value editor enforces range constraints', (tester) async {
      double? changed;

      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
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

  group('BrewParamValueField text mode suggestions', () {
    const systemTextDefinition = BrewParamDefinition(
      id: 11,
      method: BrewMethod.pourOver,
      paramKey: BrewParamKeys.agitation,
      name: 'Agitation',
      type: ParamType.text,
      isSystem: true,
      sortOrder: 1,
    );

    const customTextDefinition = BrewParamDefinition(
      id: 12,
      method: BrewMethod.pourOver,
      paramKey: 'custom:12',
      name: 'Custom Note',
      type: ParamType.text,
      isSystem: false,
      sortOrder: 2,
    );

    testWidgets('shows suggestion list on focus and applies tapped value', (
      tester,
    ) async {
      String? changedValue;

      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
          body: BrewParamValueField(
            definition: systemTextDefinition,
            value: const BrewParamValueDraft(
              paramId: 11,
              type: ParamType.text,
              valueText: '',
            ),
            loadTextSuggestions: (_) async => const [
              'Swirl',
              'Stir',
              'Shake',
              'Pulse',
            ],
            onNumberChanged: (_) {},
            onTextChanged: (value) => changedValue = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('brew-param-suggestion-list-11')),
        findsNothing,
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('brew-param-suggestion-list-11')),
        findsOneWidget,
      );
      final inputRect = tester.getRect(
        find.byKey(const Key('brew-param-text-field-shell-11')),
      );
      final panelRect = tester.getRect(
        find.byKey(const Key('brew-param-suggestion-list-11')),
      );
      final gap = panelRect.top - inputRect.bottom;
      expect(gap.abs(), lessThanOrEqualTo(2));
      expect(find.text('Swirl'), findsOneWidget);
      expect(find.text('Stir'), findsOneWidget);
      expect(find.text('Shake'), findsOneWidget);
      expect(find.text('Pulse'), findsNothing);

      await tester.tap(find.text('Stir'));
      await tester.pumpAndSettle();

      expect(changedValue, 'Stir');
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Stir');
      expect(
        find.byKey(const Key('brew-param-suggestion-list-11')),
        findsNothing,
      );
    });

    testWidgets('shows suggestions for custom text params with stable keys', (
      tester,
    ) async {
      String? changedValue;

      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
          body: BrewParamValueField(
            definition: customTextDefinition,
            value: const BrewParamValueDraft(
              paramId: 12,
              type: ParamType.text,
              valueText: '',
            ),
            loadTextSuggestions: (_) async => const ['One', 'Two', 'Three'],
            onNumberChanged: (_) {},
            onTextChanged: (value) => changedValue = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);

      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();

      expect(changedValue, 'Two');
    });

    testWidgets('respects disabled suggestion visibility', (tester) async {
      await pumpLocalizedWidget(
        tester,
        child: Scaffold(
          body: BrewParamValueField(
            definition: systemTextDefinition,
            value: const BrewParamValueDraft(
              paramId: 11,
              type: ParamType.text,
              valueText: '',
            ),
            loadTextSuggestions: (_) async => const ['Swirl', 'Stir', 'Shake'],
            suggestionVisibility: AppSuggestionVisibility.disabled,
            onNumberChanged: (_) {},
            onTextChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.text('Swirl'), findsNothing);
      expect(find.text('Stir'), findsNothing);
      expect(find.text('Shake'), findsNothing);
    });
  });
}
