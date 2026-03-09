import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_coffee/features/history/history_providers.dart';
import 'package:one_coffee/features/history/presentation/pages/brew_detail_page.dart';

import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  group('BrewDetailPage widget', () {
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

    Widget createWidget({required int brewId, VoidCallback? onBrewAgain}) {
      return ProviderScope(
        overrides: [
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
        ],
        child: MaterialApp(
          home: BrewDetailPage(brewId: brewId, onBrewAgain: onBrewAgain),
        ),
      );
    }

    testWidgets('renders full detail and triggers brew again callback', (
      tester,
    ) async {
      final detail = TestFixtures.brewDetail(
        id: 7,
        beanName: 'Panama Geisha',
        quickScore: 5,
        emoji: '😍',
      );
      when(
        mockHistoryRepo.getBrewDetailById(7),
      ).thenAnswer((_) async => detail);

      var brewAgainTapped = false;
      await tester.pumpWidget(
        createWidget(
          brewId: 7,
          onBrewAgain: () {
            brewAgainTapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Brew Detail'), findsOneWidget);
      expect(find.text('Panama Geisha'), findsOneWidget);
      expect(find.textContaining('5/5'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('brew-detail-brew-again')),
      );
      await tester.tap(find.byKey(const Key('brew-detail-brew-again')));
      await tester.pumpAndSettle();

      expect(brewAgainTapped, isTrue);
    });

    testWidgets('shows placeholders instead of null text', (tester) async {
      final detail =
          TestFixtures.brewDetail(
            id: 8,
            beanName: 'Kenya AA',
            roaster: null,
            origin: null,
            roastLevel: null,
            grindMode: GrindMode.simple,
            grindClickValue: null,
            grindSimpleLabel: null,
            quickScore: null,
            emoji: null,
          ).copyWith(
            waterTempC: null,
            bloomTimeS: null,
            pourMethod: null,
            waterType: null,
            roomTempC: null,
            acidity: null,
            sweetness: null,
            bitterness: null,
            body: null,
            flavorNotes: null,
            notes: null,
          );
      when(
        mockHistoryRepo.getBrewDetailById(8),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 8));
      await tester.pumpAndSettle();

      expect(find.text('--'), findsWidgets);
      expect(find.text('Unrated'), findsOneWidget);
      expect(find.text('null'), findsNothing);
    });

    testWidgets('shows retry and reloads on failure', (tester) async {
      var attempts = 0;
      when(mockHistoryRepo.getBrewDetailById(9)).thenAnswer((_) async {
        attempts += 1;
        if (attempts == 1) {
          throw Exception('db unavailable');
        }
        return TestFixtures.brewDetail(id: 9, beanName: 'Ethiopia Guji');
      });

      await tester.pumpWidget(createWidget(brewId: 9));
      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to load brew detail'), findsOneWidget);
      expect(find.byKey(const Key('brew-detail-retry')), findsOneWidget);

      await tester.tap(find.byKey(const Key('brew-detail-retry')));
      await tester.pumpAndSettle();

      expect(find.text('Ethiopia Guji'), findsOneWidget);
    });
  });
}
