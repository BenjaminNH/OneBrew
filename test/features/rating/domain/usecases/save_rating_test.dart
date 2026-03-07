import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/features/rating/domain/usecases/save_rating.dart';

import '../../../../helpers/mock_repositories.mocks.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockRatingRepository mockRepo;
  late SaveRating saveRating;

  setUp(() {
    mockRepo = MockRatingRepository();
    saveRating = SaveRating(mockRepo);
  });

  group('SaveRating (create path)', () {
    test('calls createRating when id == 0 and returns new id', () async {
      final rating = TestFixtures.quickRating(id: 0, brewRecordId: 1);
      when(mockRepo.createRating(rating)).thenAnswer((_) async => 99);

      final result = await saveRating(rating);

      expect(result, 99);
      verify(mockRepo.createRating(rating)).called(1);
      verifyNever(mockRepo.updateRating(any));
    });

    test('creates rating with negative id (also treated as new)', () async {
      // id <= 0 means "not yet persisted"
      final rating = TestFixtures.quickRating(id: -1, brewRecordId: 2);
      when(mockRepo.createRating(rating)).thenAnswer((_) async => 3);

      final result = await saveRating(rating);

      expect(result, 3);
      verify(mockRepo.createRating(rating)).called(1);
    });
  });

  group('SaveRating (update path)', () {
    test('calls updateRating when id > 0 and returns existing id', () async {
      final rating = TestFixtures.quickRating(id: 5, brewRecordId: 1);
      when(mockRepo.updateRating(rating)).thenAnswer((_) async => true);

      final result = await saveRating(rating);

      expect(result, 5);
      verify(mockRepo.updateRating(rating)).called(1);
      verifyNever(mockRepo.createRating(any));
    });
  });

  group('SaveRating (professional rating)', () {
    test('creates a professional rating successfully', () async {
      final rating = TestFixtures.proRating(id: 0, brewRecordId: 3);
      when(mockRepo.createRating(rating)).thenAnswer((_) async => 11);

      final result = await saveRating(rating);

      expect(result, 11);
      // Verify acidity field passed through
      final captured = verify(
        mockRepo.createRating(captureAny),
      ).captured.single;
      expect((captured as dynamic).acidity, 7.0);
    });
  });
}
