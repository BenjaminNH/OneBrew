import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/brew_detail.dart';
import '../../domain/usecases/get_brew_detail.dart';
import '../../history_providers.dart';

class BrewDetailState {
  const BrewDetailState({
    this.isLoading = false,
    this.detail,
    this.errorMessage,
  });

  final bool isLoading;
  final BrewDetail? detail;
  final String? errorMessage;

  BrewDetailState copyWith({
    bool? isLoading,
    Object? detail = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return BrewDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail == _sentinel ? this.detail : detail as BrewDetail?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _sentinel = Object();

class BrewDetailController extends Notifier<BrewDetailState> {
  BrewDetailController(this.brewId);

  final int brewId;
  late GetBrewDetail _getBrewDetail;

  @override
  BrewDetailState build() {
    final repository = ref.watch(historyRepositoryProvider);
    _getBrewDetail = GetBrewDetail(repository);
    Future.microtask(load);
    return const BrewDetailState(isLoading: true);
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final detail = await _getBrewDetail(brewId);
      if (detail == null) {
        state = state.copyWith(
          isLoading: false,
          detail: null,
          errorMessage: 'Brew record not found.',
        );
        return;
      }
      state = state.copyWith(isLoading: false, detail: detail);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        detail: null,
        errorMessage: 'Failed to load brew detail: $e',
      );
    }
  }
}

final brewDetailControllerProvider =
    NotifierProvider.family<BrewDetailController, BrewDetailState, int>(
      BrewDetailController.new,
    );
