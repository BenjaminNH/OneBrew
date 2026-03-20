import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_value.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_brew/features/rating/rating_providers.dart';

import '../../../../helpers/fake_brew_param_repository.dart';
import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  group('BrewDetailPage widget', () {
    late MockHistoryRepository mockHistoryRepo;
    late MockBrewRepository mockBrewRepo;
    late MockRatingRepository mockRatingRepo;
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

      mockBrewRepo = MockBrewRepository();
      when(mockBrewRepo.deleteBrewRecord(any)).thenAnswer((_) async => 1);

      mockRatingRepo = MockRatingRepository();
      when(mockRatingRepo.getRatingForBrew(any)).thenAnswer((_) async => null);
      when(mockRatingRepo.createRating(any)).thenAnswer((_) async => 1);
      when(mockRatingRepo.updateRating(any)).thenAnswer((_) async => true);

      fakeBrewParamRepo = FakeBrewParamRepository();
    });

    Widget createWidget({
      required int brewId,
      VoidCallback? onBrewAgain,
      VoidCallback? onDelete,
    }) {
      return ProviderScope(
        overrides: [
          brewRepositoryProvider.overrideWithValue(mockBrewRepo),
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          brewParamRepositoryProvider.overrideWithValue(fakeBrewParamRepo),
          ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
        ],
        child: MaterialApp(
          home: BrewDetailPage(
            brewId: brewId,
            onBrewAgain: onBrewAgain,
            onDelete: onDelete,
          ),
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

    testWidgets('shows recorded-only rows without placeholder noise', (
      tester,
    ) async {
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

      expect(find.text('--'), findsNothing);
      expect(find.text('No rating recorded yet.'), findsOneWidget);
      expect(find.byKey(const Key('brew-detail-edit-rating')), findsOneWidget);
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

    testWidgets(
      'renders recorded params and keeps grind section when present',
      (tester) async {
        final detail = TestFixtures.brewDetail(
          id: 12,
          beanName: 'Honduras',
          grindMode: GrindMode.simple,
          grindSimpleLabel: 'Medium Fine',
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
        expect(find.text('Grind'), findsOneWidget);
        expect(find.text('Medium Fine'), findsOneWidget);
      },
    );

    testWidgets(
      'renames basic time label and hides duplicate duration params from recorded list',
      (tester) async {
        final detail = TestFixtures.brewDetail(id: 14, beanName: 'Peru');
        when(
          mockHistoryRepo.getBrewDetailById(14),
        ).thenAnswer((_) async => detail);

        final paramRepo = FakeBrewParamRepository(
          definitions: {
            BrewMethod.pourOver: [
              const BrewParamDefinition(
                id: 21,
                method: BrewMethod.pourOver,
                name: 'Brew Time',
                type: ParamType.number,
                unit: 's',
                isSystem: true,
                sortOrder: 1,
              ),
              const BrewParamDefinition(
                id: 22,
                method: BrewMethod.pourOver,
                name: 'Extraction Time',
                type: ParamType.number,
                unit: 's',
                isSystem: true,
                sortOrder: 2,
              ),
              const BrewParamDefinition(
                id: 23,
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
            14: [
              const BrewParamValue(
                id: 1,
                brewRecordId: 14,
                paramId: 21,
                valueNumber: 172,
              ),
              const BrewParamValue(
                id: 2,
                brewRecordId: 14,
                paramId: 22,
                valueNumber: 30,
              ),
              const BrewParamValue(
                id: 3,
                brewRecordId: 14,
                paramId: 23,
                valueNumber: 94,
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
            child: const MaterialApp(home: BrewDetailPage(brewId: 14)),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Brewed At'), findsOneWidget);
        expect(find.text('Duration'), findsOneWidget);
        expect(find.text('Brew Time'), findsNothing);
        expect(find.text('Extraction Time'), findsNothing);
        expect(find.text('94 °C'), findsOneWidget);
      },
    );

    testWidgets('opens rating sheet from history supplement entry', (
      tester,
    ) async {
      final detail = TestFixtures.brewDetail(
        id: 15,
        beanName: 'Colombia',
        quickScore: null,
        emoji: null,
      );
      when(
        mockHistoryRepo.getBrewDetailById(15),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 15));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('brew-detail-edit-rating')),
      );
      await tester.tap(find.byKey(const Key('brew-detail-edit-rating')));
      await tester.pumpAndSettle();

      expect(find.text('Rate this brew'), findsOneWidget);
      expect(find.text('Skip for now'), findsOneWidget);
    });

    testWidgets('renders top delete and bottom actions', (tester) async {
      final detail = TestFixtures.brewDetail(id: 16, beanName: 'Costa Rica');
      when(
        mockHistoryRepo.getBrewDetailById(16),
      ).thenAnswer((_) async => detail);

      var deleteTapped = false;
      await tester.pumpWidget(
        createWidget(
          brewId: 16,
          onDelete: () {
            deleteTapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('brew-detail-delete-icon-button')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('brew-detail-brew-again')), findsOneWidget);
      expect(find.byKey(const Key('brew-detail-share-button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('brew-detail-delete-icon-button')));
      await tester.pumpAndSettle();

      expect(deleteTapped, isTrue);
    });

    testWidgets('share action shows placeholder', (tester) async {
      final detail = TestFixtures.brewDetail(id: 17, beanName: 'Brazil');
      when(
        mockHistoryRepo.getBrewDetailById(17),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 17));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('brew-detail-share-button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      expect(find.text('Share is coming soon.'), findsOneWidget);
    });
  });
}
