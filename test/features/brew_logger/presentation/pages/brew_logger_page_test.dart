import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/core/widgets/app_slider.dart';
import 'package:one_coffee/features/brew_logger/brew_logger_providers.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_coffee/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_coffee/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_coffee/features/inventory/domain/entities/equipment.dart';
import 'package:one_coffee/features/inventory/inventory_providers.dart';
import 'package:one_coffee/features/rating/rating_providers.dart';

import '../../../../helpers/mock_repositories.mocks.dart';

void main() {
  group('BrewLoggerPage Widget Tests', () {
    late MockBrewRepository mockBrewRepo;
    late MockInventoryRepository mockInventoryRepo;
    late MockRatingRepository mockRatingRepo;

    setUp(() {
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

      mockRatingRepo = MockRatingRepository();
      when(mockRatingRepo.getRatingForBrew(any)).thenAnswer((_) async => null);
      when(mockRatingRepo.createRating(any)).thenAnswer((_) async => 1);
      when(mockRatingRepo.updateRating(any)).thenAnswer((_) async => true);
    });

    Widget createWidget({int? templateRecordId}) {
      return ProviderScope(
        overrides: [
          brewRepositoryProvider.overrideWithValue(mockBrewRepo),
          inventoryRepositoryProvider.overrideWithValue(mockInventoryRepo),
          ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
        ],
        child: MaterialApp(
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

      expect(find.text('Ready to Brew'), findsOneWidget);

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

    testWidgets('Toggling advanced params expands correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final showMoreFinder = find.text('Show more parameters');
      expect(showMoreFinder, findsOneWidget);

      await tester.tap(showMoreFinder);
      await tester.pumpAndSettle();

      final hideFinder = find.text('Hide parameters');
      expect(hideFinder, findsOneWidget);
    });

    testWidgets('After saving brew, rating bottom sheet is reachable', (
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

      expect(find.text('Rate this brew'), findsOneWidget);
      expect(find.text('Skip for now'), findsOneWidget);

      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      expect(find.text('Brew saved!'), findsOneWidget);
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

      await tester.tap(find.text('Show more parameters'));
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
        isQuickMode: true,
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
    });
  });
}
