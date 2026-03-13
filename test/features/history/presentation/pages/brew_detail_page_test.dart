import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_value.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';

import '../../../../helpers/fake_brew_param_repository.dart';
import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  group('BrewDetailPage widget', () {
    late MockHistoryRepository mockHistoryRepo;
    late FakeBrewParamRepository fakeBrewParamRepo;

    setUp(() {
      mockHistoryRepo = MockHistoryRepository();
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async => []);
      when(
        mockHistoryRepo.filterBrewSummaries(any),
      ).thenAnswer((_) async => []);
      when(
        mockHistoryRepo.getTopBrews(limit: anyNamed('limit')),
      ).thenAnswer((_) async => []);

      fakeBrewParamRepo = FakeBrewParamRepository();
    });

    Widget createWidget({required int brewId, VoidCallback? onBrewAgain}) {
      return ProviderScope(
        overrides: [
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          brewParamRepositoryProvider.overrideWithValue(fakeBrewParamRepo),
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

    testWidgets('renders recorded param entries when available', (tester) async {
      final detail = TestFixtures.brewDetail(
        id: 12,
        beanName: 'Honduras',
      );
      when(
        mockHistoryRepo.getBrewDetailById(12),
      ).thenAnswer((_) async => detail);

      final paramRepo = FakeBrewParamRepository(
        definitions: {
          BrewMethod.pourOver: [
            const BrewParamDefinition(
              id: 10,
              method: BrewMethod.pourOver,
              name: 'Water Temp',
              type: ParamType.number,
              unit: '°C',
              isSystem: true,
              sortOrder: 1,
            ),
            const BrewParamDefinition(
              id: 11,
              method: BrewMethod.pourOver,
              name: 'Agitation',
              type: ParamType.text,
              unit: null,
              isSystem: true,
              sortOrder: 2,
            ),
          ],
        },
        valuesByBrew: {
          12: [
            const BrewParamValue(
              id: 1,
              brewRecordId: 12,
              paramId: 10,
              valueNumber: 93,
            ),
            const BrewParamValue(
              id: 2,
              brewRecordId: 12,
              paramId: 11,
              valueText: 'Swirl',
            ),
          ],
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
            brewParamRepositoryProvider.overrideWithValue(paramRepo),
          ],
          child: const MaterialApp(home: BrewDetailPage(brewId: 12)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recorded Params'), findsOneWidget);
      expect(find.text('93 °C'), findsOneWidget);
      expect(find.text('Swirl'), findsOneWidget);
    });
  });
}
