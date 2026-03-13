import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/database/drift_database.dart';

/// Integration tests for [OneBrewDatabase] using an in-memory SQLite instance.
///
/// Covers:
///   - Beans CRUD + useCount increment + search
///   - Equipment CRUD + useCount increment + search
///   - BrewRecord CRUD + stream watch
///   - BrewRating CRUD
///   - FK relationship: BrewRecord → Equipment, BrewRecord → BrewRating (cascade delete)
///
/// Run with:
///   flutter test test/core/database/drift_database_test.dart
void main() {
  late OneBrewDatabase db;

  setUp(() {
    db = OneBrewDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Helper factories
  // ─────────────────────────────────────────────────────────────────────────

  BeansCompanion makeBeanCompanion({
    String name = 'Ethiopia Yirgacheffe',
    String? roaster = 'TestRoaster',
    String? origin = 'Ethiopia',
    String? roastLevel = 'Light',
  }) => BeansCompanion.insert(
    name: name,
    roaster: Value(roaster),
    origin: Value(origin),
    roastLevel: Value(roastLevel),
  );

  EquipmentsCompanion makeEquipCompanion({
    String name = 'Comandante C40',
    bool isGrinder = true,
    double? grindMin = 0,
    double? grindMax = 40,
    double? step = 1.0,
    String? unit = 'clicks',
  }) => EquipmentsCompanion.insert(
    name: name,
    isGrinder: Value(isGrinder),
    grindMinClick: Value(grindMin),
    grindMaxClick: Value(grindMax),
    grindClickStep: Value(step),
    grindClickUnit: Value(unit),
  );

  BrewRecordsCompanion makeBrewCompanion({
    String beanName = 'Ethiopia Yirgacheffe',
    int? equipmentId,
    double coffeeWeight = 15.0,
    double waterWeight = 225.0,
    int duration = 180,
  }) => BrewRecordsCompanion.insert(
    brewDate: DateTime.now(),
    beanName: beanName,
    equipmentId: Value(equipmentId),
    coffeeWeightG: coffeeWeight,
    waterWeightG: waterWeight,
    brewDurationS: duration,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Bean CRUD
  // ─────────────────────────────────────────────────────────────────────────

  group('Bean CRUD', () {
    test('insert and retrieve a bean', () async {
      final id = await db.insertBean(makeBeanCompanion());
      expect(id, greaterThan(0));

      final all = await db.getAllBeans();
      expect(all.length, 1);
      expect(all.first.name, 'Ethiopia Yirgacheffe');
      expect(all.first.roaster, 'TestRoaster');
      expect(all.first.useCount, 0);
    });

    test('update a bean', () async {
      final id = await db.insertBean(makeBeanCompanion());
      final bean = (await db.getAllBeans()).first;

      final updated = await db.updateBean(
        bean
            .toCompanion(true)
            .copyWith(id: Value(id), roaster: const Value('NewRoaster')),
      );
      expect(updated, true);

      final all = await db.getAllBeans();
      expect(all.first.roaster, 'NewRoaster');
    });

    test('delete a bean', () async {
      final id = await db.insertBean(makeBeanCompanion());
      final deleted = await db.deleteBean(id);
      expect(deleted, 1);

      final all = await db.getAllBeans();
      expect(all, isEmpty);
    });

    test('increment useCount', () async {
      final id = await db.insertBean(makeBeanCompanion());
      await db.incrementBeanUseCount(id);
      await db.incrementBeanUseCount(id);

      final all = await db.getAllBeans();
      expect(all.first.useCount, 2);
    });

    test('searchBeans returns matching results', () async {
      await db.insertBean(makeBeanCompanion(name: 'Ethiopia Yirgacheffe'));
      await db.insertBean(makeBeanCompanion(name: 'Kenya AA'));

      final results = await db.searchBeans('kenya');
      expect(results.length, 1);
      expect(results.first.name, 'Kenya AA');
    });

    test('searchBeans sorts by useCount descending', () async {
      final id1 = await db.insertBean(makeBeanCompanion(name: 'Bean A'));
      final id2 = await db.insertBean(makeBeanCompanion(name: 'Bean B'));

      // B used more
      await db.incrementBeanUseCount(id2);
      await db.incrementBeanUseCount(id2);
      await db.incrementBeanUseCount(id1);

      final results = await db.searchBeans('bean');
      expect(results.first.name, 'Bean B');
    });

    test('bean name must be unique', () async {
      await db.insertBean(makeBeanCompanion(name: 'UniqueBean'));
      expect(
        () => db.insertBean(makeBeanCompanion(name: 'UniqueBean')),
        throwsA(anything),
      );
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Equipment CRUD
  // ─────────────────────────────────────────────────────────────────────────

  group('Equipment CRUD', () {
    test('insert and retrieve equipment', () async {
      final id = await db.insertEquipment(makeEquipCompanion());
      expect(id, greaterThan(0));

      final all = await db.getAllEquipments();
      expect(all.length, 1);
      expect(all.first.name, 'Comandante C40');
      expect(all.first.isGrinder, true);
      expect(all.first.grindMaxClick, 40.0);
    });

    test('update equipment', () async {
      final id = await db.insertEquipment(makeEquipCompanion());
      final equip = (await db.getAllEquipments()).first;

      await db.updateEquipment(
        equip
            .toCompanion(true)
            .copyWith(id: Value(id), grindMaxClick: const Value(50.0)),
      );

      final all = await db.getAllEquipments();
      expect(all.first.grindMaxClick, 50.0);
    });

    test('delete equipment', () async {
      final id = await db.insertEquipment(makeEquipCompanion());
      final deleted = await db.deleteEquipment(id);
      expect(deleted, 1);
      expect(await db.getAllEquipments(), isEmpty);
    });

    test('increment equipment useCount', () async {
      final id = await db.insertEquipment(makeEquipCompanion());
      await db.incrementEquipmentUseCount(id);
      await db.incrementEquipmentUseCount(id);

      final all = await db.getAllEquipments();
      expect(all.first.useCount, 2);
    });

    test('searchEquipments case-insensitive match', () async {
      await db.insertEquipment(makeEquipCompanion(name: 'Comandante C40'));
      await db.insertEquipment(makeEquipCompanion(name: 'Hario V60'));

      final results = await db.searchEquipments('hario');
      expect(results.length, 1);
      expect(results.first.name, 'Hario V60');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BrewRecord CRUD
  // ─────────────────────────────────────────────────────────────────────────

  group('BrewRecord CRUD', () {
    test('insert and retrieve brew record', () async {
      final id = await db.insertBrewRecord(makeBrewCompanion());
      expect(id, greaterThan(0));

      final all = await db.getAllBrewRecords();
      expect(all.length, 1);
      expect(all.first.beanName, 'Ethiopia Yirgacheffe');
      expect(all.first.coffeeWeightG, 15.0);
    });

    test('getBrewRecordById returns null for missing id', () async {
      final result = await db.getBrewRecordById(99999);
      expect(result, isNull);
    });

    test('update brew record', () async {
      final id = await db.insertBrewRecord(makeBrewCompanion());
      final record = (await db.getAllBrewRecords()).first;

      await db.updateBrewRecord(
        record
            .toCompanion(true)
            .copyWith(id: Value(id), notes: const Value('Tasted great!')),
      );

      final updated = await db.getBrewRecordById(id);
      expect(updated?.notes, 'Tasted great!');
    });

    test('delete brew record', () async {
      final id = await db.insertBrewRecord(makeBrewCompanion());
      final deleted = await db.deleteBrewRecord(id);
      expect(deleted, 1);
      expect(await db.getAllBrewRecords(), isEmpty);
    });

    test('brew records ordered newest first', () async {
      final now = DateTime.now();
      await db.insertBrewRecord(
        BrewRecordsCompanion.insert(
          brewDate: now.subtract(const Duration(days: 2)),
          beanName: 'Old Bean',
          coffeeWeightG: 15,
          waterWeightG: 225,
          brewDurationS: 180,
        ),
      );
      await db.insertBrewRecord(
        BrewRecordsCompanion.insert(
          brewDate: now,
          beanName: 'New Bean',
          coffeeWeightG: 15,
          waterWeightG: 225,
          brewDurationS: 180,
        ),
      );

      final records = await db.getAllBrewRecords();
      expect(records.first.beanName, 'New Bean');
    });

    test('watchAllBrewRecords emits updates after insert', () async {
      // Insert first, then verify the stream emits the new record.
      await db.insertBrewRecord(makeBrewCompanion());

      // The stream should emit a list with exactly 1 record.
      final result = await db.watchAllBrewRecords().first;
      expect(result, hasLength(1));
      expect(result.first.beanName, 'Ethiopia Yirgacheffe');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BrewRecord ↔ Equipment FK linkage
  // ─────────────────────────────────────────────────────────────────────────

  group('BrewRecord → Equipment FK', () {
    test('brew record can reference equipment', () async {
      final eqId = await db.insertEquipment(makeEquipCompanion());
      final recId = await db.insertBrewRecord(
        makeBrewCompanion(equipmentId: eqId),
      );

      final record = await db.getBrewRecordById(recId);
      expect(record?.equipmentId, eqId);
    });

    test('grindMode fields stored correctly (equipment mode)', () async {
      final eqId = await db.insertEquipment(makeEquipCompanion());
      await db.insertBrewRecord(
        makeBrewCompanion(equipmentId: eqId).copyWith(
          grindMode: const Value('equipment'),
          grindClickValue: const Value(24.5),
        ),
      );

      final record = (await db.getAllBrewRecords()).first;
      expect(record.grindMode, 'equipment');
      expect(record.grindClickValue, 24.5);
      expect(record.grindSimpleLabel, isNull);
      expect(record.grindMicrons, isNull);
    });

    test('grindMode fields stored correctly (simple mode)', () async {
      await db.insertBrewRecord(
        makeBrewCompanion().copyWith(
          grindMode: const Value('simple'),
          grindSimpleLabel: const Value('Medium'),
        ),
      );

      final record = (await db.getAllBrewRecords()).first;
      expect(record.grindMode, 'simple');
      expect(record.grindSimpleLabel, 'Medium');
      expect(record.grindClickValue, isNull);
    });

    test('grindMode fields stored correctly (pro mode)', () async {
      await db.insertBrewRecord(
        makeBrewCompanion().copyWith(
          grindMode: const Value('pro'),
          grindMicrons: const Value(600),
        ),
      );

      final record = (await db.getAllBrewRecords()).first;
      expect(record.grindMode, 'pro');
      expect(record.grindMicrons, 600);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BrewRating CRUD
  // ─────────────────────────────────────────────────────────────────────────

  group('BrewRating CRUD', () {
    late int brewId;

    setUp(() async {
      brewId = await db.insertBrewRecord(makeBrewCompanion());
    });

    test('insert and retrieve rating', () async {
      final ratingId = await db.insertRating(
        BrewRatingsCompanion.insert(
          brewRecordId: brewId,
          quickScore: const Value(5),
          emoji: const Value('😊'),
        ),
      );

      expect(ratingId, greaterThan(0));

      final rating = await db.getRatingForBrew(brewId);
      expect(rating, isNotNull);
      expect(rating!.quickScore, 5);
      expect(rating.emoji, '😊');
    });

    test('update rating', () async {
      await db.insertRating(
        BrewRatingsCompanion.insert(
          brewRecordId: brewId,
          quickScore: const Value(3),
        ),
      );

      final rating = await db.getRatingForBrew(brewId);
      await db.updateRating(
        rating!.toCompanion(true).copyWith(quickScore: const Value(4)),
      );

      final updated = await db.getRatingForBrew(brewId);
      expect(updated?.quickScore, 4);
    });

    test('professional rating dimensions stored correctly', () async {
      await db.insertRating(
        BrewRatingsCompanion.insert(
          brewRecordId: brewId,
          acidity: const Value(3.5),
          sweetness: const Value(4.0),
          bitterness: const Value(2.0),
          body: const Value(3.0),
          flavorNotes: const Value('Citrus, Floral'),
        ),
      );

      final rating = await db.getRatingForBrew(brewId);
      expect(rating?.acidity, 3.5);
      expect(rating?.sweetness, 4.0);
      expect(rating?.bitterness, 2.0);
      expect(rating?.body, 3.0);
      expect(rating?.flavorNotes, 'Citrus, Floral');
    });

    test('getRatingForBrew returns null when unrated', () async {
      final rating = await db.getRatingForBrew(brewId);
      expect(rating, isNull);
    });

    test('delete rating by id', () async {
      final ratingId = await db.insertRating(
        BrewRatingsCompanion.insert(brewRecordId: brewId),
      );
      final deleted = await db.deleteRating(ratingId);
      expect(deleted, 1);
      expect(await db.getRatingForBrew(brewId), isNull);
    });

    test(
      'cascade delete: deleting BrewRecord also deletes its BrewRating',
      () async {
        await db.insertRating(
          BrewRatingsCompanion.insert(
            brewRecordId: brewId,
            quickScore: const Value(4),
          ),
        );

        // Confirm rating exists
        expect(await db.getRatingForBrew(brewId), isNotNull);

        // Delete the parent brew record
        await db.deleteBrewRecord(brewId);

        // Rating should cascade-delete
        expect(await db.getRatingForBrew(brewId), isNull);
      },
    );

    test(
      'brew record can have at most one rating (unique constraint)',
      () async {
        await db.insertRating(
          BrewRatingsCompanion.insert(
            brewRecordId: brewId,
            quickScore: const Value(5),
          ),
        );

        expect(
          () => db.insertRating(
            BrewRatingsCompanion.insert(
              brewRecordId: brewId,
              quickScore: const Value(3),
            ),
          ),
          throwsA(anything),
        );
      },
    );
  });
}
