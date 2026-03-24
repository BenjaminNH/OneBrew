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

import 'package:one_brew/core/database/drift_database.dart' hide BrewRecord;
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

import 'helpers/localized_test_app.dart';

void main() {
  testWidgets('BrewLoggerPage renders without crashing', (
    WidgetTester tester,
  ) async {
    final testDb = OneBrewDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await testDb.close();
      await tester.pump();
    });

    await pumpLocalizedWidget(
      tester,
      child: ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
          brewParamBootstrapProvider.overrideWith((ref) async => false),
          recentBrewTemplatesProvider.overrideWith(
            (_) => Stream<List<BrewRecord>>.value(const <BrewRecord>[]),
          ),
        ],
        child: const BrewLoggerPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BrewLoggerPage), findsOneWidget);
  });
}
