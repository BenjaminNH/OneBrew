import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:one_brew/core/database/drift_database.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_brew/features/inventory/inventory_providers.dart';
import 'package:one_brew/shared/providers/database_providers.dart';
import 'package:one_brew/core/widgets/app_chip_input.dart';
import 'package:one_brew/features/inventory/presentation/widgets/smart_tag_field.dart';

class _EquipmentSelectionHarness extends ConsumerStatefulWidget {
  const _EquipmentSelectionHarness();

  @override
  ConsumerState<_EquipmentSelectionHarness> createState() =>
      _EquipmentSelectionHarnessState();
}

class _EquipmentSelectionHarnessState
    extends ConsumerState<_EquipmentSelectionHarness> {
  List<String> _selectedTags = const [];

  @override
  Widget build(BuildContext context) {
    return SmartTagField(
      type: TagFieldType.equipment,
      tags: _selectedTags,
      singleSelection: true,
      onTagsChanged: (tags) {
        setState(() {
          _selectedTags = tags;
        });
        final selected = tags.isEmpty ? null : tags.first;
        unawaited(
          ref
              .read(brewLoggerControllerProvider.notifier)
              .setEquipmentByName(selected),
        );
      },
    );
  }
}

void main() {
  testWidgets('SmartTagField renders and handles input', (
    WidgetTester tester,
  ) async {
    final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    List<String> selectedTags = [];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SmartTagField(
                  type: TagFieldType.bean,
                  tags: selectedTags,
                  onTagsChanged: (tags) {
                    setState(() {
                      selectedTags = tags;
                    });
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    // Initial state: empty field, hint text visible
    expect(find.byType(AppChipInput), findsOneWidget);
    expect(find.text('Type to add...'), findsOneWidget);

    // Enter a new bean tag
    await tester.enterText(find.byType(TextField), 'Gesha');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verify tag is added to the list and UI reflects it
    expect(selectedTags, ['Gesha']);
    expect(find.text('Gesha'), findsOneWidget);
  });

  testWidgets(
    'SmartTagField equipment submit resolves equipmentId and grinder flag',
    (WidgetTester tester) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: Scaffold(body: _EquipmentSelectionHarness()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Lagom Mini');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Quick Grinder Setup'), findsOneWidget);
      await tester.tap(find.text('Use Defaults'));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(_EquipmentSelectionHarness)),
      );

      final loggerState = container.read(brewLoggerControllerProvider);
      expect(loggerState.equipmentId, isNotNull);
      expect(loggerState.selectedEquipmentName, 'Lagom Mini');

      final inventoryRepo = container.read(inventoryRepositoryProvider);
      final equipments = await inventoryRepo.searchEquipments('Lagom Mini');
      expect(equipments, hasLength(1));
      expect(equipments.first.isGrinder, isTrue);
      expect(equipments.first.grindMinClick, 0);
      expect(equipments.first.grindMaxClick, 40);
      expect(equipments.first.grindClickStep, 1);
      expect(equipments.first.grindClickUnit, 'clicks');
    },
  );

  testWidgets('Quick grinder setup Save works with empty fields', (
    WidgetTester tester,
  ) async {
    final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: Scaffold(body: _EquipmentSelectionHarness()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'K-Ultra');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Quick Grinder Setup'), findsOneWidget);
    await tester.tap(find.text('Save Grinder'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();

    expect(find.text('Quick Grinder Setup'), findsNothing);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_EquipmentSelectionHarness)),
    );
    final inventoryRepo = container.read(inventoryRepositoryProvider);
    final equipments = await inventoryRepo.searchEquipments('K-Ultra');
    expect(equipments, hasLength(1));
    expect(equipments.first.grindMinClick, 0);
    expect(equipments.first.grindMaxClick, 40);
    expect(equipments.first.grindClickStep, 1);
    expect(equipments.first.grindClickUnit, 'clicks');
  });

  testWidgets(
    'Quick grinder setup Save persists custom values without controller errors',
    (WidgetTester tester) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: Scaffold(body: _EquipmentSelectionHarness()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'ZP6');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(1), '8');
      await tester.enterText(fields.at(2), '68');
      await tester.enterText(fields.at(3), '0.5');
      await tester.enterText(fields.at(4), 'steps');

      await tester.tap(find.text('Save Grinder'));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(_EquipmentSelectionHarness)),
      );
      final inventoryRepo = container.read(inventoryRepositoryProvider);
      final equipments = await inventoryRepo.searchEquipments('ZP6');
      expect(equipments, hasLength(1));
      expect(equipments.first.grindMinClick, 8);
      expect(equipments.first.grindMaxClick, 68);
      expect(equipments.first.grindClickStep, 0.5);
      expect(equipments.first.grindClickUnit, 'steps');
    },
  );

  testWidgets(
    'equipment quick-add skips setup sheet after first setup exists',
    (WidgetTester tester) async {
      final db = OneBrewDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      await db.insertEquipment(
        EquipmentsCompanion.insert(
          name: 'Comandante C40',
          isGrinder: const drift.Value(true),
          grindMinClick: const drift.Value(0),
          grindMaxClick: const drift.Value(40),
          grindClickStep: const drift.Value(1),
          grindClickUnit: const drift.Value('clicks'),
          addedAt: drift.Value(DateTime(2026, 1, 1, 9)),
          useCount: const drift.Value(10),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: Scaffold(body: _EquipmentSelectionHarness()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Lagom P64');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Quick Grinder Setup'), findsNothing);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(_EquipmentSelectionHarness)),
      );
      final inventoryRepo = container.read(inventoryRepositoryProvider);
      final equipments = await inventoryRepo.searchEquipments('Lagom P64');
      expect(equipments, hasLength(1));
      expect(equipments.first.grindMinClick, 0);
      expect(equipments.first.grindMaxClick, 40);
      expect(equipments.first.grindClickStep, 1);
      expect(equipments.first.grindClickUnit, 'clicks');

      final loggerState = container.read(brewLoggerControllerProvider);
      expect(loggerState.selectedEquipmentName, 'Lagom P64');
      expect(loggerState.equipmentId, isNotNull);
    },
  );
}
