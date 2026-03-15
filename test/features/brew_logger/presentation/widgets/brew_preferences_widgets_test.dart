import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_visibility.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_preferences_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/widgets/brew_preferences_widgets.dart';

void main() {
  group('BrewParamListEditor', () {
    testWidgets(
      'shows switch without delete for custom system default parameter',
      (tester) async {
        final item = BrewParamItem(
          definition: const BrewParamDefinition(
            id: 1,
            method: BrewMethod.custom,
            name: 'Coffee Weight',
            type: ParamType.number,
            unit: 'g',
            isSystem: true,
            sortOrder: 1,
          ),
          visibility: const BrewParamVisibility(
            id: 10,
            method: BrewMethod.custom,
            paramId: 1,
            isVisible: true,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BrewParamListEditor(
                items: [item],
                onVisibilityChanged: (brewParamItem, isVisible) {},
                onDelete: (brewParamItem) {},
              ),
            ),
          ),
        );

        expect(find.byType(Switch), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsNothing);
        expect(find.byIcon(Icons.lock_outline), findsNothing);
      },
    );

    testWidgets('shows delete for non-system custom parameter', (tester) async {
      final item = BrewParamItem(
        definition: const BrewParamDefinition(
          id: 3,
          method: BrewMethod.custom,
          name: 'Flow Rate',
          type: ParamType.number,
          unit: 'g/s',
          isSystem: false,
          sortOrder: 4,
        ),
        visibility: const BrewParamVisibility(
          id: 30,
          method: BrewMethod.custom,
          paramId: 3,
          isVisible: true,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrewParamListEditor(
              items: [item],
              onVisibilityChanged: (brewParamItem, isVisible) {},
              onDelete: (brewParamItem) {},
            ),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
    });

    testWidgets(
      'keeps pour-over essential parameter locked and non-deletable',
      (tester) async {
        final item = BrewParamItem(
          definition: const BrewParamDefinition(
            id: 2,
            method: BrewMethod.pourOver,
            name: 'Coffee Weight',
            type: ParamType.number,
            unit: 'g',
            isSystem: true,
            sortOrder: 1,
          ),
          visibility: const BrewParamVisibility(
            id: 20,
            method: BrewMethod.pourOver,
            paramId: 2,
            isVisible: true,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BrewParamListEditor(
                items: [item],
                onVisibilityChanged: (brewParamItem, isVisible) {},
                onDelete: (brewParamItem) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
        expect(find.byType(Switch), findsNothing);
        expect(find.byIcon(Icons.delete_outline), findsNothing);
      },
    );
  });
}
