import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/core/database/drift_database.dart';
import 'package:one_coffee/features/inventory/presentation/pages/inventory_manage_page.dart';
import 'package:one_coffee/shared/providers/database_providers.dart';

void main() {
  testWidgets('InventoryManagePage switches between Beans and Grinders tabs', (
    WidgetTester tester,
  ) async {
    final db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: InventoryManagePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Inventory Manage'), findsOneWidget);
    expect(find.text('Beans'), findsOneWidget);
    expect(find.text('Grinders'), findsOneWidget);
    expect(find.byKey(const Key('bean-manage-search-field')), findsOneWidget);

    await tester.tap(find.text('Grinders'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('grinder-manage-search-field')),
      findsOneWidget,
    );
  });
}
