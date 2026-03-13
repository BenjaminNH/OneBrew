// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/native.dart';

import 'package:one_brew/app.dart';
import 'package:one_brew/core/database/drift_database.dart' hide BrewRecord;
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

void main() {
  testWidgets('OneBrewApp renders without crashing', (
    WidgetTester tester,
  ) async {
    final testDb = OneBrewDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await testDb.close();
      await tester.pump();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          brewParamBootstrapProvider.overrideWith((ref) async => false),
          recentBrewTemplatesProvider.overrideWith(
            (_) => Stream<List<BrewRecord>>.value(const <BrewRecord>[]),
          ),
        ],
        child: const OneBrewApp(),
      ),
    );
    // Avoid pumpAndSettle here: loading indicators can keep animations alive.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    // Phase 7 initial route should land on the brew logger page.
    expect(find.text('OneBrew'), findsOneWidget);
  });
}
