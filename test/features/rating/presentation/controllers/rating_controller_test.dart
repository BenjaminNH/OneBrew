import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:one_coffee/features/rating/data/repositories/rating_repository_impl.dart';
import 'package:one_coffee/features/rating/domain/entities/brew_rating.dart';
import 'package:one_coffee/features/rating/presentation/controllers/rating_controller.dart';

import '../../../../helpers/mock_repositories.mocks.dart';

void main() {
  late MockRatingRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockRatingRepository();
    container = ProviderContainer(
      overrides: [ratingRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('quickScore validates 1-5 range', () {
    final notifier = container.read(ratingControllerProvider.notifier);
    notifier.setQuickScore(6);
    final state = container.read(ratingControllerProvider);
    expect(state.quickScore, isNull);
    expect(state.errorMessage, contains('1-5'));
  });

  test('emoji selection accepts supported emoji and rejects unsupported', () {
    final notifier = container.read(ratingControllerProvider.notifier);

    notifier.setEmoji('😍');
    expect(container.read(ratingControllerProvider).emoji, '😍');

    notifier.setEmoji('abc');
    final state = container.read(ratingControllerProvider);
    expect(state.emoji, '😍');
    expect(state.errorMessage, contains('Unsupported emoji'));
  });

  test('save creates new rating for selected brew record', () async {
    when(mockRepo.getRatingForBrew(101)).thenAnswer((_) async => null);
    when(mockRepo.createRating(any)).thenAnswer((_) async => 7);

    final notifier = container.read(ratingControllerProvider.notifier);
    await notifier.initializeForBrew(101);
    notifier.setQuickScore(4);
    notifier.setEmoji('🙂');

    final id = await notifier.save();

    expect(id, 7);
    verify(mockRepo.createRating(any)).called(1);
  });

  test('save updates existing rating when present', () async {
    when(mockRepo.getRatingForBrew(202)).thenAnswer(
      (_) async => const BrewRating(id: 5, brewRecordId: 202, quickScore: 3),
    );
    when(mockRepo.updateRating(any)).thenAnswer((_) async => true);

    final notifier = container.read(ratingControllerProvider.notifier);
    await notifier.initializeForBrew(202);
    notifier.setQuickScore(5);

    final id = await notifier.save();

    expect(id, 5);
    verify(mockRepo.updateRating(any)).called(1);
  });

  test(
    'initializeForBrew resets stale state when no existing rating',
    () async {
      when(mockRepo.getRatingForBrew(202)).thenAnswer(
        (_) async => const BrewRating(id: 5, brewRecordId: 202, quickScore: 3),
      );
      when(mockRepo.getRatingForBrew(303)).thenAnswer((_) async => null);

      final notifier = container.read(ratingControllerProvider.notifier);
      await notifier.initializeForBrew(202);
      notifier.setQuickScore(5);
      notifier.setEmoji('😍');
      notifier.toggleFlavorNote('Citrus');

      await notifier.initializeForBrew(303);

      final state = container.read(ratingControllerProvider);
      expect(state.brewRecordId, 303);
      expect(state.ratingId, 0);
      expect(state.quickScore, isNull);
      expect(state.emoji, isNull);
      expect(state.flavorNotes, isEmpty);
      expect(state.isQuickMode, isTrue);
    },
  );
}
