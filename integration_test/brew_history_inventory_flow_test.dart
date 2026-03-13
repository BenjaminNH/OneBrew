import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:one_brew/app.dart';
import 'package:one_brew/core/database/drift_database.dart' hide BrewRecord;
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_brew/features/inventory/presentation/pages/inventory_manage_page.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('phase7C critical flow is reachable from main paths', (
    WidgetTester tester,
  ) async {
    final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
    await _seedBrewRecord(db);

    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await db.close();
      await tester.pump();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          brewParamBootstrapProvider.overrideWith((_) async => false),
          recentBrewTemplatesProvider.overrideWith(
            (_) => Stream<List<BrewRecord>>.value(const <BrewRecord>[]),
          ),
        ],
        child: const OneBrewApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(find.byType(InventoryManagePage), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('history-record-card-1')));
    await tester.pumpAndSettle();
    expect(find.byType(BrewDetailPage), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('brew-detail-brew-again')));
    await tester.tap(find.byKey(const Key('brew-detail-brew-again')));
    await tester.pumpAndSettle();

    expect(find.byType(BrewLoggerPage), findsOneWidget);
    expect(find.text('Template loaded from history'), findsOneWidget);
  });
}

Future<void> _seedBrewRecord(OneBrewDatabase db) async {
  final now = DateTime(2026, 3, 9, 9, 30);
  await db.insertBrewRecord(
    BrewRecordsCompanion.insert(
      brewDate: now,
      beanName: 'Phase7C Seed Bean',
      grindMode: const drift.Value('simple'),
      grindSimpleLabel: const drift.Value('Medium'),
      coffeeWeightG: 15,
      waterWeightG: 240,
      brewDurationS: 180,
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    ),
  );
}
