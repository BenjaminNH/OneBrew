import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/features/brew_logger/brew_logger_providers.dart';
import 'package:one_coffee/features/brew_logger/presentation/pages/onboarding_page.dart';

import '../../../../helpers/fake_brew_param_repository.dart';

void main() {
  testWidgets('Onboarding flow advances through two steps', (
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
    expect(find.text('Finish'), findsOneWidget);
  });
}
