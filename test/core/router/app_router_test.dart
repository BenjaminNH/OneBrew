import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:one_brew/app.dart';
import 'package:one_brew/core/database/drift_database.dart' hide BrewRecord;
import 'package:one_brew/core/router/app_router.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/onboarding_page.dart';
import 'package:one_brew/features/history/presentation/pages/history_page.dart';
import 'package:one_brew/features/inventory/presentation/pages/inventory_manage_page.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

void main() {
  group('Phase 7 router and app shell', () {
    testWidgets('initial route opens BrewLoggerPage', (tester) async {
      await _pumpApp(tester);

      expect(find.byType(BrewLoggerPage), findsOneWidget);
      expect(find.byKey(const Key('app-shell-navigation-bar')), findsOneWidget);
      final nav = tester.widget<NavigationBar>(
        find.byKey(const Key('app-shell-navigation-bar')),
      );
      final destinations = nav.destinations.cast<NavigationDestination>();
      expect(destinations[0].label, 'Brew');
      expect(destinations[1].label, 'History');
      expect(destinations[2].label, 'Manage');
      expect(nav.selectedIndex, 0);
    });

    testWidgets('bottom navigation switches to Manage and History', (
      tester,
    ) async {
      await _pumpApp(tester);

      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryPage), findsOneWidget);
      var nav = tester.widget<NavigationBar>(
        find.byKey(const Key('app-shell-navigation-bar')),
      );
      expect(nav.selectedIndex, 1);

      await tester.tap(find.text('Manage'));
      await tester.pumpAndSettle();

      expect(find.byType(InventoryManagePage), findsOneWidget);
      nav = tester.widget<NavigationBar>(
        find.byKey(const Key('app-shell-navigation-bar')),
      );
      expect(nav.selectedIndex, 2);
    });

    testWidgets('invalid history detail id can return to history', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        initialLocation: '${AppRoutePaths.history}/bad-id',
      );

      expect(find.text('Invalid history detail id.'), findsOneWidget);
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryPage), findsOneWidget);
    });

    testWidgets('preferences back button returns to manage page', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: AppRoutePaths.managePreferences);

      expect(find.text('Record Preferences'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(InventoryManagePage), findsOneWidget);
      final nav = tester.widget<NavigationBar>(
        find.byKey(const Key('app-shell-navigation-bar')),
      );
      expect(nav.selectedIndex, 2);
    });

    testWidgets('manage debug onboarding button opens onboarding page', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: AppRoutePaths.manage);

      expect(find.byType(InventoryManagePage), findsOneWidget);
      await tester.tap(find.byKey(const Key('manage-debug-onboarding-button')));
      await tester.pumpAndSettle();

      expect(find.byType(BrewOnboardingPage), findsOneWidget);
      expect(find.byKey(const Key('app-shell-navigation-bar')), findsNothing);
    });
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  String initialLocation = AppRoutePaths.brew,
}) async {
  tester.view.physicalSize = const Size(1080, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  appRouter.go(initialLocation);

  final testDb = OneBrewDatabase.forTesting(NativeDatabase.memory());
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
        brewParamBootstrapProvider.overrideWith((ref) async => false),
        recentBrewTemplatesProvider.overrideWith(
          (_) => Stream<List<BrewRecord>>.value(const <BrewRecord>[]),
        ),
      ],
      child: const OneBrewApp(),
    ),
  );
  await tester.pump();
}
