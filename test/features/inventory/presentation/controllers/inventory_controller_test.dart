import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/features/inventory/domain/entities/bean.dart';
import 'package:one_brew/features/inventory/domain/entities/equipment.dart';
import 'package:one_brew/features/inventory/inventory_providers.dart';
import 'package:one_brew/features/inventory/presentation/controllers/inventory_controller.dart';

import '../../../../helpers/mock_repositories.mocks.dart';

void main() {
  group('InventoryController useCount semantics', () {
    late MockInventoryRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockInventoryRepository();
      when(mockRepository.createBean(any)).thenAnswer((_) async => 1);
      when(mockRepository.createEquipment(any)).thenAnswer((_) async => 2);
      when(mockRepository.getAllBeans()).thenAnswer((_) async => const []);
      when(mockRepository.searchBeans(any)).thenAnswer((_) async => const []);
      when(mockRepository.updateBean(any)).thenAnswer((_) async => true);
      when(mockRepository.deleteBean(any)).thenAnswer((_) async => 1);
      when(
        mockRepository.renameBeanAndPropagate(
          beanId: anyNamed('beanId'),
          newName: anyNamed('newName'),
        ),
      ).thenAnswer((_) async => true);
      when(mockRepository.getAllGrinders()).thenAnswer((_) async => const []);
      when(
        mockRepository.searchGrinders(any),
      ).thenAnswer((_) async => const []);
      when(mockRepository.updateGrinder(any)).thenAnswer((_) async => true);
      when(
        mockRepository.deleteGrinderWithGuard(any),
      ).thenAnswer((_) async => 1);

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

    test('queryBeans uses getAllBeans for empty query', () async {
      await container.read(inventoryControllerProvider.notifier).queryBeans('');
      verify(mockRepository.getAllBeans()).called(1);
      verifyNever(mockRepository.searchBeans(any));
    });

    test('queryGrinders uses searchGrinders for non-empty query', () async {
      await container
          .read(inventoryControllerProvider.notifier)
          .queryGrinders('Lagom');
      verify(mockRepository.searchGrinders('Lagom')).called(1);
      verifyNever(mockRepository.getAllGrinders());
    });

    test('saveBean on rename propagates and updates bean', () async {
      final initial = Bean(
        id: 3,
        name: 'Old Bean',
        addedAt: DateTime(2026, 1, 1),
        useCount: 7,
      );

      await container
          .read(inventoryControllerProvider.notifier)
          .saveBean(initial: initial, name: 'New Bean', roaster: 'Roaster A');

      verify(
        mockRepository.renameBeanAndPropagate(beanId: 3, newName: 'New Bean'),
      ).called(1);
      final updated =
          verify(mockRepository.updateBean(captureAny)).captured.single as Bean;
      expect(updated.name, 'New Bean');
      expect(updated.roaster, 'Roaster A');
    });

    test('saveGrinder creates grinder with fixed grinder category', () async {
      when(
        mockRepository.searchGrinders(any),
      ).thenAnswer((_) async => const []);

      await container
          .read(inventoryControllerProvider.notifier)
          .saveGrinder(
            name: 'ZP6',
            minClick: 8,
            maxClick: 68,
            clickStep: 0.5,
            clickUnit: 'steps',
          );

      final created =
          verify(mockRepository.createEquipment(captureAny)).captured.single
              as Equipment;
      expect(created.name, 'ZP6');
      expect(created.category, 'grinder');
      expect(created.isGrinder, isTrue);
      expect(created.grindMinClick, 8);
      expect(created.grindMaxClick, 68);
      expect(created.grindClickStep, 0.5);
      expect(created.grindClickUnit, 'steps');
    });
  });
}
