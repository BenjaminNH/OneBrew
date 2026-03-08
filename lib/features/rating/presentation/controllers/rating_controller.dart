import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/brew_rating.dart';
import '../../domain/usecases/save_rating.dart';
import '../../rating_providers.dart';
import '../constants/rating_presets.dart';

class RatingState {
  const RatingState({
    this.ratingId = 0,
    this.brewRecordId,
    this.isQuickMode = true,
    this.quickScore,
    this.emoji,
    this.acidity = 5.0,
    this.sweetness = 5.0,
    this.bitterness = 5.0,
    this.body = 5.0,
    this.flavorNotes = const <String>{},
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  });

  final int ratingId;
  final int? brewRecordId;
  final bool isQuickMode;
  final int? quickScore;
  final String? emoji;
  final double acidity;
  final double sweetness;
  final double bitterness;
  final double body;
  final Set<String> flavorNotes;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;

  bool get hasExistingRating => ratingId > 0;

  RatingState copyWith({
    int? ratingId,
    Object? brewRecordId = _sentinel,
    bool? isQuickMode,
    Object? quickScore = _sentinel,
    Object? emoji = _sentinel,
    double? acidity,
    double? sweetness,
    double? bitterness,
    double? body,
    Set<String>? flavorNotes,
    bool? isLoading,
    bool? isSaving,
    Object? errorMessage = _sentinel,
  }) {
    return RatingState(
      ratingId: ratingId ?? this.ratingId,
      brewRecordId: brewRecordId == _sentinel
          ? this.brewRecordId
          : brewRecordId as int?,
      isQuickMode: isQuickMode ?? this.isQuickMode,
      quickScore: quickScore == _sentinel
          ? this.quickScore
          : quickScore as int?,
      emoji: emoji == _sentinel ? this.emoji : emoji as String?,
      acidity: acidity ?? this.acidity,
      sweetness: sweetness ?? this.sweetness,
      bitterness: bitterness ?? this.bitterness,
      body: body ?? this.body,
      flavorNotes: flavorNotes ?? this.flavorNotes,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _sentinel = Object();

final saveRatingProvider = Provider<SaveRating>((ref) {
  return SaveRating(ref.watch(ratingRepositoryProvider));
});

class RatingController extends Notifier<RatingState> {
  @override
  RatingState build() => const RatingState();

  Future<void> initializeForBrew(int brewRecordId) async {
    state = RatingState(brewRecordId: brewRecordId, isLoading: true);

    try {
      final existing = await ref
          .read(ratingRepositoryProvider)
          .getRatingForBrew(brewRecordId);

      if (existing == null) {
        state = RatingState(brewRecordId: brewRecordId, isLoading: false);
        return;
      }

      final notes = _parseFlavorNotes(existing.flavorNotes);
      final hasProfessionalScores =
          existing.acidity != null ||
          existing.sweetness != null ||
          existing.bitterness != null ||
          existing.body != null ||
          notes.isNotEmpty;

      state = state.copyWith(
        isLoading: false,
        ratingId: existing.id,
        brewRecordId: existing.brewRecordId,
        isQuickMode: !hasProfessionalScores,
        quickScore: existing.quickScore,
        emoji: existing.emoji,
        acidity: existing.acidity ?? 5.0,
        sweetness: existing.sweetness ?? 5.0,
        bitterness: existing.bitterness ?? 5.0,
        body: existing.body ?? 5.0,
        flavorNotes: notes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load rating: $e',
      );
    }
  }

  void setQuickMode(bool isQuickMode) {
    state = state.copyWith(isQuickMode: isQuickMode, errorMessage: null);
  }

  void setQuickScore(int? score) {
    if (score != null && (score < 1 || score > 5)) {
      state = state.copyWith(errorMessage: 'Quick score must be in range 1-5.');
      return;
    }
    state = state.copyWith(quickScore: score, errorMessage: null);
  }

  void setEmoji(String? emoji) {
    if (emoji != null && !kRatingEmojis.contains(emoji)) {
      state = state.copyWith(errorMessage: 'Unsupported emoji selection.');
      return;
    }
    state = state.copyWith(emoji: emoji, errorMessage: null);
  }

  void setAcidity(double value) =>
      state = state.copyWith(acidity: value.clamp(0.0, 10.0));

  void setSweetness(double value) =>
      state = state.copyWith(sweetness: value.clamp(0.0, 10.0));

  void setBitterness(double value) =>
      state = state.copyWith(bitterness: value.clamp(0.0, 10.0));

  void setBody(double value) =>
      state = state.copyWith(body: value.clamp(0.0, 10.0));

  void toggleFlavorNote(String note) {
    final updated = {...state.flavorNotes};
    if (updated.contains(note)) {
      updated.remove(note);
    } else {
      updated.add(note);
    }
    state = state.copyWith(flavorNotes: updated);
  }

  Future<int?> save() async {
    final brewRecordId = state.brewRecordId;
    if (brewRecordId == null) {
      state = state.copyWith(
        errorMessage: 'No brew record selected for rating.',
      );
      return null;
    }

    if (state.quickScore != null &&
        (state.quickScore! < 1 || state.quickScore! > 5)) {
      state = state.copyWith(errorMessage: 'Quick score must be in range 1-5.');
      return null;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final rating = BrewRating(
        id: state.ratingId,
        brewRecordId: brewRecordId,
        quickScore: state.quickScore,
        emoji: state.emoji,
        acidity: state.isQuickMode ? null : state.acidity,
        sweetness: state.isQuickMode ? null : state.sweetness,
        bitterness: state.isQuickMode ? null : state.bitterness,
        body: state.isQuickMode ? null : state.body,
        flavorNotes: state.flavorNotes.isEmpty
            ? null
            : state.flavorNotes.join(','),
      );

      final savedId = await ref.read(saveRatingProvider).call(rating);
      state = state.copyWith(ratingId: savedId, isSaving: false);
      return savedId;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save rating: $e',
      );
      return null;
    }
  }

  Future<int> deleteCurrentRating() async {
    if (state.ratingId <= 0) return 0;
    final deleted = await ref
        .read(ratingRepositoryProvider)
        .deleteRating(state.ratingId);
    if (deleted > 0) {
      state = state.copyWith(
        ratingId: 0,
        quickScore: null,
        emoji: null,
        flavorNotes: const <String>{},
      );
    }
    return deleted;
  }

  void clearError() => state = state.copyWith(errorMessage: null);

  Set<String> _parseFlavorNotes(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const <String>{};
    return raw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet();
  }
}

final ratingControllerProvider =
    NotifierProvider<RatingController, RatingState>(RatingController.new);
