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

    test('start() begins the timer and transitions state', () async {
      getController().start();

      var state = getState();
      expect(state.isRunning, true);
      expect(state.isPaused, false);

      // Wait slightly over 1 second to ensure it ticks
      await Future.delayed(const Duration(milliseconds: 1100));

      state = getState();
      expect(state.elapsedSeconds, greaterThanOrEqualTo(1));
    });

    test('pause() stops the timer and preserves elapsed time', () async {
      getController().start();
      await Future.delayed(const Duration(milliseconds: 1100));
      getController().pause();

      final stateWhenPaused = getState();
      expect(stateWhenPaused.isRunning, false);
      expect(stateWhenPaused.isPaused, true);

      final elapsed = stateWhenPaused.elapsedSeconds;
      expect(elapsed, greaterThanOrEqualTo(1));

      // Wait a bit and check it doesn't increase
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(getState().elapsedSeconds, elapsed);
    });

    test('reset() clears all accumulated time and state', () async {
      getController().start();
      await Future.delayed(const Duration(milliseconds: 1100));
      getController().reset();

      final state = getState();
      expect(state.isRunning, false);
      expect(state.isPaused, false);
      expect(state.elapsedSeconds, 0);
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
  });
}
