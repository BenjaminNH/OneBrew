import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/database/drift_database.dart';
import 'package:one_brew/features/inventory/presentation/pages/inventory_manage_page.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

void main() {
  testWidgets('InventoryManagePage shows manage controls and tab switching', (
    WidgetTester tester,
  ) async {
    final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: InventoryManagePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Manage'), findsOneWidget);
    expect(find.text('Beans'), findsOneWidget);
    expect(find.text('Grinders'), findsOneWidget);
    expect(
      find.byKey(const Key('manage-preferences-icon-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('manage-debug-onboarding-button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('manage-add-fab')), findsOneWidget);
    expect(find.byKey(const Key('bean-manage-search-field')), findsOneWidget);

    await tester.tap(find.text('Grinders'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('grinder-manage-search-field')),
      findsOneWidget,
    );
  });

  testWidgets(
    'Bean metadata renders roast level independently when origin is empty',
    (WidgetTester tester) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      await db.insertBean(
        BeansCompanion.insert(
          name: 'Ethiopia Yirgacheffe',
          roaster: const Value('Blue Bottle'),
          roastLevel: const Value('Light Roast'),
          useCount: const Value(5),
          addedAt: Value(DateTime(2026, 3, 1)),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: InventoryManagePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ethiopia Yirgacheffe'), findsOneWidget);
      expect(
        find.textContaining('Blue Bottle • Light Roast • Use 5 • Added 03/01'),
        findsOneWidget,
      );
    },
  );
}
