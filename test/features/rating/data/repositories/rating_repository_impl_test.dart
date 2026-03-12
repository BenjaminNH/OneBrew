import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/core/database/drift_database.dart';
import 'package:one_coffee/features/rating/data/datasources/rating_local_datasource.dart';
import 'package:one_coffee/features/rating/data/repositories/rating_repository_impl.dart';
import 'package:one_coffee/features/rating/domain/entities/brew_rating.dart'
    as domain;

void main() {
  late OneCoffeeDatabase db;
  late RatingLocalDatasourceImpl datasource;
  late RatingRepositoryImpl repository;

  setUp(() {
    db = OneCoffeeDatabase.forTesting(NativeDatabase.memory());
    datasource = RatingLocalDatasourceImpl(db);
    repository = RatingRepositoryImpl(datasource);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> seedBrewRecord() async {
    final now = DateTime(2026, 3, 8, 10, 0);
    return db.insertBrewRecord(
      BrewRecordsCompanion.insert(
        brewDate: now,
        beanName: 'Test Bean',
        grindMode: const drift.Value('equipment'),
        coffeeWeightG: 15,
        waterWeightG: 240,
        brewDurationS: 180,
        createdAt: drift.Value(now),
        updatedAt: drift.Value(now),
      ),
    );
  }

  group('RatingRepositoryImpl quick mode CRUD', () {
    test('create/get/update/delete quick rating', () async {
      final brewRecordId = await seedBrewRecord();

      final createdId = await repository.createRating(
        domain.BrewRating(
          id: 0,
          brewRecordId: brewRecordId,
          quickScore: 4,
          emoji: '🙂',
        ),
      );
      expect(createdId, isPositive);

      final created = await repository.getRatingForBrew(brewRecordId);
      expect(created, isNotNull);
      expect(created!.quickScore, 4);
      expect(created.emoji, '🙂');

      final updated = created.copyWith(quickScore: 5, emoji: '😍');
      final updateResult = await repository.updateRating(updated);
      expect(updateResult, isTrue);

      final afterUpdate = await repository.getRatingForBrew(brewRecordId);
      expect(afterUpdate, isNotNull);
      expect(afterUpdate!.quickScore, 5);
      expect(afterUpdate.emoji, '😍');

      final deletedRows = await repository.deleteRating(createdId);
      expect(deletedRows, 1);
      expect(await repository.getRatingForBrew(brewRecordId), isNull);
    });
  });

  group('RatingRepositoryImpl professional mode CRUD', () {
    test('create and read professional rating', () async {
      final brewRecordId = await seedBrewRecord();

      final createdId = await repository.createRating(
        domain.BrewRating(
          id: 0,
          brewRecordId: brewRecordId,
          acidity: 7.5,
          sweetness: 6.5,
          bitterness: 3.0,
          body: 5.5,
          flavorNotes: 'Citrus,Floral',
        ),
      );
      expect(createdId, isPositive);

      final rating = await repository.getRatingForBrew(brewRecordId);
      expect(rating, isNotNull);
      expect(rating!.acidity, 7.5);
      expect(rating.sweetness, 6.5);
      expect(rating.bitterness, 3.0);
      expect(rating.body, 5.5);
      expect(rating.flavorNotes, 'Citrus,Floral');
    });
  });

  group('RatingRepositoryImpl validation', () {
    test('rejects quickScore below 1', () async {
      final brewRecordId = await seedBrewRecord();
      await expectLater(
        () => repository.createRating(
          domain.BrewRating(
            id: 0,
            brewRecordId: brewRecordId,
            quickScore: 0,
            emoji: '😐',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects quickScore above 5', () async {
      final brewRecordId = await seedBrewRecord();
      await expectLater(
        () => repository.createRating(
          domain.BrewRating(
            id: 0,
            brewRecordId: brewRecordId,
            quickScore: 6,
            emoji: '😐',
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
