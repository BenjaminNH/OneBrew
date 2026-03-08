import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/brew_summary.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/filter_brews.dart';
import '../../domain/usecases/get_brew_history.dart';
import '../../domain/usecases/get_top_brews.dart';
import '../../history_providers.dart';

class HistoryStats {
  const HistoryStats({
    required this.totalBrews,
    required this.ratedBrews,
    required this.averageQuickScore,
    required this.bestQuickScore,
  });

  const HistoryStats.empty()
    : totalBrews = 0,
      ratedBrews = 0,
      averageQuickScore = null,
      bestQuickScore = null;

  final int totalBrews;
  final int ratedBrews;
  final double? averageQuickScore;
  final int? bestQuickScore;
}

class HistoryState {
  const HistoryState({
    this.isLoading = false,
    this.filter = const BrewFilter(),
    this.allBrews = const <BrewSummary>[],
    this.visibleBrews = const <BrewSummary>[],
    this.topBrews = const <BrewSummary>[],
    this.errorMessage,
  });

  final bool isLoading;
  final BrewFilter filter;
  final List<BrewSummary> allBrews;
  final List<BrewSummary> visibleBrews;
  final List<BrewSummary> topBrews;
  final String? errorMessage;

  HistoryStats get stats {
    if (visibleBrews.isEmpty) return const HistoryStats.empty();
    final rated = visibleBrews
        .where((brew) => brew.quickScore != null)
        .map((brew) => brew.quickScore!)
        .toList();
    if (rated.isEmpty) {
      return HistoryStats(
        totalBrews: visibleBrews.length,
        ratedBrews: 0,
        averageQuickScore: null,
        bestQuickScore: null,
      );
    }
    final sum = rated.reduce((a, b) => a + b);
    final best = rated.reduce(math.max);
    return HistoryStats(
      totalBrews: visibleBrews.length,
      ratedBrews: rated.length,
      averageQuickScore: sum / rated.length,
      bestQuickScore: best,
    );
  }

  HistoryState copyWith({
    bool? isLoading,
    BrewFilter? filter,
    List<BrewSummary>? allBrews,
    List<BrewSummary>? visibleBrews,
    List<BrewSummary>? topBrews,
    Object? errorMessage = _sentinel,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
      allBrews: allBrews ?? this.allBrews,
      visibleBrews: visibleBrews ?? this.visibleBrews,
      topBrews: topBrews ?? this.topBrews,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _sentinel = Object();

class HistoryController extends Notifier<HistoryState> {
  late GetBrewHistory _getBrewHistory;
  late FilterBrews _filterBrews;
  late GetTopBrews _getTopBrews;

  @override
  HistoryState build() {
    final repo = ref.watch(historyRepositoryProvider);
    _getBrewHistory = GetBrewHistory(repo);
    _filterBrews = FilterBrews(repo);
    _getTopBrews = GetTopBrews(repo);
    return const HistoryState(isLoading: true);
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final all = await _getBrewHistory();
      final top = await _getTopBrews(limit: 5);
      final visible = state.filter.isEmpty
          ? all
          : await _filterBrews(state.filter);
      state = state.copyWith(
        isLoading: false,
        allBrews: all,
        visibleBrews: visible,
        topBrews: top,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load history: $e',
      );
    }
  }

  Future<void> applyFilter(BrewFilter filter) async {
    state = state.copyWith(isLoading: true, filter: filter, errorMessage: null);
    try {
      final visible = await _filterBrews(filter);
      state = state.copyWith(isLoading: false, visibleBrews: visible);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to filter history: $e',
      );
    }
  }

  Future<void> clearFilter() async {
    const resetFilter = BrewFilter();
    state = state.copyWith(
      isLoading: true,
      filter: resetFilter,
      errorMessage: null,
    );
    try {
      final all = await _getBrewHistory();
      state = state.copyWith(
        isLoading: false,
        allBrews: all,
        visibleBrews: all,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to reset history filter: $e',
      );
    }
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

final historyControllerProvider =
    NotifierProvider<HistoryController, HistoryState>(HistoryController.new);
