import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State held by [BrewTimerController].
class BrewTimerState {
  const BrewTimerState({
    this.elapsedSeconds = 0,
    this.targetSeconds,
    this.bloomSeconds = 0,
    this.isRunning = false,
    this.isCountingDown = false,
    this.isPaused = false,
  });

  final int elapsedSeconds;
  final int? targetSeconds;
  final int bloomSeconds;
  final bool isRunning;
  final bool isCountingDown;
  final bool isPaused;

  bool get isOvertime =>
      targetSeconds != null && elapsedSeconds > targetSeconds!;

  int get remainingSeconds => targetSeconds == null
      ? 0
      : (targetSeconds! - elapsedSeconds).clamp(0, targetSeconds!);

  bool get isInBloom => bloomSeconds > 0 && elapsedSeconds < bloomSeconds;

  BrewTimerState copyWith({
    int? elapsedSeconds,
    Object? targetSeconds = _sentinel,
    int? bloomSeconds,
    bool? isRunning,
    bool? isCountingDown,
    bool? isPaused,
  }) {
    return BrewTimerState(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      targetSeconds: targetSeconds == _sentinel
          ? this.targetSeconds
          : targetSeconds as int?,
      bloomSeconds: bloomSeconds ?? this.bloomSeconds,
      isRunning: isRunning ?? this.isRunning,
      isCountingDown: isCountingDown ?? this.isCountingDown,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

const _sentinel = Object();

/// Controller for the brew timer.
///
/// Uses [Notifier] from Riverpod 3.x for synchronous state management.
/// Ref: docs/05_Development_Plan.md § Phase 4 — brew_timer_controller
class BrewTimerController extends Notifier<BrewTimerState> {
  Timer? _ticker;
  DateTime? _startWallClock;
  int _accumulatedSeconds = 0;

  @override
  BrewTimerState build() {
    ref.onDispose(() => _ticker?.cancel());
    return const BrewTimerState();
  }

  void start() {
    if (state.isRunning) return;
    _startWallClock = DateTime.now();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), _onTick);
    state = state.copyWith(isRunning: true, isPaused: false);
  }

  void pause() {
    if (!state.isRunning) return;
    _ticker?.cancel();
    _ticker = null;
    _accumulatedSeconds = state.elapsedSeconds;
    _startWallClock = null;
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  void reset() {
    _ticker?.cancel();
    _ticker = null;
    _startWallClock = null;
    _accumulatedSeconds = 0;
    state = const BrewTimerState();
  }

  void setTarget({int? targetSeconds, int bloomSeconds = 0}) {
    state = state.copyWith(
      targetSeconds: targetSeconds,
      bloomSeconds: bloomSeconds,
    );
  }

  void toggleCountingDown() {
    state = state.copyWith(isCountingDown: !state.isCountingDown);
  }

  void _onTick(Timer _) {
    final wallElapsed = DateTime.now().difference(_startWallClock!).inSeconds;
    state = state.copyWith(elapsedSeconds: _accumulatedSeconds + wallElapsed);
  }
}

/// Riverpod provider for [BrewTimerController].
final brewTimerControllerProvider =
    NotifierProvider<BrewTimerController, BrewTimerState>(
      BrewTimerController.new,
    );
