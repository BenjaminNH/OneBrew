import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_preferences_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/onboarding_page.dart';

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
        child: const MaterialApp(home: BrewOnboardingPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose brew methods'), findsOneWidget);

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
        child: const MaterialApp(home: BrewOnboardingPage()),
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
}
