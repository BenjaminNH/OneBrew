import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/features/inventory/domain/entities/bean.dart';
import 'package:one_coffee/features/inventory/domain/entities/equipment.dart';
import 'package:one_coffee/features/inventory/inventory_providers.dart';
import 'package:one_coffee/features/inventory/presentation/controllers/inventory_controller.dart';

import '../../../../helpers/mock_repositories.mocks.dart';

void main() {
  group('InventoryController useCount semantics', () {
    late MockInventoryRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockInventoryRepository();
      when(mockRepository.createBean(any)).thenAnswer((_) async => 1);
      when(mockRepository.createEquipment(any)).thenAnswer((_) async => 2);

      container = ProviderContainer(
        overrides: [
          inventoryRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('addBean initializes useCount to 0', () async {
      await container
          .read(inventoryControllerProvider.notifier)
          .addBean('Ethiopia Yirgacheffe');

      final captured =
          verify(mockRepository.createBean(captureAny)).captured.single as Bean;
      expect(captured.useCount, 0);
    });

    test('addEquipment initializes useCount to 0', () async {
      await container
          .read(inventoryControllerProvider.notifier)
          .addEquipment('Comandante C40', isGrinder: true);

      final captured =
          verify(mockRepository.createEquipment(captureAny)).captured.single
              as Equipment;
      expect(captured.useCount, 0);
    });

    test('addEquipment keeps grinder click config when provided', () async {
      await container
          .read(inventoryControllerProvider.notifier)
          .addEquipment(
            'Lagom Mini',
            isGrinder: true,
            grindMinClick: 0,
            grindMaxClick: 40,
            grindClickStep: 1,
            grindClickUnit: 'clicks',
          );

      final captured =
          verify(mockRepository.createEquipment(captureAny)).captured.single
              as Equipment;
      expect(captured.grindMinClick, 0);
      expect(captured.grindMaxClick, 40);
      expect(captured.grindClickStep, 1);
      expect(captured.grindClickUnit, 'clicks');
    });
  });
}
