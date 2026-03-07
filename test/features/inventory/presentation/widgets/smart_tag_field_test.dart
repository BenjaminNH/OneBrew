import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:one_coffee/core/database/drift_database.dart';
import 'package:one_coffee/shared/providers/database_providers.dart';
import 'package:one_coffee/core/widgets/app_chip_input.dart';
import 'package:one_coffee/features/inventory/presentation/widgets/smart_tag_field.dart';

void main() {
  testWidgets('SmartTagField renders and handles input', (
    WidgetTester tester,
  ) async {
    List<String> selectedTags = [];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(
            OneCoffeeDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SmartTagField(
                  type: TagFieldType.bean,
                  tags: selectedTags,
                  onTagsChanged: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    // Initial state: empty field, hint text visible
    expect(find.byType(AppChipInput), findsOneWidget);
    expect(find.text('Type to add...'), findsOneWidget);

    // Enter a new bean tag
    await tester.enterText(find.byType(TextField), 'Gesha');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verify tag is added to the list and UI reflects it
    expect(selectedTags, ['Gesha']);
    expect(find.text('Gesha'), findsOneWidget);
  });
}
