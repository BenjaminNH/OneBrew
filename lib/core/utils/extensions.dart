import 'package:flutter/material.dart';

import '../widgets/app_top_toast.dart';

/// OneBrew Dart Extension Methods
/// Provides syntactic sugar and utility extensions across common types.
/// Import this file to unlock convenient methods on String, num, DateTime, etc.

// ─────────────────────────────────────────────────────────────────
// String Extensions
// ─────────────────────────────────────────────────────────────────

extension StringX on String {
  /// Capitalizes the first character. "hello" → "Hello"
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Title-cases each word. "hello world" → "Hello World"
  String get titleCase {
    return split(
      ' ',
    ).map((word) => word.isEmpty ? word : word.capitalized).join(' ');
  }

  /// Returns null if the string is empty after trimming.
  String? get nullIfEmpty => trim().isEmpty ? null : this;

  /// Checks if two strings are equal ignoring case.
  bool equalsIgnoreCase(String other) =>
      trim().toLowerCase() == other.trim().toLowerCase();

  /// Truncates to [maxLength] characters and appends "…" if exceeded.
  String truncate(int maxLength, {String ellipsis = '…'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Removes all whitespace characters.
  String get stripped => replaceAll(RegExp(r'\s+'), '');
}

// ─────────────────────────────────────────────────────────────────
// Nullable String Extensions
// ─────────────────────────────────────────────────────────────────

extension NullableStringX on String? {
  /// Returns empty string if null.
  String get orEmpty => this ?? '';

  /// Returns true if null or blank.
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Returns true if not null and not blank.
  bool get hasValue => !isNullOrEmpty;
}

// ─────────────────────────────────────────────────────────────────
// num / double / int Extensions
// ─────────────────────────────────────────────────────────────────

extension DoubleX on double {
  /// Formats to at most [decimals] significant decimal places.
  /// 1.0 → "1", 1.50 → "1.5", 1.234 → "1.23" (with decimals=2)
  String toCleanString({int decimals = 1}) {
    if (this == truncateToDouble()) return toInt().toString();
    return toStringAsFixed(decimals).replaceAll(RegExp(r'0+$'), '');
  }

  /// Clamps value to [min, max] inclusive.
  double clampTo(double min, double max) => clamp(min, max).toDouble();
}

extension IntX on int {
  /// Formats seconds as "mm:ss" string. 90 → "1:30"
  String get asTimerString {
    final m = this ~/ 60;
    final s = this % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// Returns true if within [min, max] inclusive.
  bool between(int min, int max) => this >= min && this <= max;

  /// Pads integer with leading zeros to width. 7.padded(2) → "07"
  String padded(int width) => toString().padLeft(width, '0');
}

// ─────────────────────────────────────────────────────────────────
// DateTime Extensions
// ─────────────────────────────────────────────────────────────────

extension DateTimeX on DateTime {
  /// Returns a DateTime at the start of the day (midnight).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns a DateTime at the end of the day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns true if [other] falls on the same calendar day.
  bool isSameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns true if this DateTime is today.
  bool get isToday => isSameDayAs(DateTime.now());

  /// Returns true if this DateTime was yesterday.
  bool get isYesterday =>
      isSameDayAs(DateTime.now().subtract(const Duration(days: 1)));
}

// ─────────────────────────────────────────────────────────────────
// Duration Extensions
// ─────────────────────────────────────────────────────────────────

extension DurationX on Duration {
  /// Formats as "Xm Ys" verbose string. Duration(minutes: 3, seconds:15) → "3m 15s"
  String get verboseLabel {
    final m = inMinutes;
    final s = inSeconds % 60;
    if (m == 0) return '${s}s';
    if (s == 0) return '${m}m';
    return '${m}m ${s}s';
  }

  /// Formats as "mm:ss". Duration(seconds: 90) → "1:30"
  String get timerLabel {
    final m = inMinutes;
    final s = inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

// ─────────────────────────────────────────────────────────────────
// BuildContext Extensions
// ─────────────────────────────────────────────────────────────────

extension BuildContextX on BuildContext {
  /// Shorthand for [MediaQuery.of(context).size]
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Shorthand for screen width
  double get screenWidth => screenSize.width;

  /// Shorthand for screen height
  double get screenHeight => screenSize.height;

  /// Bottom safe area padding (home indicator on iPhone, etc.)
  double get bottomSafeArea => MediaQuery.paddingOf(this).bottom;

  /// Top safe area padding (notch / status bar)
  double get topSafeArea => MediaQuery.paddingOf(this).top;

  /// Whether this is a wide-screen (tablet) context (> 600dp)
  bool get isWideScreen => screenWidth > 600;

  /// Current [ThemeData]
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme]
  ColorScheme get colorScheme => theme.colorScheme;

  /// Current [TextTheme]
  TextTheme get textTheme => theme.textTheme;

  /// Show a simple snackbar message
  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }

  /// Show a non-blocking top success toast.
  void showTopSuccessToast(
    String message, {
    Duration? duration,
  }) {
    AppTopToast.showSuccess(this, message, duration: duration);
  }

  /// Show a non-blocking top info toast.
  void showTopInfoToast(
    String message, {
    Duration? duration,
  }) {
    AppTopToast.showInfo(
      this,
      message,
      duration: duration,
    );
  }

  /// Show a bottom floating prompt for feedback that includes a follow-up action.
  void showBottomActionPrompt(
    String message, {
    required String actionLabel,
    required VoidCallback onAction,
    Duration? duration,
    double bottomOffset = 0,
  }) {
    AppBottomActionPrompt.show(
      this,
      message: message,
      action: AppBottomActionPromptAction(
        label: actionLabel,
        onPressed: onAction,
      ),
      duration: duration,
      bottomOffset: bottomOffset,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// List Extensions
// ─────────────────────────────────────────────────────────────────

extension ListX<T> on List<T> {
  /// Returns a new list with [element] inserted between every pair of items.
  List<T> intersperse(T element) {
    if (length <= 1) return this;
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) result.add(element);
    }
    return result;
  }

  /// Returns the element at [index] or null if out of bounds.
  T? getOrNull(int index) =>
      (index >= 0 && index < length) ? this[index] : null;
}

// ─────────────────────────────────────────────────────────────────
// Color Extensions
// ─────────────────────────────────────────────────────────────────

extension ColorX on Color {
  /// Lightens the color by [amount] (0.0 – 1.0).
  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darkens the color by [amount] (0.0 – 1.0).
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}
