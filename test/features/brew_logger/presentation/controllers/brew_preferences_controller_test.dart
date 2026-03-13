import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method_config.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_visibility.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_preferences_controller.dart';

import '../../../../helpers/fake_brew_param_repository.dart';

ProviderContainer _makeContainer(FakeBrewParamRepository repo) {
  return ProviderContainer(
    overrides: [
      brewParamRepositoryProvider.overrideWithValue(repo),
      brewParamBootstrapProvider.overrideWith((ref) async => false),
    ],
  );
}

void main() {
  group('BrewPreferencesController', () {
    test('keeps custom system default parameters non-deletable', () async {
      final repo = FakeBrewParamRepository(
        methodConfigs: const [
          BrewMethodConfig(
            id: 1,
            method: BrewMethod.pourOver,
            displayName: 'Pour Over',
            isEnabled: true,
          ),
          BrewMethodConfig(
            id: 2,
            method: BrewMethod.espresso,
            displayName: 'Espresso',
            isEnabled: true,
          ),
          BrewMethodConfig(
            id: 3,
            method: BrewMethod.custom,
            displayName: 'Custom',
            isEnabled: true,
          ),
        ],
        definitions: {
          BrewMethod.custom: [
            const BrewParamDefinition(
              id: 1001,
              method: BrewMethod.custom,
              name: 'Coffee Weight',
              type: ParamType.number,
              unit: 'g',
              isSystem: true,
              sortOrder: 1,
            ),
            const BrewParamDefinition(
              id: 1002,
              method: BrewMethod.custom,
              name: 'Water Weight',
              type: ParamType.number,
              unit: 'g',
              isSystem: true,
              sortOrder: 2,
            ),
            const BrewParamDefinition(
              id: 1003,
              method: BrewMethod.custom,
              name: 'Brew Ratio',
              type: ParamType.number,
              isSystem: true,
              sortOrder: 3,
            ),
          ],
        },
        visibilities: {
          BrewMethod.custom: [
            const BrewParamVisibility(
              id: 2001,
              method: BrewMethod.custom,
              paramId: 1001,
              isVisible: true,
            ),
            const BrewParamVisibility(
              id: 2002,
              method: BrewMethod.custom,
              paramId: 1002,
              isVisible: true,
            ),
            const BrewParamVisibility(
              id: 2003,
              method: BrewMethod.custom,
              paramId: 1003,
              isVisible: true,
            ),
          ],
        },
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final controller = container.read(
        brewPreferencesControllerProvider.notifier,
      );
      await controller.load(showLoading: true);
      await controller.deleteCustomParam(BrewMethod.custom, 1001);

      final defs = await repo.getParamDefinitions(BrewMethod.custom);
      final state = container.read(brewPreferencesControllerProvider);
      expect(defs.any((d) => d.id == 1001), isTrue);
      expect(state.errorMessage, 'System parameters cannot be deleted.');
    });

    test('keeps non-custom system defaults non-deletable', () async {
      final repo = FakeBrewParamRepository(
        methodConfigs: const [
          BrewMethodConfig(
            id: 1,
            method: BrewMethod.pourOver,
            displayName: 'Pour Over',
            isEnabled: true,
          ),
        ],
        definitions: {
          BrewMethod.pourOver: const [
            BrewParamDefinition(
              id: 11,
              method: BrewMethod.pourOver,
              name: 'Coffee Weight',
              type: ParamType.number,
              unit: 'g',
              isSystem: true,
              sortOrder: 1,
            ),
          ],
        },
        visibilities: {
          BrewMethod.pourOver: const [
            BrewParamVisibility(
              id: 21,
              method: BrewMethod.pourOver,
              paramId: 11,
              isVisible: true,
            ),
          ],
        },
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final controller = container.read(
        brewPreferencesControllerProvider.notifier,
      );
      await controller.load(showLoading: true);
      await controller.deleteCustomParam(BrewMethod.pourOver, 11);

      final defs = await repo.getParamDefinitions(BrewMethod.pourOver);
      final state = container.read(brewPreferencesControllerProvider);
      expect(defs.any((d) => d.id == 11), isTrue);
      expect(state.errorMessage, 'System parameters cannot be deleted.');
    });
  });
}
