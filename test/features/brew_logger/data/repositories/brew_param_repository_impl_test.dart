import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/core/database/drift_database.dart'
    show BrewRecordsCompanion, OneCoffeeDatabase;
import 'package:one_coffee/features/brew_logger/data/datasources/brew_param_local_datasource.dart';
import 'package:one_coffee/features/brew_logger/data/repositories/brew_param_repository_impl.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_method.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_param_definition.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_param_value.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_param_visibility.dart';
import 'package:one_coffee/features/brew_logger/domain/usecases/initialize_default_brew_params.dart';

void main() {
  late OneCoffeeDatabase db;
  late BrewParamLocalDatasource datasource;
  late BrewParamRepositoryImpl repository;

  setUp(() {
    db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
    datasource = BrewParamLocalDatasource(db);
    repository = BrewParamRepositoryImpl(datasource);
  });

  tearDown(() async {
    await db.close();
  });

  group('BrewParamRepositoryImpl CRUD', () {
    test('create/update/delete param definition', () async {
      final defId = await repository.createParamDefinition(
        const BrewParamDefinition(
          id: 0,
          method: BrewMethod.pourOver,
          name: 'Coffee Weight',
          type: ParamType.number,
          unit: 'g',
          isSystem: true,
          sortOrder: 1,
        ),
      );

      final defs = await repository.getParamDefinitions(BrewMethod.pourOver);
      expect(defs, hasLength(1));
      expect(defs.first.id, defId);
      expect(defs.first.name, 'Coffee Weight');

      final updated = await repository.updateParamDefinition(
        BrewParamDefinition(
          id: defId,
          method: BrewMethod.pourOver,
          name: 'Coffee Dose',
          type: ParamType.number,
          unit: 'g',
          isSystem: true,
          sortOrder: 1,
        ),
      );
      expect(updated, isTrue);

      final updatedDef = await repository.getParamDefinitionById(defId);
      expect(updatedDef?.name, 'Coffee Dose');

      final deleted = await repository.deleteParamDefinition(defId);
      expect(deleted, 1);
      final remaining = await repository.getParamDefinitions(BrewMethod.pourOver);
      expect(remaining, isEmpty);
    });

    test('create/update/delete param visibility', () async {
      final defId = await repository.createParamDefinition(
        const BrewParamDefinition(
          id: 0,
          method: BrewMethod.pourOver,
          name: 'Water Temp',
          type: ParamType.number,
          unit: 'C',
          isSystem: true,
          sortOrder: 2,
        ),
      );

      final visId = await repository.createParamVisibility(
        BrewParamVisibility(
          id: 0,
          method: BrewMethod.pourOver,
          paramId: defId,
          isVisible: true,
        ),
      );

      var visList = await repository.getParamVisibilities(BrewMethod.pourOver);
      expect(visList, hasLength(1));
      expect(visList.first.id, visId);
      expect(visList.first.isVisible, isTrue);

      final updated = await repository.updateParamVisibility(
        BrewParamVisibility(
          id: visId,
          method: BrewMethod.pourOver,
          paramId: defId,
          isVisible: false,
        ),
      );
      expect(updated, isTrue);

      visList = await repository.getParamVisibilities(BrewMethod.pourOver);
      expect(visList.single.isVisible, isFalse);

      final deleted = await repository.deleteParamVisibility(visId);
      expect(deleted, 1);
    });

    test('create/update/delete param value', () async {
      final brewId = await db.insertBrewRecord(
        BrewRecordsCompanion.insert(
          brewDate: DateTime(2026, 3, 10, 8, 0),
          beanName: 'Test Bean',
          grindMode: const Value('simple'),
          grindSimpleLabel: const Value('Medium'),
          coffeeWeightG: 15,
          waterWeightG: 225,
          brewDurationS: 180,
          createdAt: Value(DateTime(2026, 3, 10, 8, 0)),
          updatedAt: Value(DateTime(2026, 3, 10, 8, 0)),
        ),
      );

      final defId = await repository.createParamDefinition(
        const BrewParamDefinition(
          id: 0,
          method: BrewMethod.pourOver,
          name: 'Agitation',
          type: ParamType.text,
          unit: null,
          isSystem: true,
          sortOrder: 10,
        ),
      );

      final valueId = await repository.createParamValue(
        BrewParamValue(
          id: 0,
          brewRecordId: brewId,
          paramId: defId,
          valueText: 'Stir',
        ),
      );

      var values = await repository.getParamValuesForBrew(brewId);
      expect(values, hasLength(1));
      expect(values.first.id, valueId);
      expect(values.first.valueText, 'Stir');

      final updated = await repository.updateParamValue(
        BrewParamValue(
          id: valueId,
          brewRecordId: brewId,
          paramId: defId,
          valueText: 'Swirl',
        ),
      );
      expect(updated, isTrue);

      values = await repository.getParamValuesForBrew(brewId);
      expect(values.single.valueText, 'Swirl');

      final deleted = await repository.deleteParamValue(valueId);
      expect(deleted, 1);
    });
  });

  group('Default template initialization', () {
    test('creates default method configs and param templates', () async {
      final init = InitializeDefaultBrewParams(repository);
      await init();

      final methods = await repository.getMethodConfigs();
      expect(methods, isNotEmpty);
      expect(
        methods.any((m) => m.method == BrewMethod.pourOver && m.isEnabled),
        isTrue,
      );
      expect(
        methods.any((m) => m.method == BrewMethod.espresso && m.isEnabled),
        isTrue,
      );

      final pourOverDefs = await repository.getParamDefinitions(
        BrewMethod.pourOver,
      );
      final espressoDefs = await repository.getParamDefinitions(
        BrewMethod.espresso,
      );
      expect(pourOverDefs, isNotEmpty);
      expect(espressoDefs, isNotEmpty);

      final visibilities = await repository.getParamVisibilities(
        BrewMethod.pourOver,
      );
      expect(visibilities, isNotEmpty);
      expect(visibilities.every((v) => v.isVisible), isTrue);
    });
  });
}
