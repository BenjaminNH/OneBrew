/// OneBrew Timer Utilities
/// Provides helper functions for brew timer display and calculations.
/// Used by BrewTimerController and AppTimerDisplay widget.
abstract final class TimerUtils {
  // ─────────────────────────────────────────
  // Duration Formatting
  // ─────────────────────────────────────────

  /// Formats total seconds into "mm:ss" string
  /// e.g. 90 → "1:30", 65 → "1:05"
  static String formatSeconds(int totalSeconds) {
    final absSeconds = totalSeconds.abs();
    final minutes = absSeconds ~/ 60;
    final seconds = absSeconds % 60;
    final prefix = totalSeconds < 0 ? '-' : '';
    return '$prefix$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats total seconds into "mm:ss.t" (tenths precision)
  /// e.g. 90150ms → "1:30.1" — for precision displays
  static String formatMilliseconds(int totalMilliseconds) {
    final absMs = totalMilliseconds.abs();
    final minutes = absMs ~/ 60000;
    final seconds = (absMs % 60000) ~/ 1000;
    final tenths = (absMs % 1000) ~/ 100;
    final prefix = totalMilliseconds < 0 ? '-' : '';
    return '$prefix$minutes:${seconds.toString().padLeft(2, '0')}.$tenths';
  }

  /// Formats to "Xm Ys" verbose label (for history card display)
  /// e.g. 195 → "3m 15s"
  static String formatVerbose(int totalSeconds) {
    if (totalSeconds < 60) {
      return '${totalSeconds}s';
    }
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (seconds == 0) return '${minutes}m';
    return '${minutes}m ${seconds}s';
  }

  // ─────────────────────────────────────────
  // Brew Time Calculations
  // ─────────────────────────────────────────

  /// Calculates brew time progress ratio [0.0, 1.0] for arc/dial display.
  /// [elapsed] current elapsed seconds, [target] expected total brew seconds.
  /// Returns > 1.0 if elapsed exceeds target (over-extraction warning).
  static double progressRatio(int elapsedSeconds, int targetSeconds) {
    if (targetSeconds <= 0) return 0.0;
    return elapsedSeconds / targetSeconds;
  }

  /// Remaining seconds in countdown mode.
  /// Returns 0 if already past target.
  static int remainingSeconds(int elapsedSeconds, int targetSeconds) {
    final remaining = targetSeconds - elapsedSeconds;
    return remaining.clamp(0, targetSeconds);
  }

  /// Returns true if brew is in bloom phase.
  /// [elapsed] elapsed seconds, [bloomDuration] bloom time in seconds.
  static bool isInBloomPhase(int elapsedSeconds, int bloomDuration) {
    return bloomDuration > 0 && elapsedSeconds <= bloomDuration;
  }

  /// Returns phase label string for current timer state.
  static String phaseLabel({
    required int elapsedSeconds,
    required int bloomDuration,
    required int targetDuration,
  }) {
    if (bloomDuration > 0 && elapsedSeconds <= bloomDuration) {
      return 'Bloom';
    } else if (targetDuration > 0 && elapsedSeconds >= targetDuration) {
      return 'Done';
    }
    return 'Brewing';
  }

  // ─────────────────────────────────────────
  // Elapsed Time Restoration
  // ─────────────────────────────────────────

  /// Calculates how many seconds have elapsed since a given start timestamp.
  /// Used to restore timer state after app comes back from background.
  static int elapsedSinceStart(DateTime startTime) {
    return DateTime.now().difference(startTime).inSeconds;
  }

  /// Computes the estimated remaining time as a Duration given:
  /// [startTime] when the timer was started,
  /// [targetDuration] total expected brew time
  static Duration remainingDuration({
    required DateTime startTime,
    required Duration targetDuration,
  }) {
    final elapsed = DateTime.now().difference(startTime);
    final remaining = targetDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // ─────────────────────────────────────────
  // Grind/Bloom Suggestions
  // ─────────────────────────────────────────

  /// Suggested bloom time (in seconds) based on coffee weight.
  /// Standard rule: bloom = 30s for most pour-overs
  static int suggestedBloomSeconds({double coffeeWeightGrams = 15}) {
    // Standard bloom: 30s for light roasts, 30s baseline
    return 30;
  }

  /// Suggested total brew duration in seconds based on coffee weight.
  /// Rough guideline: ~1 sec per gram + 2 min base
  static int suggestedBrewSeconds({double coffeeWeightGrams = 15}) {
    return (120 + coffeeWeightGrams * 1.0).round();
  }
}
