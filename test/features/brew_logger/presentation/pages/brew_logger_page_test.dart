import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/features/brew_logger/data/repositories/brew_repository_impl.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_coffee/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_coffee/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_coffee/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:one_coffee/features/rating/data/repositories/rating_repository_impl.dart';

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

    Widget createWidget() {
      return ProviderScope(
        overrides: [
          brewRepositoryProvider.overrideWithValue(mockBrewRepo),
          inventoryRepositoryProvider.overrideWithValue(mockInventoryRepo),
          ratingRepositoryProvider.overrideWithValue(mockRatingRepo),
        ],
        child: const MaterialApp(home: BrewLoggerPage()),
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
  });
}
