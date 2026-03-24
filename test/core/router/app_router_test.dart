import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:one_brew/core/database/drift_database.dart' hide BrewRecord;
import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/core/router/app_router.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_param_preferences_page.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/onboarding_page.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_brew/features/history/presentation/pages/history_page.dart';
import 'package:one_brew/features/inventory/presentation/pages/inventory_manage_page.dart';
import 'package:one_brew/l10n/app_localizations.dart';
import 'package:one_brew/l10n/l10n.dart';
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

    testWidgets('navigation bar swipe switches between shell tabs', (
      tester,
    ) async {
      await _pumpApp(tester);

      final navFinder = find.byKey(const Key('app-shell-navigation-bar'));

      await tester.drag(navFinder, const Offset(-180, 0));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryPage), findsOneWidget);

      await tester.drag(navFinder, const Offset(-180, 0));
      await tester.pumpAndSettle();
      expect(find.byType(InventoryManagePage), findsOneWidget);

      await tester.drag(navFinder, const Offset(180, 0));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryPage), findsOneWidget);
    });

    testWidgets('system-edge drags do not trigger tab switching', (
      tester,
    ) async {
      await _pumpApp(tester);

      await tester.dragFrom(const Offset(1, 500), const Offset(-220, 0));
      await tester.pumpAndSettle();
      expect(find.byType(BrewLoggerPage), findsOneWidget);

      await tester.dragFrom(const Offset(1, 2960), const Offset(220, 0));
      await tester.pumpAndSettle();

      expect(find.byType(BrewLoggerPage), findsOneWidget);
      final nav = tester.widget<NavigationBar>(
        find.byKey(const Key('app-shell-navigation-bar')),
      );
      expect(nav.selectedIndex, 0);
    });

    testWidgets('content horizontal drag does not switch tabs', (tester) async {
      await _pumpApp(tester);

      await tester.dragFrom(const Offset(540, 500), const Offset(-220, 0));
      await tester.pumpAndSettle();

      expect(find.byType(BrewLoggerPage), findsOneWidget);
      final nav = tester.widget<NavigationBar>(
        find.byKey(const Key('app-shell-navigation-bar')),
      );
      expect(nav.selectedIndex, 0);
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

    testWidgets('launch route opens onboarding on first run', (tester) async {
      await _pumpApp(
        tester,
        initialLocation: AppRoutePaths.launch,
        isFirstRun: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(BrewOnboardingPage), findsOneWidget);
      expect(find.byKey(const Key('app-shell-navigation-bar')), findsNothing);
    });
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  String initialLocation = AppRoutePaths.brew,
  bool isFirstRun = false,
}) async {
  tester.view.physicalSize = const Size(1080, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

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
        brewParamBootstrapProvider.overrideWith((ref) async => isFirstRun),
        recentBrewTemplatesProvider.overrideWith(
          (_) => Stream<List<BrewRecord>>.value(const <BrewRecord>[]),
        ),
      ],
      child: MaterialApp.router(
        locale: const Locale('en'),
        supportedLocales: AppLocaleOption.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: _createTestRouter(
          initialLocation: initialLocation,
          isFirstRun: isFirstRun,
        ),
      ),
    ),
  );
  await tester.pump();
}

GoRouter _createTestRouter({
  required String initialLocation,
  required bool isFirstRun,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutePaths.launch,
        builder: (_, _) => const _TestLaunchGatePage(),
      ),
      GoRoute(
        path: AppRoutePaths.onboarding,
        builder: (_, _) => const BrewOnboardingPage(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: AppRoutePaths.brew,
            builder: (_, state) {
              final templateRecordId = int.tryParse(
                state.uri.queryParameters['templateRecordId'] ?? '',
              );
              return BrewLoggerPage(templateRecordId: templateRecordId);
            },
          ),
          GoRoute(
            path: AppRoutePaths.manage,
            builder: (_, _) => const InventoryManagePage(),
            routes: [
              GoRoute(
                path: 'preferences',
                builder: (_, _) => const BrewParamPreferencesPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutePaths.history,
            builder: (_, _) => const HistoryPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  if (id == null) {
                    return const _TestRouteErrorPage(
                      fallbackPath: AppRoutePaths.history,
                    );
                  }
                  return BrewDetailPage(brewId: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _TestLaunchGatePage extends ConsumerWidget {
  const _TestLaunchGatePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(brewParamBootstrapProvider);
    bootstrapAsync.whenData((shouldShowOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        context.go(
          shouldShowOnboarding ? AppRoutePaths.onboarding : AppRoutePaths.brew,
        );
      });
    });

    return const Scaffold(body: SizedBox.shrink());
  }
}

class _TestRouteErrorPage extends StatelessWidget {
  const _TestRouteErrorPage({required this.fallbackPath});

  final String fallbackPath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.routeInvalidHistoryDetailId),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(fallbackPath),
                child: Text(l10n.actionGoBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
