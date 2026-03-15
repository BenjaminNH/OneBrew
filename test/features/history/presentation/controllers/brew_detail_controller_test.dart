import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_value.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/history/presentation/controllers/brew_detail_controller.dart';

import '../../../../helpers/fake_brew_param_repository.dart';
import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  group('BrewDetailController', () {
    late MockHistoryRepository mockHistoryRepo;

    setUp(() {
      mockHistoryRepo = MockHistoryRepository();
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async => []);
      when(
        mockHistoryRepo.filterBrewSummaries(any),
      ).thenAnswer((_) async => []);
      when(
        mockHistoryRepo.getTopBrews(limit: anyNamed('limit')),
      ).thenAnswer((_) async => []);
    });

    test('loads detail successfully', () async {
      final detail = TestFixtures.brewDetail(id: 3, beanName: 'Kenya AA');
      when(
        mockHistoryRepo.getBrewDetailById(3),
      ).thenAnswer((_) async => detail);

      final container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          brewParamRepositoryProvider.overrideWithValue(
            FakeBrewParamRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(brewDetailControllerProvider(3));
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final state = container.read(brewDetailControllerProvider(3));
      expect(state.isLoading, isFalse);
      expect(state.detail?.beanName, 'Kenya AA');
      expect(state.errorMessage, isNull);
    });

    test('shows not found error when detail is null', () async {
      when(
        mockHistoryRepo.getBrewDetailById(404),
      ).thenAnswer((_) async => null);

      final container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          brewParamRepositoryProvider.overrideWithValue(
            FakeBrewParamRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(brewDetailControllerProvider(404));
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final state = container.read(brewDetailControllerProvider(404));
      expect(state.isLoading, isFalse);
      expect(state.detail, isNull);
      expect(state.errorMessage, 'Brew record not found.');
    });

    test(
      'batches param-definition loading and reuses cached definitions',
      () async {
        final detail = TestFixtures.brewDetail(id: 30, beanName: 'Batch Bean');
        when(
          mockHistoryRepo.getBrewDetailById(30),
        ).thenAnswer((_) async => detail);

        final trackingRepo = _TrackingBrewParamRepository(
          definitions: {
            BrewMethod.pourOver: const [
              BrewParamDefinition(
                id: 301,
                method: BrewMethod.pourOver,
                name: 'Water Temp',
                type: ParamType.number,
                unit: '°C',
                isSystem: true,
                sortOrder: 1,
              ),
            ],
          },
          valuesByBrew: {
            30: const [
              BrewParamValue(
                id: 1,
                brewRecordId: 30,
                paramId: 301,
                valueNumber: 92,
              ),
            ],
          },
        );

        final container = ProviderContainer(
          overrides: [
            historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
            brewParamRepositoryProvider.overrideWithValue(trackingRepo),
          ],
        );
        addTearDown(container.dispose);

        container.read(brewDetailControllerProvider(30));
        await Future<void>.delayed(const Duration(milliseconds: 1));

        final state = container.read(brewDetailControllerProvider(30));
        expect(state.paramEntries, hasLength(1));
        expect(trackingRepo.getParamDefinitionsCalls, BrewMethod.values.length);
        expect(trackingRepo.getParamDefinitionByIdCalls, 0);

        await container.read(brewDetailControllerProvider(30).notifier).load();
        expect(trackingRepo.getParamDefinitionsCalls, BrewMethod.values.length);
        expect(trackingRepo.getParamDefinitionByIdCalls, 0);
      },
    );

    test('filters duplicate duration semantics from recorded params', () async {
      final detail = TestFixtures.brewDetail(id: 31, beanName: 'Dedup Bean');
      when(
        mockHistoryRepo.getBrewDetailById(31),
      ).thenAnswer((_) async => detail);

      final repo = FakeBrewParamRepository(
        definitions: {
          BrewMethod.pourOver: const [
            BrewParamDefinition(
              id: 401,
              method: BrewMethod.pourOver,
              name: 'Brew Time',
              type: ParamType.number,
              unit: 's',
              isSystem: true,
              sortOrder: 1,
            ),
            BrewParamDefinition(
              id: 402,
              method: BrewMethod.pourOver,
              name: 'Extraction-Time',
              type: ParamType.number,
              unit: 's',
              isSystem: true,
              sortOrder: 2,
            ),
            BrewParamDefinition(
              id: 403,
              method: BrewMethod.pourOver,
              name: 'Water Temp',
              type: ParamType.number,
              unit: '°C',
              isSystem: true,
              sortOrder: 3,
            ),
          ],
        },
        valuesByBrew: {
          31: const [
            BrewParamValue(
              id: 1,
              brewRecordId: 31,
              paramId: 401,
              valueNumber: 180,
            ),
            BrewParamValue(
              id: 2,
              brewRecordId: 31,
              paramId: 402,
              valueNumber: 28,
            ),
            BrewParamValue(
              id: 3,
              brewRecordId: 31,
              paramId: 403,
              valueNumber: 93,
            ),
          ],
        },
      );

      final container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          brewParamRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      container.read(brewDetailControllerProvider(31));
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final state = container.read(brewDetailControllerProvider(31));
      expect(
        state.paramEntries.map((entry) => entry.name),
        equals(['Water Temp']),
      );
    });
  });
}

class _TrackingBrewParamRepository extends FakeBrewParamRepository {
  _TrackingBrewParamRepository({super.definitions, super.valuesByBrew});

  int getParamDefinitionsCalls = 0;
  int getParamDefinitionByIdCalls = 0;

  @override
  Future<List<BrewParamDefinition>> getParamDefinitions(
    BrewMethod method,
  ) async {
    getParamDefinitionsCalls += 1;
    return super.getParamDefinitions(method);
  }

  @override
  Future<BrewParamDefinition?> getParamDefinitionById(int id) async {
    getParamDefinitionByIdCalls += 1;
    return super.getParamDefinitionById(id);
  }
}
