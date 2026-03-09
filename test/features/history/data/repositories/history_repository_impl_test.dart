import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/core/database/drift_database.dart';
import 'package:one_coffee/features/history/data/datasources/history_local_datasource.dart';
import 'package:one_coffee/features/history/data/repositories/history_repository_impl.dart';
import 'package:one_coffee/features/history/domain/repositories/history_repository.dart';

void main() {
  late OneCoffeeDatabase db;
  late HistoryLocalDatasource datasource;
  late HistoryRepositoryImpl repository;

  setUp(() {
    db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
    datasource = HistoryLocalDatasource(db);
    repository = HistoryRepositoryImpl(datasource);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedBean(
    String name, {
    String? roaster,
    String? origin,
    String? roastLevel,
  }) async {
    await db.insertBean(
      BeansCompanion.insert(
        name: name,
        roaster: roaster == null
            ? const drift.Value.absent()
            : drift.Value(roaster),
        origin: origin == null
            ? const drift.Value.absent()
            : drift.Value(origin),
        roastLevel: roastLevel == null
            ? const drift.Value.absent()
            : drift.Value(roastLevel),
      ),
    );
  }

  Future<int> seedBrew({required DateTime brewDate, required String beanName}) {
    return db.insertBrewRecord(
      BrewRecordsCompanion.insert(
        brewDate: brewDate,
        beanName: beanName,
        grindMode: const drift.Value('equipment'),
        coffeeWeightG: 15,
        waterWeightG: 240,
        brewDurationS: 180,
        isQuickMode: const drift.Value(true),
        createdAt: drift.Value(brewDate),
        updatedAt: drift.Value(brewDate),
      ),
    );
  }

  Future<int> seedEquipment({
    required String name,
    bool isGrinder = true,
    double? minClick = 10,
    double? maxClick = 30,
    double? step = 0.5,
    String? unit = 'clicks',
  }) {
    return db.insertEquipment(
      EquipmentsCompanion.insert(
        name: name,
        isGrinder: drift.Value(isGrinder),
        grindMinClick: drift.Value(minClick),
        grindMaxClick: drift.Value(maxClick),
        grindClickStep: drift.Value(step),
        grindClickUnit: drift.Value(unit),
      ),
    );
  }

  Future<int> seedBrewWithCompanion(BrewRecordsCompanion companion) {
    return db.insertBrewRecord(companion);
  }

  Future<void> seedRating(
    int brewRecordId,
    int quickScore, {
    String emoji = '🙂',
  }) {
    return db.insertRating(
      BrewRatingsCompanion.insert(
        brewRecordId: brewRecordId,
        quickScore: drift.Value(quickScore),
        emoji: drift.Value(emoji),
      ),
    );
  }

  group('HistoryRepositoryImpl filtering', () {
    test('filters by bean, score, and date range', () async {
      await seedBean('Ethiopia Yirgacheffe', roaster: 'Roaster A');
      await seedBean('Colombia Huila', roaster: 'Roaster B');

      final ethiopiaRecent = await seedBrew(
        brewDate: DateTime(2026, 3, 1, 9, 0),
        beanName: 'Ethiopia Yirgacheffe',
      );
      final colombiaRecent = await seedBrew(
        brewDate: DateTime(2026, 3, 2, 9, 0),
        beanName: 'Colombia Huila',
      );
      final ethiopiaOld = await seedBrew(
        brewDate: DateTime(2026, 1, 15, 9, 0),
        beanName: 'Ethiopia Yirgacheffe',
      );

      await seedRating(ethiopiaRecent, 4);
      await seedRating(colombiaRecent, 5);
      await seedRating(ethiopiaOld, 5);

      final result = await repository.filterBrewSummaries(
        BrewFilter(
          beanName: 'ethiopia',
          minScore: 4,
          maxScore: 4,
          from: DateTime(2026, 2, 1),
          to: DateTime(2026, 3, 31, 23, 59, 59),
        ),
      );

      expect(result, hasLength(1));
      expect(result.single.beanName, 'Ethiopia Yirgacheffe');
      expect(result.single.quickScore, 4);
      expect(result.single.roaster, 'Roaster A');
    });
  });

  group('HistoryRepositoryImpl top brews', () {
    test('returns top brews by score desc, then date desc', () async {
      await seedBean('Bean A');
      await seedBean('Bean B');
      await seedBean('Bean C');

      final score4 = await seedBrew(
        brewDate: DateTime(2026, 3, 1, 10, 0),
        beanName: 'Bean A',
      );
      final score5Older = await seedBrew(
        brewDate: DateTime(2026, 3, 2, 10, 0),
        beanName: 'Bean B',
      );
      final score5Newer = await seedBrew(
        brewDate: DateTime(2026, 3, 3, 10, 0),
        beanName: 'Bean C',
      );

      await seedRating(score4, 4);
      await seedRating(score5Older, 5);
      await seedRating(score5Newer, 5);

      final result = await repository.getTopBrews(limit: 2);

      expect(result, hasLength(2));
      expect(result.first.beanName, 'Bean C');
      expect(result.first.quickScore, 5);
      expect(result[1].beanName, 'Bean B');
      expect(result[1].quickScore, 5);
    });
  });

  group('HistoryRepositoryImpl detail query', () {
    test('maps brew + bean + equipment + rating into full detail', () async {
      await seedBean(
        'Ethiopia Yirgacheffe',
        roaster: 'Roaster A',
        origin: 'Ethiopia',
        roastLevel: 'Light',
      );
      final equipmentId = await seedEquipment(
        name: 'Comandante C40',
        minClick: 10,
        maxClick: 30,
        step: 0.5,
        unit: '格',
      );
      final brewId = await seedBrewWithCompanion(
        BrewRecordsCompanion.insert(
          brewDate: DateTime(2026, 3, 7, 9, 30),
          beanName: 'Ethiopia Yirgacheffe',
          equipmentId: drift.Value(equipmentId),
          grindMode: const drift.Value('equipment'),
          grindClickValue: const drift.Value(22.5),
          coffeeWeightG: 18.0,
          waterWeightG: 288.0,
          waterTempC: const drift.Value(92.0),
          brewDurationS: 195,
          bloomTimeS: const drift.Value(30),
          pourMethod: const drift.Value('Pulse'),
          waterType: const drift.Value('Filtered'),
          roomTempC: const drift.Value(24.0),
          notes: const drift.Value('Very sweet finish'),
          isQuickMode: const drift.Value(false),
          createdAt: drift.Value(DateTime(2026, 3, 7, 9, 31)),
          updatedAt: drift.Value(DateTime(2026, 3, 7, 9, 32)),
        ),
      );
      await db.insertRating(
        BrewRatingsCompanion.insert(
          brewRecordId: brewId,
          quickScore: const drift.Value(5),
          emoji: const drift.Value('😍'),
          acidity: const drift.Value(3.5),
          sweetness: const drift.Value(4.5),
          bitterness: const drift.Value(1.5),
          body: const drift.Value(3.0),
          flavorNotes: const drift.Value('jasmine,citrus'),
        ),
      );

      final result = await repository.getBrewDetailById(brewId);

      expect(result, isNotNull);
      expect(result!.id, brewId);
      expect(result.beanName, 'Ethiopia Yirgacheffe');
      expect(result.roaster, 'Roaster A');
      expect(result.origin, 'Ethiopia');
      expect(result.roastLevel, 'Light');
      expect(result.equipmentName, 'Comandante C40');
      expect(result.grindClickValue, 22.5);
      expect(result.grindClickUnit, '格');
      expect(result.quickScore, 5);
      expect(result.emoji, '😍');
      expect(result.flavorNotes, 'jasmine,citrus');
      expect(result.notes, 'Very sweet finish');
    });

    test('returns null for unknown brew id', () async {
      final result = await repository.getBrewDetailById(999);
      expect(result, isNull);
    });
  });
}
