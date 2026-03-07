import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/core/database/drift_database.dart' as db;
import 'package:one_coffee/features/brew_logger/data/datasources/brew_local_datasource.dart';
import 'package:one_coffee/features/brew_logger/data/repositories/brew_repository_impl.dart';
import 'package:one_coffee/features/brew_logger/domain/entities/brew_record.dart'
    as domain;

class FakeBrewLocalDatasource implements BrewLocalDatasource {
  final List<db.BrewRecord> _records = [];
  bool shouldReturnNullForId = false;
  int insertedId = 42;
  bool updateResult = true;
  int deleteResult = 1;
  int deleteCalledWithId = -1;
  db.BrewRecordsCompanion? lastInsertedCompanion;
  db.BrewRecordsCompanion? lastUpdatedCompanion;

  void seedRecords(List<db.BrewRecord> records) {
    _records.clear();
    _records.addAll(records);
  }

  @override
  Future<List<db.BrewRecord>> getAllBrewRecords() async => _records;

  @override
  Stream<List<db.BrewRecord>> watchAllBrewRecords() async* {
    yield _records;
  }

  @override
  Future<db.BrewRecord?> getBrewRecordById(int id) async {
    if (shouldReturnNullForId) return null;
    return _records.cast<db.BrewRecord?>().firstWhere(
      (r) => r?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<int> insertBrewRecord(db.BrewRecordsCompanion record) async {
    lastInsertedCompanion = record;
    return insertedId;
  }

  @override
  Future<bool> updateBrewRecord(db.BrewRecordsCompanion record) async {
    lastUpdatedCompanion = record;
    return updateResult;
  }

  @override
  Future<int> deleteBrewRecord(int id) async {
    deleteCalledWithId = id;
    return deleteResult;
  }
}

void main() {
  group('BrewRepositoryImpl Tests', () {
    late FakeBrewLocalDatasource fakeDatasource;
    late BrewRepositoryImpl repository;

    setUp(() {
      fakeDatasource = FakeBrewLocalDatasource();
      repository = BrewRepositoryImpl(fakeDatasource);
    });

    final now = DateTime(2024, 1, 1);

    final dbRecord = db.BrewRecord(
      id: 1,
      brewDate: now,
      beanName: 'Test Bean',
      equipmentId: null,
      grindMode: 'equipment',
      grindClickValue: null,
      grindSimpleLabel: null,
      grindMicrons: null,
      coffeeWeightG: 15.0,
      waterWeightG: 250.0,
      waterTempC: null,
      brewDurationS: 180,
      bloomTimeS: null,
      pourMethod: null,
      waterType: null,
      roomTempC: null,
      notes: null,
      isQuickMode: true,
      createdAt: now,
      updatedAt: now,
    );

    final domainRecord = domain.BrewRecord(
      id: 1,
      brewDate: now,
      beanName: 'Test Bean',
      equipmentId: null,
      grindMode: domain.GrindMode.equipment,
      grindClickValue: null,
      grindSimpleLabel: null,
      grindMicrons: null,
      coffeeWeightG: 15.0,
      waterWeightG: 250.0,
      waterTempC: null,
      brewDurationS: 180,
      bloomTimeS: null,
      pourMethod: null,
      waterType: null,
      roomTempC: null,
      notes: null,
      isQuickMode: true,
      createdAt: now,
      updatedAt: now,
    );

    test('getAllBrewRecords correctly maps to domain entities', () async {
      fakeDatasource.seedRecords([dbRecord]);

      final results = await repository.getAllBrewRecords();

      expect(results.length, 1);
      final result = results.first;
      expect(result.id, 1);
      expect(result.beanName, 'Test Bean');
      expect(result.grindMode, domain.GrindMode.equipment);
    });

    test('getBrewRecordById returns domain mapped record or null', () async {
      fakeDatasource.seedRecords([dbRecord]);

      final found = await repository.getBrewRecordById(1);
      expect(found, isNotNull);
      expect(found?.beanName, 'Test Bean');

      final notFound = await repository.getBrewRecordById(99);
      expect(notFound, isNull);
    });

    test(
      'createBrewRecord sets valid timestamps and delegates to datasource',
      () async {
        final newId = await repository.createBrewRecord(domainRecord);

        expect(newId, 42);
        expect(fakeDatasource.lastInsertedCompanion, isNotNull);
        expect(
          fakeDatasource.lastInsertedCompanion!.beanName.value,
          'Test Bean',
        );
      },
    );

    test(
      'updateBrewRecord returns boolean success result and updates timestamp',
      () async {
        final success = await repository.updateBrewRecord(domainRecord);

        expect(success, isTrue);
        expect(fakeDatasource.lastUpdatedCompanion, isNotNull);
        expect(fakeDatasource.lastUpdatedCompanion!.id.value, 1);
      },
    );

    test('deleteBrewRecord calls datasource precisely with id', () async {
      final deleteCount = await repository.deleteBrewRecord(1234);

      expect(deleteCount, 1);
      expect(fakeDatasource.deleteCalledWithId, 1234);
    });
  });
}
