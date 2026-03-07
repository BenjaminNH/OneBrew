import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/features/inventory/domain/entities/equipment.dart';
import 'package:one_coffee/features/inventory/domain/usecases/create_bean.dart';
import 'package:one_coffee/features/inventory/domain/usecases/create_equipment.dart';
import 'package:one_coffee/features/inventory/domain/usecases/get_suggestions.dart';

import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockInventoryRepository mockRepo;
  late GetSuggestions getSuggestions;
  late CreateBean createBean;
  late CreateEquipment createEquipment;

  setUp(() {
    mockRepo = MockInventoryRepository();
    getSuggestions = GetSuggestions(mockRepo);
    createBean = CreateBean(mockRepo);
    createEquipment = CreateEquipment(mockRepo);
  });

  // ─── GetSuggestions ─────────────────────────────────────────────────────

  group('GetSuggestions.beans', () {
    final sampleBeans = [
      TestFixtures.bean(id: 1, name: 'Ethiopia Yirgacheffe', useCount: 5),
      TestFixtures.bean(id: 2, name: 'Colombia Huila', useCount: 2),
    ];

    test('returns all beans when query is empty', () async {
      when(mockRepo.getAllBeans()).thenAnswer((_) async => sampleBeans);

      final result = await getSuggestions.beans('');

      expect(result, sampleBeans);
      verify(mockRepo.getAllBeans()).called(1);
      verifyNever(mockRepo.searchBeans(any));
    });

    test('delegates to searchBeans when query is non-empty', () async {
      when(
        mockRepo.searchBeans('ethi'),
      ).thenAnswer((_) async => [sampleBeans.first]);

      final result = await getSuggestions.beans('ethi');

      expect(result.length, 1);
      expect(result.first.name, 'Ethiopia Yirgacheffe');
      verify(mockRepo.searchBeans('ethi')).called(1);
      verifyNever(mockRepo.getAllBeans());
    });

    test('returns empty list when no beans match query', () async {
      when(mockRepo.searchBeans('xyz')).thenAnswer((_) async => []);

      final result = await getSuggestions.beans('xyz');

      expect(result, isEmpty);
    });
  });

  group('GetSuggestions.equipments', () {
    final sampleEquipments = [
      TestFixtures.grinder(id: 1, name: 'Comandante C40', useCount: 4),
      TestFixtures.dripper(id: 2, name: 'V60 02', useCount: 6),
    ];

    test('returns all equipments when query is empty', () async {
      when(
        mockRepo.getAllEquipments(),
      ).thenAnswer((_) async => sampleEquipments);

      final result = await getSuggestions.equipments('');

      expect(result, sampleEquipments);
      verify(mockRepo.getAllEquipments()).called(1);
      verifyNever(mockRepo.searchEquipments(any));
    });

    test('delegates to searchEquipments for non-empty query', () async {
      when(
        mockRepo.searchEquipments('V60'),
      ).thenAnswer((_) async => [sampleEquipments.last]);

      final result = await getSuggestions.equipments('V60');

      expect(result.single.name, 'V60 02');
    });
  });

  // ─── CreateBean ──────────────────────────────────────────────────────────

  group('CreateBean', () {
    test('delegates to repository and returns new id', () async {
      final bean = TestFixtures.bean(id: 0);
      when(mockRepo.createBean(bean)).thenAnswer((_) async => 10);

      final id = await createBean(bean);

      expect(id, 10);
      verify(mockRepo.createBean(bean)).called(1);
    });
  });

  // ─── CreateEquipment ─────────────────────────────────────────────────────

  group('CreateEquipment', () {
    test('creates a grinder and returns its id', () async {
      final grinder = TestFixtures.grinder(id: 0);
      when(mockRepo.createEquipment(grinder)).thenAnswer((_) async => 5);

      final id = await createEquipment(grinder);

      expect(id, 5);
      verify(mockRepo.createEquipment(grinder)).called(1);
    });

    test('creates a non-grinder equipment', () async {
      final dripper = TestFixtures.dripper(id: 0);
      when(mockRepo.createEquipment(dripper)).thenAnswer((_) async => 6);

      final id = await createEquipment(dripper);

      expect(id, 6);
      final captured =
          verify(mockRepo.createEquipment(captureAny)).captured.single
              as Equipment;
      expect(captured.isGrinder, isFalse);
    });
  });
}
