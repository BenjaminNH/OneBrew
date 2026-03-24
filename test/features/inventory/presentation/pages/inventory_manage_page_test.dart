import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/database/drift_database.dart';
import 'package:one_brew/core/utils/date_utils.dart';
import 'package:one_brew/features/inventory/presentation/pages/inventory_manage_page.dart';
import 'package:one_brew/l10n/app_localizations.dart';
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
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: InventoryManagePage(),
        ),
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
    expect(find.byKey(const Key('manage-about-icon-button')), findsOneWidget);
    expect(find.byKey(const Key('manage-add-fab')), findsOneWidget);
    expect(find.byKey(const Key('manage-language-icon-button')), findsOneWidget);
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
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: InventoryManagePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ethiopia Yirgacheffe'), findsOneWidget);
      final dateLabel = AppDateUtils.formatDateShort(
        DateTime(2026, 3, 1),
        localeName: 'en',
      );
      expect(
        find.textContaining(
          'Blue Bottle • Light Roast • Use 5 • Added $dateLabel',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('FAB opens bean and grinder forms', (WidgetTester tester) async {
    final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: InventoryManagePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('manage-add-fab')));
    await tester.pumpAndSettle();

    expect(find.text('Add Bean'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Grinders'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('manage-add-fab')));
    await tester.pumpAndSettle();

    expect(find.text('Add Grinder'), findsOneWidget);
  });

  testWidgets('About button opens sheet with author and version info', (
    WidgetTester tester,
  ) async {
    final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: InventoryManagePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('manage-about-icon-button')));
    await tester.pumpAndSettle();

    expect(find.text('About OneBrew'), findsOneWidget);
    expect(find.text('Author: BenjaminNH'), findsOneWidget);
    expect(find.byKey(const Key('manage-about-version-text')), findsOneWidget);
    expect(find.byKey(const Key('manage-about-github-button')), findsOneWidget);
  });
}
