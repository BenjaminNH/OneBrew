import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/features/brew_logger/brew_logger_providers.dart';
import 'package:one_coffee/features/history/history_providers.dart';
import 'package:one_coffee/features/history/presentation/controllers/brew_detail_controller.dart';

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
  });
}
