import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/core/database/drift_database.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/history/domain/entities/brew_summary.dart';
import 'package:one_brew/features/history/domain/repositories/history_repository.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_brew/features/history/presentation/pages/history_page.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/rating/rating_providers.dart';
import 'package:one_brew/shared/providers/database_providers.dart';
import 'package:go_router/go_router.dart';

import '../../../../helpers/fake_brew_param_repository.dart';
import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockHistoryRepository mockHistoryRepo;
  late MockBrewRepository mockBrewRepo;
  late MockRatingRepository mockRatingRepo;
  late FakeBrewParamRepository fakeBrewParamRepo;

  final allBrews = <BrewSummary>[
    BrewSummary(
      id: 1,
      brewDate: DateTime(2026, 3, 1, 9, 0),
      beanName: 'Ethiopia Yirgacheffe',
      roaster: 'Roaster A',
      brewDurationS: 180,
      coffeeWeightG: 15,
      waterWeightG: 240,
      quickScore: 4,
      emoji: '🙂',
    ),
    BrewSummary(
      id: 2,
      brewDate: DateTime(2026, 3, 2, 10, 0),
      beanName: 'Colombia Huila',
      roaster: 'Roaster B',
      brewDurationS: 190,
      coffeeWeightG: 16,
      waterWeightG: 250,
      quickScore: 5,
      emoji: '😍',
    ),
  ];

  setUp(() {
    mockHistoryRepo = MockHistoryRepository();
    mockBrewRepo = MockBrewRepository();
    mockRatingRepo = MockRatingRepository();
    fakeBrewParamRepo = FakeBrewParamRepository();

    when(
      mockHistoryRepo.getAllBrewSummaries(),
    ).thenAnswer((_) async => allBrews);
    when(
      mockHistoryRepo.getTopBrews(limit: 5),
    ).thenAnswer((_) async => [allBrews.last, allBrews.first]);
    when(mockHistoryRepo.filterBrewSummaries(any)).thenAnswer((
      invocation,
    ) async {
      final filter = invocation.positionalArguments.first as BrewFilter;
      final bean = filter.beanName?.toLowerCase() ?? '';
      if (bean.contains('colombia')) return [allBrews.last];
      return allBrews;
    });
    when(mockBrewRepo.deleteBrewRecord(any)).thenAnswer((_) async => 1);
    when(mockRatingRepo.getRatingForBrew(any)).thenAnswer((_) async => null);
  });

  Widget createWidget({
    ValueChanged<int>? onOpenDetail,
    OneBrewDatabase? database,
  }) {
    final overrides = [
      brewRepositoryProvider.overrideWithValue(mockBrewRepo),
      historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
      brewParamRepositoryProvider.overrideWithValue(fakeBrewParamRepo),
      ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
    ];
    if (database != null) {
      overrides.add(databaseProvider.overrideWithValue(database));
    }

    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: HistoryPage(onOpenDetail: onOpenDetail)),
    );
  }

  Widget createRouterWidget() {
    final router = GoRouter(
      initialLocation: '/history',
      routes: [
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) => BrewDetailPage(
                brewId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        brewRepositoryProvider.overrideWithValue(mockBrewRepo),
        historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
        brewParamRepositoryProvider.overrideWithValue(fakeBrewParamRepo),
        ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('HistoryPage widget', () {
    testWidgets('renders stats header and brew list', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Brew History'), findsOneWidget);
      expect(find.byKey(const Key('history-stats-header')), findsOneWidget);
      expect(find.text('Top Brews (by rating)'), findsNothing);
      expect(find.text('Brews'), findsOneWidget);
      expect(find.text('Rated'), findsOneWidget);
      expect(find.text('Avg'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('history-record-card-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('history-record-card-2')),
        findsOneWidget,
      );
    });

    testWidgets('applies bean filter and updates list', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final beanInputFinder = find.byKey(
        const Key('history-filter-bean-input'),
      );
      expect(beanInputFinder, findsOneWidget);

      await tester.tap(beanInputFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('single-select-add-new')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Colombia');
      await tester.tap(find.text('Use text'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('history-record-card-2')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('history-record-card-1')), findsNothing);
    });

    testWidgets('bean input opens top-5 suggestions on tap', (tester) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      for (var i = 1; i <= 6; i++) {
        await db.insertBean(
          BeansCompanion.insert(
            name: 'History Focus Bean 0$i',
            useCount: drift.Value(i),
          ),
        );
      }

      await tester.pumpWidget(createWidget(database: db));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('history-filter-bean-input')));
      await tester.pumpAndSettle();

      expect(find.text('History Focus Bean 06'), findsOneWidget);
      expect(find.text('History Focus Bean 05'), findsOneWidget);
      expect(find.text('History Focus Bean 04'), findsOneWidget);
      expect(find.text('History Focus Bean 03'), findsOneWidget);
      expect(find.text('History Focus Bean 02'), findsOneWidget);
      expect(find.text('History Focus Bean 01'), findsNothing);
    });

    testWidgets('taps card and requests detail navigation', (tester) async {
      int? openedId;
      await tester.pumpWidget(
        createWidget(
          onOpenDetail: (id) {
            openedId = id;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('history-record-card-1')));
      await tester.pumpAndSettle();

      expect(openedId, 1);
    });

    testWidgets(
      'deleting from detail refreshes history summary and list after returning',
      (tester) async {
        var currentBrews = List<BrewSummary>.from(allBrews);
        when(
          mockHistoryRepo.getAllBrewSummaries(),
        ).thenAnswer((_) async => List<BrewSummary>.from(currentBrews));
        when(
          mockHistoryRepo.getTopBrews(limit: 5),
        ).thenAnswer((_) async => List<BrewSummary>.from(currentBrews));
        when(mockHistoryRepo.filterBrewSummaries(any)).thenAnswer((
          invocation,
        ) async {
          final filter = invocation.positionalArguments.first as BrewFilter;
          if (filter.isEmpty) {
            return List<BrewSummary>.from(currentBrews);
          }
          final bean = filter.beanName?.toLowerCase() ?? '';
          return currentBrews
              .where((brew) => brew.beanName.toLowerCase().contains(bean))
              .toList();
        });
        when(mockHistoryRepo.getBrewDetailById(2)).thenAnswer(
          (_) async => TestFixtures.brewDetail(
            id: 2,
            beanName: 'Colombia Huila',
            quickScore: 5,
            emoji: '😍',
          ),
        );
        when(mockBrewRepo.deleteBrewRecord(2)).thenAnswer((_) async {
          currentBrews = [allBrews.first];
          return 1;
        });

        await tester.pumpWidget(createRouterWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const ValueKey('history-record-card-2')));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('brew-detail-delete-icon-button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        expect(find.byType(HistoryPage), findsOneWidget);
        expect(
          find.byKey(const ValueKey('history-record-card-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('history-record-card-2')),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('history-stats-total')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('history-stats-rated')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
