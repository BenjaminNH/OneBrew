import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/core/database/drift_database.dart'
    show OneBrewDatabase, EquipmentsCompanion, BrewRecordsCompanion;
import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/core/widgets/app_top_toast.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_key.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_value.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/history/presentation/controllers/history_controller.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_brew/features/inventory/domain/entities/equipment.dart'
    as domain;
import 'package:one_brew/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:one_brew/features/rating/rating_providers.dart';
import 'package:one_brew/l10n/app_localizations.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

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
      addTearDown(AppTopToast.dismiss);

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
      Locale locale = const Locale('en'),
    }) {
      return ProviderScope(
        overrides: [
          brewRepositoryProvider.overrideWithValue(mockBrewRepo),
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          brewParamRepositoryProvider.overrideWithValue(fakeBrewParamRepo),
          ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
        ],
        child: MaterialApp(
          locale: locale,
          supportedLocales: AppLocaleOption.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
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
            child: const MaterialApp(
              locale: Locale('en'),
              supportedLocales: AppLocaleOption.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: BrewDetailPage(brewId: 12),
            ),
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

    testWidgets('localizes simple grind label in zh detail and share preview', (
      tester,
    ) async {
      final detail = TestFixtures.brewDetail(
        id: 120,
        beanName: 'Yunnan',
        grindMode: GrindMode.simple,
        grindSimpleLabel: 'Medium Fine',
      );
      when(
        mockHistoryRepo.getBrewDetailById(120),
      ).thenAnswer((_) async => detail);

      final paramRepo = FakeBrewParamRepository(
        definitions: {
          BrewMethod.pourOver: [
            const BrewParamDefinition(
              id: 1201,
              method: BrewMethod.pourOver,
              paramKey: BrewParamKeys.grindSize,
              name: 'Grind Size',
              type: ParamType.text,
              isSystem: true,
              sortOrder: 1,
            ),
          ],
        },
        valuesByBrew: {
          120: const [
            BrewParamValue(
              id: 1,
              brewRecordId: 120,
              paramId: 1201,
              valueText: 'Medium Fine',
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
          child: const MaterialApp(
            locale: Locale('zh', 'Hans'),
            supportedLocales: AppLocaleOption.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: BrewDetailPage(brewId: 120),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('中细'), findsWidgets);
      expect(find.text('Medium Fine'), findsNothing);

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('share-preview-bottom-sheet')),
        findsOneWidget,
      );
      expect(find.text('中细'), findsWidgets);
      expect(find.text('Medium Fine'), findsNothing);
    });

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
            child: const MaterialApp(
              locale: Locale('en'),
              supportedLocales: AppLocaleOption.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: BrewDetailPage(brewId: 14),
            ),
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

    testWidgets('share action opens share preview bottom sheet', (
      tester,
    ) async {
      final detail =
          TestFixtures.brewDetail(
            id: 17,
            beanName: 'Brazil Cerrado',
            roaster: 'Atelier Roast',
            quickScore: 5,
            emoji: '😍',
          ).copyWith(
            acidity: null,
            sweetness: null,
            bitterness: null,
            body: null,
            flavorNotes: 'jasmine, peach, black tea',
          );
      when(
        mockHistoryRepo.getBrewDetailById(17),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 17));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('brew-detail-share-button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('share-preview-bottom-sheet')),
        findsOneWidget,
      );
      expect(find.text('Share your brew'), findsOneWidget);
      expect(find.text('Save Poster'), findsOneWidget);
      expect(find.text('BRAZIL CERRADO'), findsNothing);
      expect(find.textContaining('ATELIER ROAST'), findsWidgets);
      expect(find.text('Brazil Cerrado'), findsWidgets);
      expect(find.text('5.0'), findsOneWidget);
      expect(find.text('/5'), findsOneWidget);
      expect(find.text('TIME'), findsOneWidget);
      expect(find.text('POUR'), findsOneWidget);
    });

    testWidgets('share preview renders detailed rating poster variant', (
      tester,
    ) async {
      final detail =
          TestFixtures.brewDetail(
            id: 18,
            beanName: 'Panama Geisha',
            roaster: 'Seesaw Coffee',
          ).copyWith(
            flavorNotes: 'peach, nutty, black tea',
            acidity: 4.5,
            sweetness: 4.0,
            bitterness: 1.5,
            body: 3.0,
          );
      when(
        mockHistoryRepo.getBrewDetailById(18),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 18));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      expect(find.text('Panama Geisha'), findsWidgets);
      expect(find.text('ACID 4.5'), findsOneWidget);
      expect(find.text('SWEET 4.0'), findsOneWidget);
      expect(find.text('BITTER 1.5'), findsOneWidget);
      expect(find.text('BODY 3.0'), findsOneWidget);
      expect(find.textContaining('Peach'), findsOneWidget);
      expect(find.textContaining('Nutty'), findsOneWidget);
      expect(find.textContaining('Black Tea'), findsOneWidget);
      expect(find.text('TIME'), findsOneWidget);
      expect(find.text('POUR'), findsOneWidget);

      final sheet = find.byKey(const Key('share-preview-bottom-sheet'));
      final acidSummary = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.text('ACID 4.5')).first,
      );
      expect(acidSummary.style?.fontSize, 11.0);
    });

    testWidgets(
      'share preview fills featured metric row from dynamic metric list',
      (tester) async {
        final detail =
            TestFixtures.brewDetail(
              id: 19,
              beanName: 'Colombia Huila',
              grindMode: GrindMode.simple,
              grindSimpleLabel: null,
              quickScore: null,
              emoji: null,
            ).copyWith(
              equipmentId: null,
              equipmentName: null,
              pourMethod: null,
              flavorNotes: null,
              acidity: null,
              sweetness: null,
              bitterness: null,
              body: null,
            );
        when(
          mockHistoryRepo.getBrewDetailById(19),
        ).thenAnswer((_) async => detail);

        await tester.pumpWidget(createWidget(brewId: 19));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('brew-detail-share-button')));
        await tester.pumpAndSettle();

        expect(find.text('DOSE'), findsOneWidget);
        expect(find.text('YIELD'), findsOneWidget);
        expect(find.text('TEMP'), findsOneWidget);
        expect(find.text('TIME'), findsOneWidget);
        expect(find.text('GRIND'), findsNothing);
        expect(find.text('POUR'), findsNothing);
      },
    );

    testWidgets('share preview shortens distribution/tamping label', (
      tester,
    ) async {
      final detail =
          TestFixtures.brewDetail(
            id: 20,
            beanName: 'El Salvador',
            quickScore: null,
            emoji: null,
          ).copyWith(
            flavorNotes: null,
            acidity: null,
            sweetness: null,
            bitterness: null,
            body: null,
          );
      when(
        mockHistoryRepo.getBrewDetailById(20),
      ).thenAnswer((_) async => detail);

      final paramRepo = FakeBrewParamRepository(
        definitions: {
          BrewMethod.pourOver: [
            const BrewParamDefinition(
              id: 31,
              method: BrewMethod.pourOver,
              name: 'Distribution/tamping',
              type: ParamType.text,
              unit: null,
              isSystem: true,
              sortOrder: 3,
            ),
          ],
        },
        valuesByBrew: {
          20: [
            const BrewParamValue(
              id: 1,
              brewRecordId: 20,
              paramId: 31,
              valueText: 'WDT + level tamp',
            ),
          ],
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brewRepositoryProvider.overrideWithValue(mockBrewRepo),
            historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
            brewParamRepositoryProvider.overrideWithValue(paramRepo),
            ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
          ],
          child: const MaterialApp(
            locale: Locale('en'),
            supportedLocales: AppLocaleOption.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: BrewDetailPage(brewId: 20),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      final sheet = find.byKey(const Key('share-preview-bottom-sheet'));
      expect(
        find.descendant(of: sheet, matching: find.text('DIST/TAMP')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: sheet, matching: find.text('Distribution/tamping')),
        findsNothing,
      );
    });

    testWidgets('share preview uses larger type for 9-metric layout', (
      tester,
    ) async {
      final detail = TestFixtures.brewDetail(id: 22, beanName: 'Nine Metrics');
      when(
        mockHistoryRepo.getBrewDetailById(22),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 22));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      final sheet = find.byKey(const Key('share-preview-bottom-sheet'));
      final timeLabel = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.text('TIME')).first,
      );
      final doseValue = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.text('15.0g')).first,
      );

      expect(timeLabel.style?.fontSize, 12.5);
      expect(doseValue.style?.fontSize, 20.5);
    });

    testWidgets('share preview uses larger type for 6-metric layout', (
      tester,
    ) async {
      final detail =
          TestFixtures.brewDetail(
            id: 23,
            beanName: 'Six Metrics',
            grindMode: GrindMode.simple,
            grindSimpleLabel: null,
            quickScore: null,
            emoji: null,
          ).copyWith(
            equipmentId: null,
            equipmentName: null,
            pourMethod: null,
            bloomTimeS: null,
            waterType: null,
            roomTempC: null,
            acidity: null,
            sweetness: null,
            bitterness: null,
            body: null,
            flavorNotes: null,
          );
      when(
        mockHistoryRepo.getBrewDetailById(23),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 23));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      final sheet = find.byKey(const Key('share-preview-bottom-sheet'));
      final tempLabel = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.text('TEMP')).first,
      );
      final tempValue = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.text('93°C')).first,
      );

      expect(tempLabel.style?.fontSize, 12.0);
      expect(tempValue.style?.fontSize, 19.5);
    });

    testWidgets('share preview uses larger type for 4-metric layout', (
      tester,
    ) async {
      final detail =
          TestFixtures.brewDetail(
            id: 24,
            beanName: 'Four Metrics',
            grindMode: GrindMode.simple,
            grindSimpleLabel: null,
            quickScore: null,
            emoji: null,
          ).copyWith(
            equipmentId: null,
            equipmentName: null,
            waterTempC: null,
            pourMethod: null,
            bloomTimeS: null,
            waterType: null,
            roomTempC: null,
            acidity: null,
            sweetness: null,
            bitterness: null,
            body: null,
            flavorNotes: null,
          );
      when(
        mockHistoryRepo.getBrewDetailById(24),
      ).thenAnswer((_) async => detail);

      await tester.pumpWidget(createWidget(brewId: 24));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('brew-detail-share-button')));
      await tester.pumpAndSettle();

      final sheet = find.byKey(const Key('share-preview-bottom-sheet'));
      final ratioLabel = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.text('RATIO')).first,
      );
      final ratioValue = tester.widget<Text>(
        find.descendant(of: sheet, matching: find.text('1:16.0')).first,
      );

      expect(ratioLabel.style?.fontSize, 12.0);
      expect(ratioValue.style?.fontSize, 22.0);
    });

    testWidgets('grinder edits refresh an open detail page', (tester) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        await db.close();
        await tester.pump();
      });

      final grinderId = await db.insertEquipment(
        EquipmentsCompanion.insert(
          name: 'Original Grinder',
          category: const drift.Value('grinder'),
          isGrinder: const drift.Value(true),
          grindMinClick: const drift.Value(10),
          grindMaxClick: const drift.Value(30),
          grindClickStep: const drift.Value(0.5),
          grindClickUnit: const drift.Value('clicks'),
          addedAt: drift.Value(DateTime(2026, 3, 1, 9, 0)),
          useCount: const drift.Value(0),
        ),
      );
      final brewId = await db.insertBrewRecord(
        BrewRecordsCompanion.insert(
          brewDate: DateTime(2026, 3, 2, 9, 0),
          beanName: 'Detail Sync Brew',
          equipmentId: drift.Value(grinderId),
          grindMode: const drift.Value('equipment'),
          grindClickValue: const drift.Value(18.0),
          coffeeWeightG: 15,
          waterWeightG: 225,
          brewDurationS: 180,
          createdAt: drift.Value(DateTime(2026, 3, 2, 9, 0)),
          updatedAt: drift.Value(DateTime(2026, 3, 2, 9, 0)),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            locale: Locale('en'),
            supportedLocales: AppLocaleOption.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: BrewDetailPage(brewId: brewId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Original Grinder'), findsOneWidget);
      expect(find.text('18 clicks'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewDetailPage)),
      );
      await container
          .read(inventoryControllerProvider.notifier)
          .saveGrinder(
            initial: domain.Equipment(
              id: grinderId,
              name: 'Original Grinder',
              category: 'grinder',
              isGrinder: true,
              grindMinClick: 10,
              grindMaxClick: 30,
              grindClickStep: 0.5,
              grindClickUnit: 'clicks',
              addedAt: DateTime(2026, 3, 1, 9, 0),
              useCount: 0,
            ),
            name: 'Renamed Grinder',
            minClick: 10,
            maxClick: 30,
            clickStep: 0.5,
            clickUnit: 'steps',
          );
      await tester.pumpAndSettle();

      expect(find.text('Renamed Grinder'), findsOneWidget);
      expect(find.text('18 steps'), findsOneWidget);
      expect(find.text('Original Grinder'), findsNothing);
    });

    testWidgets('saving rating from detail refreshes history state', (
      tester,
    ) async {
      final initialDetail = TestFixtures.brewDetail(
        id: 21,
        beanName: 'Detail Rated Brew',
        quickScore: null,
        emoji: null,
      );
      final ratedDetail = initialDetail.copyWith(quickScore: 3, emoji: '🙂');
      var detailLoadCount = 0;
      when(mockHistoryRepo.getBrewDetailById(21)).thenAnswer((_) async {
        detailLoadCount += 1;
        return detailLoadCount == 1 ? initialDetail : ratedDetail;
      });

      final initialHistory = [
        TestFixtures.brewSummary(
          id: 21,
          beanName: 'Detail Rated Brew',
          quickScore: null,
          emoji: null,
        ),
      ];
      final ratedHistory = [
        TestFixtures.brewSummary(
          id: 21,
          beanName: 'Detail Rated Brew',
          quickScore: 3,
          emoji: '🙂',
        ),
      ];
      var historyLoadCount = 0;
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async {
        historyLoadCount += 1;
        return historyLoadCount >= 2 ? ratedHistory : initialHistory;
      });
      when(mockHistoryRepo.getTopBrews(limit: anyNamed('limit'))).thenAnswer((
        _,
      ) async {
        if (historyLoadCount >= 2) {
          return ratedHistory;
        }
        return const [];
      });
      when(
        mockHistoryRepo.filterBrewSummaries(any),
      ).thenAnswer((_) async => ratedHistory);

      await tester.pumpWidget(createWidget(brewId: 21));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewDetailPage)),
      );
      final historySubscription = container.listen<HistoryState>(
        historyControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(historySubscription.close);

      await tester.pumpAndSettle();
      expect(
        container.read(historyControllerProvider).visibleBrews.single.quickScore,
        isNull,
      );

      await tester.ensureVisible(
        find.byKey(const Key('brew-detail-edit-rating')),
      );
      await tester.tap(find.byKey(const Key('brew-detail-edit-rating')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save rating'));
      await tester.pumpAndSettle();

      expect(historyLoadCount, greaterThanOrEqualTo(2));
      expect(find.byKey(const Key('app-top-toast')), findsOneWidget);
      expect(
        container.read(historyControllerProvider).visibleBrews.single.quickScore,
        3,
      );
      expect(find.textContaining('3/5'), findsOneWidget);

      AppTopToast.dismiss();
    });
  });
}
