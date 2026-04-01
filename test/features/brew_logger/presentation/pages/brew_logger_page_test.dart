import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/core/widgets/app_slider.dart';
import 'package:one_brew/core/widgets/app_top_toast.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_method_config.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_param_visibility.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_brew/features/brew_logger/presentation/widgets/brew_timer_widget.dart';
import 'package:one_brew/features/brew_logger/presentation/widgets/param_input_section.dart';
import 'package:one_brew/features/history/domain/entities/brew_summary.dart';
import 'package:one_brew/features/history/history_providers.dart';
import 'package:one_brew/features/history/presentation/controllers/history_controller.dart';
import 'package:one_brew/features/inventory/domain/entities/equipment.dart';
import 'package:one_brew/features/inventory/inventory_providers.dart';
import 'package:one_brew/features/rating/rating_providers.dart';
import 'package:one_brew/l10n/app_localizations.dart';

import '../../../../helpers/fake_brew_param_repository.dart';
import '../../../../helpers/mock_repositories.mocks.dart';

void main() {
  group('BrewLoggerPage Widget Tests', () {
    late MockBrewRepository mockBrewRepo;
    late MockInventoryRepository mockInventoryRepo;
    late MockHistoryRepository mockHistoryRepo;
    late MockRatingRepository mockRatingRepo;
    late FakeBrewParamRepository fakeBrewParamRepo;

    setUp(() {
      addTearDown(AppTopToast.dismiss);
      addTearDown(AppBottomActionPrompt.dismiss);

      mockBrewRepo = MockBrewRepository();
      when(mockBrewRepo.createBrewRecord(any)).thenAnswer((_) async => 1);
      when(
        mockBrewRepo.watchAllBrewRecords(),
      ).thenAnswer((_) => Stream.value(const <BrewRecord>[]));
      when(mockBrewRepo.getBrewRecordById(any)).thenAnswer((_) async => null);

      mockInventoryRepo = MockInventoryRepository();
      when(mockInventoryRepo.searchBeans(any)).thenAnswer((_) async => []);
      when(mockInventoryRepo.searchEquipments(any)).thenAnswer((_) async => []);
      when(mockInventoryRepo.getAllBeans()).thenAnswer((_) async => []);
      when(mockInventoryRepo.getAllEquipments()).thenAnswer((_) async => []);

      mockHistoryRepo = MockHistoryRepository();
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async => []);
      when(
        mockHistoryRepo.getTopBrews(limit: anyNamed('limit')),
      ).thenAnswer((_) async => []);
      when(
        mockHistoryRepo.filterBrewSummaries(any),
      ).thenAnswer((_) async => []);

      mockRatingRepo = MockRatingRepository();
      when(mockRatingRepo.getRatingForBrew(any)).thenAnswer((_) async => null);
      when(mockRatingRepo.createRating(any)).thenAnswer((_) async => 1);
      when(mockRatingRepo.updateRating(any)).thenAnswer((_) async => true);

      fakeBrewParamRepo = FakeBrewParamRepository();
    });

    Widget createWidget({int? templateRecordId}) {
      return ProviderScope(
        overrides: [
          brewRepositoryProvider.overrideWithValue(mockBrewRepo),
          inventoryRepositoryProvider.overrideWithValue(mockInventoryRepo),
          historyRepositoryProvider.overrideWithValue(mockHistoryRepo),
          ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
          brewParamRepositoryProvider.overrideWithValue(fakeBrewParamRepo),
          brewParamBootstrapProvider.overrideWith((ref) async => false),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocaleOption.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: BrewLoggerPage(templateRecordId: templateRecordId),
        ),
      );
    }

    testWidgets('BrewLoggerPage renders core components initially', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Brew Method'), findsOneWidget);

      final saveFinder = find.text('Start timer to save');
      expect(saveFinder, findsOneWidget);

      expect(find.byIcon(Icons.coffee_rounded), findsOneWidget);
    });

    testWidgets('Timer actions display play/pause properly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final startIcon = find.byIcon(Icons.coffee_rounded);
      await tester.tap(startIcon);
      await tester.pump();

      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final saveBtnFinder = find.text('Save Brew');
      expect(saveBtnFinder, findsOneWidget);
    });

    testWidgets('Timer is rendered below parameter input section', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final paramsFinder = find.byType(ParamInputSection);
      final timerFinder = find.byType(BrewTimerWidget);
      expect(paramsFinder, findsOneWidget);
      expect(timerFinder, findsOneWidget);
      expect(
        tester.getTopLeft(timerFinder).dy,
        greaterThan(tester.getTopLeft(paramsFinder).dy),
      );
    });

    testWidgets('Timer target is recommended by brew method', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Target 3:00'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      container
          .read(brewLoggerControllerProvider.notifier)
          .setBrewMethod(BrewMethod.espresso);
      await tester.pumpAndSettle();

      expect(find.text('Target 0:30'), findsOneWidget);
    });

    testWidgets('Timer target can be turned off', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Target On'), findsOneWidget);
      expect(find.text('0:00 / 3:00'), findsOneWidget);

      await tester.tap(find.text('Target On'));
      await tester.pumpAndSettle();

      expect(find.text('Target Off'), findsOneWidget);
      expect(find.text('0:00 / 3:00'), findsNothing);
    });

    testWidgets('Advanced parameters are visible by default', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Grind Mode'), findsOneWidget);
    });

    testWidgets('After saving brew, rating is optional and can be opened', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      container
          .read(brewLoggerControllerProvider.notifier)
          .setBeanName('Test Bean');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.coffee_rounded));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Brew'));
      await tester.pumpAndSettle();

      expect(find.text('Rate this brew'), findsNothing);
      expect(find.byKey(const Key('app-top-toast')), findsNothing);
      expect(find.byKey(const Key('app-bottom-action-prompt')), findsOneWidget);
      expect(
        find.text('Brew saved. You can rate now or later in History detail.'),
        findsOneWidget,
      );
      expect(find.text('Rate now'), findsOneWidget);

      await tester.tap(find.text('Rate now'));
      await tester.pumpAndSettle();

      expect(find.text('Rate this brew'), findsOneWidget);
      expect(find.text('Skip for now'), findsOneWidget);

      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();
      AppBottomActionPrompt.dismiss();
    });

    testWidgets('saving invalidates history so it reloads with fresh records', (
      WidgetTester tester,
    ) async {
      final initialHistory = [
        BrewSummary(
          id: 1,
          brewDate: DateTime(2026, 3, 1, 9, 0),
          beanName: 'Before Save',
          roaster: null,
          brewDurationS: 180,
          coffeeWeightG: 15,
          waterWeightG: 225,
        ),
      ];
      final refreshedHistory = [
        BrewSummary(
          id: 2,
          brewDate: DateTime(2026, 3, 2, 9, 0),
          beanName: 'After Save',
          roaster: null,
          brewDurationS: 195,
          coffeeWeightG: 16,
          waterWeightG: 240,
        ),
      ];
      var loadCount = 0;
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async {
        loadCount += 1;
        return loadCount == 1 ? initialHistory : refreshedHistory;
      });
      when(
        mockHistoryRepo.getTopBrews(limit: anyNamed('limit')),
      ).thenAnswer((_) async => const []);
      when(
        mockHistoryRepo.filterBrewSummaries(any),
      ).thenAnswer((_) async => refreshedHistory);

      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      final historySubscription = container.listen<HistoryState>(
        historyControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(historySubscription.close);

      await tester.pumpAndSettle();
      expect(
        container.read(historyControllerProvider).visibleBrews.single.beanName,
        'Before Save',
      );

      container
          .read(brewLoggerControllerProvider.notifier)
          .setBeanName('Test Bean');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.coffee_rounded));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Brew'));
      await tester.pumpAndSettle();

      expect(loadCount, greaterThanOrEqualTo(2));
      expect(
        container.read(historyControllerProvider).visibleBrews.single.beanName,
        'After Save',
      );
      AppBottomActionPrompt.dismiss();
    });

    testWidgets('saving rating after brew save refreshes history again', (
      WidgetTester tester,
    ) async {
      final initialHistory = [
        BrewSummary(
          id: 1,
          brewDate: DateTime(2026, 3, 1, 9, 0),
          beanName: 'Initial',
          roaster: null,
          brewDurationS: 180,
          coffeeWeightG: 15,
          waterWeightG: 225,
        ),
      ];
      final unratedHistory = [
        BrewSummary(
          id: 2,
          brewDate: DateTime(2026, 3, 2, 9, 0),
          beanName: 'Fresh Brew',
          roaster: null,
          brewDurationS: 195,
          coffeeWeightG: 16,
          waterWeightG: 240,
        ),
      ];
      final ratedHistory = [
        BrewSummary(
          id: 2,
          brewDate: DateTime(2026, 3, 2, 9, 0),
          beanName: 'Fresh Brew',
          roaster: null,
          brewDurationS: 195,
          coffeeWeightG: 16,
          waterWeightG: 240,
          quickScore: 3,
          emoji: '🙂',
        ),
      ];
      var loadCount = 0;
      when(mockHistoryRepo.getAllBrewSummaries()).thenAnswer((_) async {
        loadCount += 1;
        if (loadCount == 1) return initialHistory;
        if (loadCount == 2) return unratedHistory;
        return ratedHistory;
      });
      when(mockHistoryRepo.getTopBrews(limit: anyNamed('limit'))).thenAnswer((
        _,
      ) async {
        if (loadCount >= 3) {
          return ratedHistory;
        }
        return const [];
      });
      when(
        mockHistoryRepo.filterBrewSummaries(any),
      ).thenAnswer((_) async => ratedHistory);

      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      final historySubscription = container.listen<HistoryState>(
        historyControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(historySubscription.close);

      await tester.pumpAndSettle();

      container
          .read(brewLoggerControllerProvider.notifier)
          .setBeanName('Test Bean');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.coffee_rounded));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Brew'));
      await tester.pumpAndSettle();
      expect(
        container
            .read(historyControllerProvider)
            .visibleBrews
            .single
            .quickScore,
        isNull,
      );

      await tester.tap(find.text('Rate now'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save rating'));
      await tester.pumpAndSettle();

      expect(loadCount, greaterThanOrEqualTo(3));
      expect(
        container
            .read(historyControllerProvider)
            .visibleBrews
            .single
            .quickScore,
        3,
      );
      AppBottomActionPrompt.dismiss();
    });

    testWidgets('interacting with form dismisses save prompt without blocking input', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      container
          .read(brewLoggerControllerProvider.notifier)
          .setBeanName('Test Bean');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.coffee_rounded));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Brew'));
      await tester.pumpAndSettle();

      container
          .read(brewLoggerControllerProvider.notifier)
          .setGrindMode(GrindMode.pro);
      await tester.pumpAndSettle();

      final grindSizeField = find.byType(TextFormField);
      expect(grindSizeField, findsOneWidget);
      await tester.tap(grindSizeField);
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isTrue);
      expect(find.byKey(const Key('app-top-toast')), findsNothing);
      expect(find.byKey(const Key('app-bottom-action-prompt')), findsNothing);
      AppBottomActionPrompt.dismiss();
    });

    testWidgets('Equipment grind slider uses dynamic equipment config', (
      WidgetTester tester,
    ) async {
      final configuredGrinder = Equipment(
        id: 42,
        name: 'Comandante C40',
        isGrinder: true,
        grindMinClick: 10,
        grindMaxClick: 30,
        grindClickStep: 0.5,
        grindClickUnit: '格',
        addedAt: DateTime(2026, 1, 1),
        useCount: 0,
      );
      when(
        mockInventoryRepo.searchEquipments(any),
      ).thenAnswer((_) async => [configuredGrinder]);

      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      await container
          .read(brewLoggerControllerProvider.notifier)
          .setEquipmentByName('Comandante C40');
      await tester.pumpAndSettle();

      final sliderFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppSlider && widget.semanticLabel == 'Grind click value',
      );
      expect(sliderFinder, findsOneWidget);

      final slider = tester.widget<AppSlider>(sliderFinder);
      expect(slider.min, equals(10.0));
      expect(slider.max, equals(30.0));
      expect(slider.divisions, equals(40));
      expect(slider.unit, equals('格'));
    });

    testWidgets('applies route templateRecordId into form state', (
      WidgetTester tester,
    ) async {
      final template = BrewRecord(
        id: 11,
        brewDate: DateTime(2026, 3, 7, 8, 0),
        beanName: 'Template Bean',
        equipmentId: null,
        brewMethod: BrewMethod.pourOver,
        grindMode: GrindMode.simple,
        grindSimpleLabel: 'Medium',
        coffeeWeightG: 17.0,
        waterWeightG: 272.0,
        waterTempC: 92.0,
        brewDurationS: 185,
        bloomTimeS: 30,
        pourMethod: 'Pulse',
        waterType: 'Filtered',
        roomTempC: 23.0,
        notes: 'Template note',
        createdAt: DateTime(2026, 3, 7, 8, 1),
        updatedAt: DateTime(2026, 3, 7, 8, 1),
      );
      when(
        mockBrewRepo.getBrewRecordById(11),
      ).thenAnswer((_) async => template);

      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget(templateRecordId: 11));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      final state = container.read(brewLoggerControllerProvider);
      expect(state.beanName, 'Template Bean');
      expect(state.coffeeWeightG, 17.0);
      expect(state.waterWeightG, 272.0);
      expect(find.text('Template loaded from history'), findsOneWidget);
      AppTopToast.dismiss();
    });

    testWidgets('quick params respect hidden visibility in custom method', (
      WidgetTester tester,
    ) async {
      fakeBrewParamRepo = FakeBrewParamRepository(
        methodConfigs: const [
          BrewMethodConfig(
            id: 1,
            method: BrewMethod.pourOver,
            displayName: 'Pour Over',
            isEnabled: true,
          ),
          BrewMethodConfig(
            id: 2,
            method: BrewMethod.custom,
            displayName: 'Custom',
            isEnabled: true,
          ),
        ],
        definitions: {
          BrewMethod.custom: const [
            BrewParamDefinition(
              id: 1001,
              method: BrewMethod.custom,
              name: 'Coffee Weight',
              type: ParamType.number,
              unit: 'g',
              isSystem: true,
              sortOrder: 1,
            ),
            BrewParamDefinition(
              id: 1002,
              method: BrewMethod.custom,
              name: 'Water Weight',
              type: ParamType.number,
              unit: 'g',
              isSystem: true,
              sortOrder: 2,
            ),
            BrewParamDefinition(
              id: 1003,
              method: BrewMethod.custom,
              name: 'Brew Ratio',
              type: ParamType.number,
              isSystem: true,
              sortOrder: 3,
            ),
          ],
        },
        visibilities: {
          BrewMethod.custom: const [
            BrewParamVisibility(
              id: 2001,
              method: BrewMethod.custom,
              paramId: 1001,
              isVisible: false,
            ),
            BrewParamVisibility(
              id: 2002,
              method: BrewMethod.custom,
              paramId: 1002,
              isVisible: false,
            ),
            BrewParamVisibility(
              id: 2003,
              method: BrewMethod.custom,
              paramId: 1003,
              isVisible: false,
            ),
          ],
        },
      );

      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      container
          .read(brewLoggerControllerProvider.notifier)
          .setBrewMethod(BrewMethod.custom);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppSlider && widget.semanticLabel == 'coffee weight',
        ),
        findsNothing,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppSlider && widget.semanticLabel == 'water weight',
        ),
        findsNothing,
      );
      expect(find.textContaining('1 : '), findsNothing);
    });

    testWidgets('method selector options use equal-width layout', (
      WidgetTester tester,
    ) async {
      fakeBrewParamRepo = FakeBrewParamRepository(
        methodConfigs: const [
          BrewMethodConfig(
            id: 1,
            method: BrewMethod.pourOver,
            displayName: 'Pour Over',
            isEnabled: true,
          ),
          BrewMethodConfig(
            id: 2,
            method: BrewMethod.espresso,
            displayName: 'Espresso',
            isEnabled: true,
          ),
          BrewMethodConfig(
            id: 3,
            method: BrewMethod.custom,
            displayName: 'Custom',
            isEnabled: true,
          ),
        ],
      );

      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final pourOver = find.byKey(const Key('brew-method-option-pourOver'));
      final espresso = find.byKey(const Key('brew-method-option-espresso'));
      final custom = find.byKey(const Key('brew-method-option-custom'));
      expect(pourOver, findsOneWidget);
      expect(espresso, findsOneWidget);
      expect(custom, findsOneWidget);

      final pourOverWidth = tester.getSize(pourOver).width;
      final espressoWidth = tester.getSize(espresso).width;
      final customWidth = tester.getSize(custom).width;
      expect(espressoWidth, closeTo(pourOverWidth, 0.1));
      expect(customWidth, closeTo(pourOverWidth, 0.1));
    });

    testWidgets('hides method selector when only one method is enabled', (
      WidgetTester tester,
    ) async {
      fakeBrewParamRepo = FakeBrewParamRepository(
        methodConfigs: const [
          BrewMethodConfig(
            id: 9,
            method: BrewMethod.espresso,
            displayName: 'Espresso',
            isEnabled: true,
          ),
        ],
      );

      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Brew Method'), findsNothing);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BrewLoggerPage)),
      );
      final state = container.read(brewLoggerControllerProvider);
      expect(state.brewMethod, BrewMethod.espresso);
    });
  });
}
