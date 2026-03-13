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
    expect(find.byKey(const Key('manage-add-fab')), findsOneWidget);
    expect(find.byKey(const Key('bean-manage-search-field')), findsOneWidget);

    await tester.tap(find.text('Grinders'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('grinder-manage-search-field')),
      findsOneWidget,
    );
  });
}
