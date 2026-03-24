import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/core/router/app_route_paths.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_preferences_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/onboarding_page.dart';
import 'package:one_brew/l10n/app_localizations.dart';

import '../../../../helpers/fake_brew_param_repository.dart';

void main() {
  testWidgets('Onboarding flow uses Next Method before Finish', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeBrewParamRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          brewParamRepositoryProvider.overrideWithValue(fakeRepo),
          brewParamBootstrapProvider.overrideWith((ref) async => true),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: AppLocaleOption.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: BrewOnboardingPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose brew methods'), findsOneWidget);
    expect(find.text('Focus on one brew at a time.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Parameter list'), findsOneWidget);
    expect(find.text('Next Method'), findsOneWidget);

    await tester.tap(find.text('Next Method'));
    await tester.pumpAndSettle();

    expect(find.text('Finish'), findsOneWidget);
  });

  testWidgets('Custom method action supports add then delete', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeBrewParamRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          brewParamRepositoryProvider.overrideWithValue(fakeRepo),
          brewParamBootstrapProvider.overrideWith((ref) async => true),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: AppLocaleOption.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: BrewOnboardingPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final addButton = find.byKey(const Key('custom-method-add-button'));
    expect(addButton, findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(BrewOnboardingPage)),
    );
    await container
        .read(brewPreferencesControllerProvider.notifier)
        .renameCustomMethod('AeroPress');
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('custom-method-rename-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('custom-method-delete-button')),
      findsOneWidget,
    );

    await container
        .read(brewPreferencesControllerProvider.notifier)
        .deleteCustomMethod();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('custom-method-add-button')), findsOneWidget);
  });

  testWidgets('plays light haptic feedback only once on first step advance', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeBrewParamRepository();
    final methodCalls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall call,
        ) async {
          methodCalls.add(call);
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          brewParamRepositoryProvider.overrideWithValue(fakeRepo),
          brewParamBootstrapProvider.overrideWith((ref) async => true),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: AppLocaleOption.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: BrewOnboardingPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next Method'));
    await tester.pumpAndSettle();

    final hapticCalls = methodCalls
        .where((call) => call.method == 'HapticFeedback.vibrate')
        .toList();
    expect(hapticCalls, hasLength(1));
    expect(hapticCalls.first.arguments, 'HapticFeedbackType.lightImpact');
  });

  testWidgets('small screen does not throw layout exceptions on step two', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final fakeRepo = FakeBrewParamRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          brewParamRepositoryProvider.overrideWithValue(fakeRepo),
          brewParamBootstrapProvider.overrideWith((ref) async => true),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: AppLocaleOption.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: BrewOnboardingPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Parameter list'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'skip navigates to brew without persisting onboarding completion',
    (WidgetTester tester) async {
      final fakeRepo = FakeBrewParamRepository();

      await tester.pumpWidget(_buildOnboardingRouterApp(fakeRepo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('brew-page-marker')), findsOneWidget);
      expect(await fakeRepo.hasCompletedOnboarding(), isFalse);
    },
  );

  testWidgets(
    'finish persists onboarding completion before navigating to brew',
    (WidgetTester tester) async {
      final fakeRepo = FakeBrewParamRepository();

      await tester.pumpWidget(_buildOnboardingRouterApp(fakeRepo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next Method'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('brew-page-marker')), findsOneWidget);
      expect(await fakeRepo.hasCompletedOnboarding(), isTrue);
    },
  );
}

Widget _buildOnboardingRouterApp(FakeBrewParamRepository fakeRepo) {
  final router = GoRouter(
    initialLocation: AppRoutePaths.onboarding,
    routes: [
      GoRoute(
        path: AppRoutePaths.onboarding,
        builder: (_, _) => const BrewOnboardingPage(),
      ),
      GoRoute(
        path: AppRoutePaths.brew,
        builder: (_, _) =>
            const Scaffold(body: SizedBox(key: Key('brew-page-marker'))),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      brewParamRepositoryProvider.overrideWithValue(fakeRepo),
      brewParamBootstrapProvider.overrideWith((ref) async => true),
    ],
    child: MaterialApp.router(
      locale: const Locale('en'),
      supportedLocales: AppLocaleOption.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    ),
  );
}
