// Tests for BrewTimerController.
//
// P3 fix from CR_2026-03-08_Phase4_BrewLogger: replaced real-time
// Future.delayed waits with fake_async controllable clock so these tests
// are deterministic and run instantly in CI without flakiness.

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/features/brew_logger/presentation/controllers/brew_timer_controller.dart';

void main() {
  group('BrewTimerController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    BrewTimerController getController() =>
        container.read(brewTimerControllerProvider.notifier);

    BrewTimerState getState() => container.read(brewTimerControllerProvider);

    test('Initial state has default zeroed values', () {
      final state = getState();

      expect(state.elapsedSeconds, 0);
      expect(state.isRunning, false);
      expect(state.isPaused, false);
      expect(state.isCountingDown, false);
    });

    test('start() begins the timer and transitions state', () {
      fakeAsync((async) {
        getController().start();

        var state = getState();
        expect(state.isRunning, true);
        expect(state.isPaused, false);

        // Advance the fake clock by exactly 1 second so the Timer.periodic
        // fires once — no need to wait for real wall-clock time.
        async.elapse(const Duration(seconds: 1));

        state = getState();
        expect(state.elapsedSeconds, greaterThanOrEqualTo(1));
      });
    });

    test('pause() stops the timer and preserves elapsed time', () {
      fakeAsync((async) {
        getController().start();

        // Advance by 2 seconds to get non-zero elapsed time.
        async.elapse(const Duration(seconds: 2));
        getController().pause();

        final stateWhenPaused = getState();
        expect(stateWhenPaused.isRunning, false);
        expect(stateWhenPaused.isPaused, true);

        final elapsed = stateWhenPaused.elapsedSeconds;
        expect(elapsed, greaterThanOrEqualTo(2));

        // Advance more and check elapsed does not increase while paused.
        async.elapse(const Duration(seconds: 2));
        expect(getState().elapsedSeconds, elapsed);
      });
    });

    test('reset() clears all accumulated time and state', () {
      fakeAsync((async) {
        getController().start();
        async.elapse(const Duration(seconds: 2));
        getController().reset();

        final state = getState();
        expect(state.isRunning, false);
        expect(state.isPaused, false);
        expect(state.elapsedSeconds, 0);
      });
    });

    test('setTarget() updates targetSeconds and bloomSeconds', () {
      getController().setTarget(targetSeconds: 150, bloomSeconds: 30);

      final state = getState();
      expect(state.targetSeconds, 150);
      expect(state.bloomSeconds, 30);
    });

    test('toggleCountingDown() changes countdown boolean', () {
      final initialState = getState().isCountingDown;

      getController().toggleCountingDown();
      expect(getState().isCountingDown, !initialState);

      getController().toggleCountingDown();
      expect(getState().isCountingDown, initialState);
    });

    test('timer ticks each second while running', () {
      fakeAsync((async) {
        getController().start();
        async.elapse(const Duration(seconds: 5));

        expect(getState().elapsedSeconds, 5);
      });
    });
  });
}
