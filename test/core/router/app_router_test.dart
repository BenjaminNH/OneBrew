import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:one_coffee/app.dart';
import 'package:one_coffee/core/database/drift_database.dart' hide BrewRecord;
import 'package:one_coffee/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_coffee/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_coffee/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_coffee/features/history/presentation/pages/history_page.dart';
import 'package:one_coffee/shared/providers/database_providers.dart';

void main() {
  group('Phase 7 router and app shell', () {
    testWidgets('initial route opens BrewLoggerPage', (tester) async {
      await _pumpApp(tester);

      expect(find.byType(BrewLoggerPage), findsOneWidget);
      expect(find.byKey(const Key('app-shell-navigation-bar')), findsOneWidget);
    });

    testWidgets('bottom navigation switches to HistoryPage', (tester) async {
      await _pumpApp(tester);

      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryPage), findsOneWidget);
      expect(find.text('Brew History'), findsOneWidget);
    });
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  final testDb = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
  addTearDown(() async {
    // Unmount first so provider disposal completes before DB close.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await testDb.close();
    await tester.pump();
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(testDb),
        recentBrewTemplatesProvider.overrideWith(
          (_) => Stream<List<BrewRecord>>.value(const <BrewRecord>[]),
        ),
      ],
      child: const OneCoffeeApp(),
    ),
  );
  await tester.pump();
}
