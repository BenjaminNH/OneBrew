import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/history/presentation/controllers/brew_detail_controller.dart';
import 'package:one_brew/features/history/presentation/controllers/brew_view_refresher.dart';
import 'package:one_brew/features/history/presentation/controllers/history_controller.dart';

import '../../../../helpers/fake_brew_param_repository.dart';
import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  group('BrewViewRefresher', () {
    late MockHistoryRepository mockHistoryRepo;
    late ProviderContainer container;

    setUp(() {
      mockHistoryRepo = MockHistoryRepository();
      when(
        mockHistoryRepo.filterBrewSummaries(any),
      ).thenAnswer((_) async => const []);
      when(
        mockHistoryRepo.getTopBrews(limit: anyNamed('limit')),
      ).thenAnswer((_) async => const []);

      container = ProviderContainer(
        overrides: [
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          brewParamRepositoryProvider.overrideWithValue(
            FakeBrewParamRepository(),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('refreshHistory invalidates and reloads history state', () async {
      final initialHistory = [
        TestFixtures.brewSummary(
          id: 1,
          beanName: 'Before Refresh',
          quickScore: null,
          emoji: null,
        ),
      ];
      final refreshedHistory = [
        TestFixtures.brewSummary(
          id: 2,
          beanName: 'After Refresh',
          quickScore: 3,
          emoji: '🙂',
        ),
      ];
      var historyLoadCount = 0;
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async {
        historyLoadCount += 1;
        return historyLoadCount == 1 ? initialHistory : refreshedHistory;
      });

      final historySubscription = container.listen<HistoryState>(
        historyControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(historySubscription.close);

      await Future<void>.delayed(const Duration(milliseconds: 1));
      expect(
        container.read(historyControllerProvider).visibleBrews.single.beanName,
        'Before Refresh',
      );

      container.read(brewViewRefresherProvider).refreshHistory();
      await Future<void>.delayed(const Duration(milliseconds: 1));

      expect(historyLoadCount, 2);
      expect(
        container.read(historyControllerProvider).visibleBrews.single.beanName,
        'After Refresh',
      );
    });

    test('refreshHistoryAndDetails reloads both history and detail', () async {
      final initialHistory = [
        TestFixtures.brewSummary(
          id: 7,
          beanName: 'History Before',
          quickScore: null,
          emoji: null,
        ),
      ];
      final refreshedHistory = [
        TestFixtures.brewSummary(
          id: 7,
          beanName: 'History After',
          quickScore: 5,
          emoji: '😍',
        ),
      ];
      var historyLoadCount = 0;
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async {
        historyLoadCount += 1;
        return historyLoadCount == 1 ? initialHistory : refreshedHistory;
      });

      final initialDetail = TestFixtures.brewDetail(
        id: 7,
        beanName: 'Detail Before',
      );
      final refreshedDetail = initialDetail.copyWith(beanName: 'Detail After');
      var detailLoadCount = 0;
      when(mockHistoryRepo.getBrewDetailById(7)).thenAnswer((_) async {
        detailLoadCount += 1;
        return detailLoadCount == 1 ? initialDetail : refreshedDetail;
      });

      final historySubscription = container.listen<HistoryState>(
        historyControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      final detailSubscription = container.listen<BrewDetailState>(
        brewDetailControllerProvider(7),
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(historySubscription.close);
      addTearDown(detailSubscription.close);

      await Future<void>.delayed(const Duration(milliseconds: 1));
      expect(
        container.read(historyControllerProvider).visibleBrews.single.beanName,
        'History Before',
      );
      expect(
        container.read(brewDetailControllerProvider(7)).detail?.beanName,
        'Detail Before',
      );

      container.read(brewViewRefresherProvider).refreshHistoryAndDetails();
      await Future<void>.delayed(const Duration(milliseconds: 1));

      expect(historyLoadCount, 2);
      expect(detailLoadCount, 2);
      expect(
        container.read(historyControllerProvider).visibleBrews.single.beanName,
        'History After',
      );
      expect(
        container.read(brewDetailControllerProvider(7)).detail?.beanName,
        'Detail After',
      );
    });
  });
}
