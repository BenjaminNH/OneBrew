import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/features/history/domain/repositories/history_repository.dart';
import 'package:one_brew/features/history/domain/usecases/filter_brews.dart';
import 'package:one_brew/features/history/domain/usecases/get_brew_detail.dart';
import 'package:one_brew/features/history/domain/usecases/get_brew_history.dart';
import 'package:one_brew/features/history/domain/usecases/get_top_brews.dart';

import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockHistoryRepository mockRepo;
  late GetBrewHistory getBrewHistory;
  late FilterBrews filterBrews;
  late GetTopBrews getTopBrews;
  late GetBrewDetail getBrewDetail;

  setUp(() {
    mockRepo = MockHistoryRepository();
    getBrewHistory = GetBrewHistory(mockRepo);
    filterBrews = FilterBrews(mockRepo);
    getTopBrews = GetTopBrews(mockRepo);
    getBrewDetail = GetBrewDetail(mockRepo);
  });

  final summaries = [
    TestFixtures.brewSummary(
      id: 1,
      beanName: 'Ethiopia Yirgacheffe',
      quickScore: 4,
    ),
    TestFixtures.brewSummary(id: 2, beanName: 'Colombia Huila', quickScore: 5),
  ];

  // ─── GetBrewHistory ──────────────────────────────────────────────────────

  group('GetBrewHistory', () {
    test('returns all summaries from repository', () async {
      when(mockRepo.getAllBrewSummaries()).thenAnswer((_) async => summaries);

      final result = await getBrewHistory();

      expect(result, summaries);
      verify(mockRepo.getAllBrewSummaries()).called(1);
    });

    test('returns empty list when there are no brews', () async {
      when(mockRepo.getAllBrewSummaries()).thenAnswer((_) async => []);

      final result = await getBrewHistory();

      expect(result, isEmpty);
    });
  });

  // ─── FilterBrews ─────────────────────────────────────────────────────────

  group('FilterBrews', () {
    test('returns all summaries when filter is empty', () async {
      const emptyFilter = BrewFilter();
      when(mockRepo.getAllBrewSummaries()).thenAnswer((_) async => summaries);

      final result = await filterBrews(emptyFilter);

      expect(result, summaries);
      verify(mockRepo.getAllBrewSummaries()).called(1);
      verifyNever(mockRepo.filterBrewSummaries(any));
    });

    test('delegates to filterBrewSummaries when filter is set', () async {
      const filter = BrewFilter(beanName: 'Colombia');
      when(
        mockRepo.filterBrewSummaries(filter),
      ).thenAnswer((_) async => [summaries.last]);

      final result = await filterBrews(filter);

      expect(result.length, 1);
      expect(result.first.beanName, 'Colombia Huila');
      verify(mockRepo.filterBrewSummaries(filter)).called(1);
      verifyNever(mockRepo.getAllBrewSummaries());
    });

    test('filters by score range', () async {
      const filter = BrewFilter(minScore: 5, maxScore: 5);
      when(
        mockRepo.filterBrewSummaries(filter),
      ).thenAnswer((_) async => [summaries.last]);

      final result = await filterBrews(filter);

      expect(result.single.quickScore, 5);
      verify(mockRepo.filterBrewSummaries(filter)).called(1);
    });

    test('filters by date range', () async {
      final from = DateTime(2024, 1, 1);
      final to = DateTime(2024, 12, 31);
      final filter = BrewFilter(from: from, to: to);
      when(
        mockRepo.filterBrewSummaries(filter),
      ).thenAnswer((_) async => summaries);

      final result = await filterBrews(filter);

      expect(result.length, 2);
      verify(mockRepo.filterBrewSummaries(filter)).called(1);
    });
  });

  // ─── GetTopBrews ─────────────────────────────────────────────────────────

  group('GetTopBrews', () {
    test('returns top brews with default limit of 10', () async {
      when(mockRepo.getTopBrews(limit: 10)).thenAnswer((_) async => summaries);

      final result = await getTopBrews();

      expect(result, summaries);
      verify(mockRepo.getTopBrews(limit: 10)).called(1);
    });

    test('passes custom limit to repository', () async {
      when(
        mockRepo.getTopBrews(limit: 3),
      ).thenAnswer((_) async => [summaries.last]);

      final result = await getTopBrews(limit: 3);

      expect(result.length, 1);
      verify(mockRepo.getTopBrews(limit: 3)).called(1);
    });
  });

  // ─── GetBrewDetail ──────────────────────────────────────────────────────

  group('GetBrewDetail', () {
    test('returns detail when repository has the brew', () async {
      final detail = TestFixtures.brewDetail(id: 42, beanName: 'Panama Geisha');
      when(mockRepo.getBrewDetailById(42)).thenAnswer((_) async => detail);

      final result = await getBrewDetail(42);

      expect(result, detail);
      verify(mockRepo.getBrewDetailById(42)).called(1);
    });

    test('returns null when brew does not exist', () async {
      when(mockRepo.getBrewDetailById(999)).thenAnswer((_) async => null);

      final result = await getBrewDetail(999);

      expect(result, isNull);
      verify(mockRepo.getBrewDetailById(999)).called(1);
    });
  });
}
