import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/core/database/drift_database.dart';
import 'package:one_brew/features/history/domain/entities/brew_summary.dart';
import 'package:one_brew/features/history/domain/repositories/history_repository.dart';
import 'package:one_brew/features/history/presentation/pages/history_page.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

import '../../../../helpers/mock_repositories.mocks.dart';

void main() {
  late MockHistoryRepository mockHistoryRepo;

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
  });

  Widget createWidget({
    ValueChanged<int>? onOpenDetail,
    OneBrewDatabase? database,
  }) {
    final overrides = [
      historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
    ];
    if (database != null) {
      overrides.add(databaseProvider.overrideWithValue(database));
    }

    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: HistoryPage(onOpenDetail: onOpenDetail)),
    );
  }

  group('HistoryPage widget', () {
    testWidgets('renders stats header and brew list', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Brew History'), findsOneWidget);
      expect(find.byKey(const Key('history-stats-header')), findsOneWidget);
      expect(find.text('Top Brews (by rating)'), findsOneWidget);
      expect(find.text('Colombia Huila • Rating 5/5'), findsOneWidget);
      expect(find.text('Ethiopia Yirgacheffe • Rating 4/5'), findsOneWidget);
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

      final applyButton = tester.widget<IconButton>(
        find.byKey(const Key('history-filter-apply')),
      );
      expect((applyButton.icon as Icon).icon, Icons.search_rounded);

      await tester.tap(beanInputFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('single-select-add-new')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Colombia');
      await tester.tap(find.text('Use text'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('history-filter-apply')));
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
  });
}
