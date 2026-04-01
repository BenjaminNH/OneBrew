import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/core/database/drift_database.dart';
import 'package:one_brew/core/widgets/app_top_toast.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/history/domain/entities/brew_summary.dart';
import 'package:one_brew/features/history/data/datasources/history_local_datasource.dart';
import 'package:one_brew/features/history/domain/repositories/history_repository.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_brew/features/history/presentation/pages/history_page.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/inventory/domain/entities/bean.dart'
    as domain;
import 'package:one_brew/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:one_brew/features/rating/rating_providers.dart';
import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/l10n/app_localizations.dart';
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
    addTearDown(AppTopToast.dismiss);

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
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocaleOption.supportedLocales,
        locale: const Locale('en'),
        home: HistoryPage(onOpenDetail: onOpenDetail),
      ),
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
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocaleOption.supportedLocales,
        locale: const Locale('en'),
        routerConfig: router,
      ),
    );
  }

  group('HistoryPage widget', () {
    testWidgets('refreshes visible bean metadata after bean update', (
      tester,
    ) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final beanId = await db.insertBean(
        BeansCompanion.insert(
          name: 'Original Bean',
          roaster: const drift.Value('Roaster A'),
        ),
      );
      await db.insertBrewRecord(
        BrewRecordsCompanion.insert(
          brewDate: DateTime(2026, 3, 10, 9, 0),
          beanName: 'Original Bean',
          beanId: drift.Value(beanId),
          grindMode: const drift.Value('simple'),
          grindSimpleLabel: const drift.Value('Medium'),
          coffeeWeightG: 15,
          waterWeightG: 225,
          brewDurationS: 180,
          createdAt: drift.Value(DateTime(2026, 3, 10, 9, 0)),
          updatedAt: drift.Value(DateTime(2026, 3, 10, 9, 0)),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocaleOption.supportedLocales,
            locale: Locale('en'),
            home: HistoryPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Original Bean'), findsOneWidget);
      expect(find.textContaining('Roaster: Roaster A'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(HistoryPage)),
      );
      final existingBean = await db.getBeanById(beanId);
      expect(existingBean, isNotNull);

      await container
          .read(inventoryControllerProvider.notifier)
          .saveBean(
            initial: domain.Bean(
              id: existingBean!.id,
              name: existingBean.name,
              roaster: existingBean.roaster,
              origin: existingBean.origin,
              roastLevel: existingBean.roastLevel,
              addedAt: existingBean.addedAt,
              useCount: existingBean.useCount,
            ),
            name: 'Renamed Bean',
            roaster: 'Roaster B',
          );
      await tester.pumpAndSettle();

      expect(find.text('Renamed Bean'), findsOneWidget);
      expect(find.textContaining('Roaster: Roaster B'), findsOneWidget);
      expect(find.text('Original Bean'), findsNothing);
    });

    testWidgets('links unassigned brew records after bean metadata is saved', (
      tester,
    ) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final brewId = await db.insertBrewRecord(
        BrewRecordsCompanion.insert(
          brewDate: DateTime(2026, 3, 11, 9, 0),
          beanName: 'Ghost Bean',
          grindMode: const drift.Value('simple'),
          grindSimpleLabel: const drift.Value('Medium'),
          coffeeWeightG: 15,
          waterWeightG: 225,
          brewDurationS: 180,
          createdAt: drift.Value(DateTime(2026, 3, 11, 9, 0)),
          updatedAt: drift.Value(DateTime(2026, 3, 11, 9, 0)),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocaleOption.supportedLocales,
            locale: Locale('en'),
            home: HistoryPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ghost Bean'), findsOneWidget);
      expect(find.textContaining('Roast Level:'), findsNothing);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(HistoryPage)),
      );
      await container
          .read(inventoryControllerProvider.notifier)
          .saveBean(name: 'Ghost Bean', roastLevel: 'Light Roast');
      await tester.pumpAndSettle();

      final linkedRecord = await db.getBrewRecordById(brewId);
      expect(linkedRecord?.beanId, isNotNull);

      final detail = await HistoryLocalDatasource(db).getBrewDetailById(brewId);
      expect(detail?.roastLevel, 'Light Roast');
    });

    testWidgets('renders stats header and brew list', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('History'), findsOneWidget);
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
        expect(find.byKey(const Key('app-top-toast')), findsOneWidget);
        AppTopToast.dismiss();
      },
    );

    testWidgets('saving rating in detail refreshes stats after returning', (
      tester,
    ) async {
      final unrated = allBrews.first.copyWith(quickScore: null, emoji: null);
      final rated = allBrews.last;
      var currentBrews = <BrewSummary>[unrated, rated];
      var detail = TestFixtures.brewDetail(
        id: unrated.id,
        beanName: unrated.beanName,
        quickScore: null,
        emoji: null,
      );

      when(
        mockHistoryRepo.getAllBrewSummaries(),
      ).thenAnswer((_) async => List<BrewSummary>.from(currentBrews));
      when(
        mockHistoryRepo.getTopBrews(limit: 5),
      ).thenAnswer((_) async => List<BrewSummary>.from(currentBrews));
      when(mockHistoryRepo.filterBrewSummaries(any)).thenAnswer((invocation) {
        final filter = invocation.positionalArguments.first as BrewFilter;
        if (filter.isEmpty) {
          return Future.value(List<BrewSummary>.from(currentBrews));
        }
        final bean = filter.beanName?.toLowerCase() ?? '';
        return Future.value(
          currentBrews
              .where((brew) => brew.beanName.toLowerCase().contains(bean))
              .toList(),
        );
      });
      when(
        mockHistoryRepo.getBrewDetailById(unrated.id),
      ).thenAnswer((_) async => detail);
      when(mockRatingRepo.createRating(any)).thenAnswer((_) async {
        currentBrews = [unrated.copyWith(quickScore: 3), rated];
        detail = detail.copyWith(quickScore: 3);
        return 99;
      });

      await tester.pumpWidget(createRouterWidget());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('history-stats-rated')),
          matching: find.text('1'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('history-stats-average')),
          matching: find.text('5.0'),
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(ValueKey('history-record-card-${unrated.id}')),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('brew-detail-edit-rating')),
      );
      await tester.tap(find.byKey(const Key('brew-detail-edit-rating')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Save rating'));
      await tester.tap(find.text('Save rating'));
      await tester.pumpAndSettle();

      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle();

      expect(find.byType(HistoryPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const Key('history-stats-rated')),
          matching: find.text('2'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('history-stats-average')),
          matching: find.text('4.0'),
        ),
        findsOneWidget,
      );
      AppTopToast.dismiss();
    });

    testWidgets('editing existing rating refreshes stats after returning', (
      tester,
    ) async {
      var currentBrews = List<BrewSummary>.from(allBrews);
      var detail = TestFixtures.brewDetail(
        id: allBrews.first.id,
        beanName: allBrews.first.beanName,
        quickScore: allBrews.first.quickScore,
        emoji: allBrews.first.emoji,
      );
      var existingRating = TestFixtures.quickRating(
        id: 7,
        brewRecordId: allBrews.first.id,
        quickScore: 4,
        emoji: allBrews.first.emoji ?? '🙂',
      );

      when(
        mockHistoryRepo.getAllBrewSummaries(),
      ).thenAnswer((_) async => List<BrewSummary>.from(currentBrews));
      when(
        mockHistoryRepo.getTopBrews(limit: 5),
      ).thenAnswer((_) async => List<BrewSummary>.from(currentBrews));
      when(mockHistoryRepo.filterBrewSummaries(any)).thenAnswer((invocation) {
        final filter = invocation.positionalArguments.first as BrewFilter;
        if (filter.isEmpty) {
          return Future.value(List<BrewSummary>.from(currentBrews));
        }
        final bean = filter.beanName?.toLowerCase() ?? '';
        return Future.value(
          currentBrews
              .where((brew) => brew.beanName.toLowerCase().contains(bean))
              .toList(),
        );
      });
      when(
        mockHistoryRepo.getBrewDetailById(allBrews.first.id),
      ).thenAnswer((_) async => detail);
      when(
        mockRatingRepo.getRatingForBrew(allBrews.first.id),
      ).thenAnswer((_) async => existingRating);
      when(mockRatingRepo.updateRating(any)).thenAnswer((invocation) async {
        final updated = invocation.positionalArguments.first;
        final updatedScore = updated.quickScore as int?;
        currentBrews = [
          allBrews.first.copyWith(quickScore: updatedScore),
          allBrews.last,
        ];
        detail = detail.copyWith(quickScore: updatedScore);
        existingRating = existingRating.copyWith(quickScore: updatedScore);
        return true;
      });

      await tester.pumpWidget(createRouterWidget());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('history-stats-average')),
          matching: find.text('4.5'),
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(ValueKey('history-record-card-${allBrews.first.id}')),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('brew-detail-edit-rating')),
      );
      await tester.tap(find.byKey(const Key('brew-detail-edit-rating')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('quick-rating-star-2')));
      await tester.tap(find.byKey(const Key('quick-rating-star-2')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Save rating'));
      await tester.tap(find.text('Save rating'));
      await tester.pumpAndSettle();

      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle();

      expect(find.byType(HistoryPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const Key('history-stats-average')),
          matching: find.text('3.5'),
        ),
        findsOneWidget,
      );
      verify(mockRatingRepo.updateRating(any)).called(1);
      verifyNever(mockRatingRepo.createRating(any));
      AppTopToast.dismiss();
    });
  });
}
