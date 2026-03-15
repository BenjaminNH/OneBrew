import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';

import '../../helpers/fake_brew_param_repository.dart';

void main() {
  group('brewParamBootstrapProvider', () {
    test(
      'stays in onboarding when defaults were initialized but not finished',
      () async {
        final repo = FakeBrewParamRepository(
          methodConfigs: [],
          definitions: {},
          visibilities: {},
        );

        final firstContainer = ProviderContainer(
          overrides: [brewParamRepositoryProvider.overrideWithValue(repo)],
        );
        addTearDown(firstContainer.dispose);

        final firstLaunchShouldShowOnboarding = await firstContainer.read(
          brewParamBootstrapProvider.future,
        );
        expect(firstLaunchShouldShowOnboarding, isTrue);

        firstContainer.dispose();

        final secondContainer = ProviderContainer(
          overrides: [brewParamRepositoryProvider.overrideWithValue(repo)],
        );
        addTearDown(secondContainer.dispose);

        final relaunchShouldShowOnboarding = await secondContainer.read(
          brewParamBootstrapProvider.future,
        );
        expect(relaunchShouldShowOnboarding, isTrue);
      },
    );

    test('returns false after onboarding completion is persisted', () async {
      final repo = FakeBrewParamRepository(
        methodConfigs: [],
        definitions: {},
        visibilities: {},
      );
      final container = ProviderContainer(
        overrides: [brewParamRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      expect(await container.read(brewParamBootstrapProvider.future), isTrue);

      await repo.setOnboardingCompleted(true);
      container.invalidate(brewParamBootstrapProvider);

      expect(await container.read(brewParamBootstrapProvider.future), isFalse);
    });
  });
}
