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

    test('persists numeric range fields for custom number params', () async {
      final repo = FakeBrewParamRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final controller = container.read(
        brewPreferencesControllerProvider.notifier,
      );
      await controller.load(showLoading: true);
      await controller.addCustomParam(
        method: BrewMethod.pourOver,
        name: 'Pulse Count',
        type: ParamType.number,
        unit: 'times',
        numberMin: 1,
        numberMax: 8,
        numberStep: 1,
        numberDefault: 3,
      );

      final defs = await repo.getParamDefinitions(BrewMethod.pourOver);
      final created = defs.firstWhere((d) => d.name == 'Pulse Count');
      expect(created.numberMin, 1);
      expect(created.numberMax, 8);
      expect(created.numberStep, 1);
      expect(created.numberDefault, 3);
      expect(created.unit, 'times');
      expect(
        container.read(brewPreferencesControllerProvider).errorMessage,
        isNull,
      );
    });

    test('rejects invalid numeric ranges for custom number params', () async {
      final repo = FakeBrewParamRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final controller = container.read(
        brewPreferencesControllerProvider.notifier,
      );
      await controller.load(showLoading: true);

      await controller.addCustomParam(
        method: BrewMethod.pourOver,
        name: 'Broken Param',
        type: ParamType.number,
        numberMin: 10,
        numberMax: 2,
      );
      expect(
        container.read(brewPreferencesControllerProvider).errorMessage,
        'Maximum value must be greater than minimum value.',
      );

      controller.clearError();
      await controller.addCustomParam(
        method: BrewMethod.pourOver,
        name: 'Broken Param 2',
        type: ParamType.number,
        numberMin: 0,
        numberMax: 10,
        numberDefault: 20,
      );
      expect(
        container.read(brewPreferencesControllerProvider).errorMessage,
        'Default value must be within the min/max range.',
      );
    });
  });
}
