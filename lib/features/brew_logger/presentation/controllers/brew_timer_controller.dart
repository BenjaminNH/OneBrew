import 'dart:async';

import 'package:flutter/widgets.dart';
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
  DateTime? _lastWallClockTickAt;

  /// Injectable wall-clock source for deterministic timer tests.
  @visibleForTesting
  static DateTime Function() now = DateTime.now;

  @override
  BrewTimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _ticker = null;
      _lastWallClockTickAt = null;
    });
    return const BrewTimerState();
  }

  void start() {
    if (state.isRunning) return;
    _ticker?.cancel();
    _lastWallClockTickAt = now();
    _ticker = Timer.periodic(const Duration(seconds: 1), _onTick);
    state = state.copyWith(isRunning: true, isPaused: false);
  }

  void pause() {
    if (!state.isRunning) return;
    _syncElapsedWithWallClock();
    _ticker?.cancel();
    _ticker = null;
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  void reset() {
    _ticker?.cancel();
    _ticker = null;
    _lastWallClockTickAt = null;
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

  /// Compensates elapsed time when app resumes from background suspension.
  void handleAppLifecycleStateChanged(AppLifecycleState lifecycleState) {
    if (!state.isRunning) return;
    if (lifecycleState == AppLifecycleState.resumed) {
      _syncElapsedWithWallClock();
    }
  }

  void _onTick(Timer _) {
    if (_syncElapsedWithWallClock()) return;

    // Fallback for environments where wall-clock is frozen (e.g. some test
    // harnesses) but periodic tick callbacks still fire.
    state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    _lastWallClockTickAt = now();
  }

  bool _syncElapsedWithWallClock() {
    final lastTickAt = _lastWallClockTickAt;
    final current = now();
    if (lastTickAt == null) {
      _lastWallClockTickAt = current;
      return false;
    }

    final deltaSeconds = current.difference(lastTickAt).inSeconds;
    if (deltaSeconds <= 0) return false;

    state = state.copyWith(elapsedSeconds: state.elapsedSeconds + deltaSeconds);
    _lastWallClockTickAt = lastTickAt.add(Duration(seconds: deltaSeconds));
    return true;
  }
}

/// Riverpod provider for [BrewTimerController].
final brewTimerControllerProvider =
    NotifierProvider<BrewTimerController, BrewTimerState>(
      BrewTimerController.new,
    );
