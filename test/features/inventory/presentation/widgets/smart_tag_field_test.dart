import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:one_coffee/core/database/drift_database.dart';
import 'package:one_coffee/features/brew_logger/presentation/controllers/brew_logger_controller.dart';
import 'package:one_coffee/features/inventory/inventory_providers.dart';
import 'package:one_coffee/shared/providers/database_providers.dart';
import 'package:one_coffee/core/widgets/app_chip_input.dart';
import 'package:one_coffee/features/inventory/presentation/widgets/smart_tag_field.dart';

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
    final db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
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
      final db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
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

  testWidgets(
    'Quick grinder setup Save works with empty fields',
    (WidgetTester tester) async {
      final db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
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
    },
  );
}
