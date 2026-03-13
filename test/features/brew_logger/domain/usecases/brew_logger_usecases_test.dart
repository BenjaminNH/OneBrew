import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_brew/features/brew_logger/domain/entities/brew_record.dart';
import 'package:one_brew/features/brew_logger/domain/usecases/create_brew_record.dart';
import 'package:one_brew/features/brew_logger/domain/usecases/delete_brew_record.dart';
import 'package:one_brew/features/brew_logger/domain/usecases/update_brew_record.dart';

import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockBrewRepository mockRepo;
  late CreateBrewRecord createBrewRecord;
  late UpdateBrewRecord updateBrewRecord;
  late DeleteBrewRecord deleteBrewRecord;

  setUp(() {
    mockRepo = MockBrewRepository();
    createBrewRecord = CreateBrewRecord(mockRepo);
    updateBrewRecord = UpdateBrewRecord(mockRepo);
    deleteBrewRecord = DeleteBrewRecord(mockRepo);
  });

  group('CreateBrewRecord', () {
    test('delegates to repository and returns new id', () async {
      final record = TestFixtures.brewRecord(id: 0);
      when(mockRepo.createBrewRecord(record)).thenAnswer((_) async => 42);

      final result = await createBrewRecord(record);

      expect(result, 42);
      verify(mockRepo.createBrewRecord(record)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('passes all fields to the repository unchanged', () async {
      final record = TestFixtures.brewRecord(
        id: 0,
        beanName: 'Colombia Huila',
        grindMode: GrindMode.simple,
        grindClickValue: null,
      );
      when(mockRepo.createBrewRecord(record)).thenAnswer((_) async => 7);

      await createBrewRecord(record);

      final captured =
          verify(mockRepo.createBrewRecord(captureAny)).captured.single
              as BrewRecord;
      expect(captured.beanName, 'Colombia Huila');
      expect(captured.grindMode, GrindMode.simple);
    });
  });

  group('UpdateBrewRecord', () {
    test('delegates to repository and returns true on success', () async {
      final record = TestFixtures.brewRecord(id: 1);
      when(mockRepo.updateBrewRecord(record)).thenAnswer((_) async => true);

      final result = await updateBrewRecord(record);

      expect(result, isTrue);
      verify(mockRepo.updateBrewRecord(record)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns false when repository reports no row updated', () async {
      final record = TestFixtures.brewRecord(id: 999);
      when(mockRepo.updateBrewRecord(record)).thenAnswer((_) async => false);

      final result = await updateBrewRecord(record);

      expect(result, isFalse);
    });
  });

  group('DeleteBrewRecord', () {
    test('delegates to repository and returns deleted row count', () async {
      when(mockRepo.deleteBrewRecord(1)).thenAnswer((_) async => 1);

      final result = await deleteBrewRecord(1);

      expect(result, 1);
      verify(mockRepo.deleteBrewRecord(1)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns 0 when record does not exist', () async {
      when(mockRepo.deleteBrewRecord(999)).thenAnswer((_) async => 0);

      final result = await deleteBrewRecord(999);

      expect(result, 0);
    });
  });
}
