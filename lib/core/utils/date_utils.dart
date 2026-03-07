import 'package:intl/intl.dart';

/// OneCoffee Date & Time Formatting Utilities
/// Provides consistent date/time display across the app.
/// Uses the `intl` package for locale-aware formatting.
abstract final class AppDateUtils {
  // ─────────────────────────────────────────
  // Formatters (lazy-initialized, not const to allow locale reuse)
  // ─────────────────────────────────────────

  static final DateFormat _timeFormatter = DateFormat('HH:mm');
  static final DateFormat _dateShort = DateFormat('MM/dd');
  static final DateFormat _dateMedium = DateFormat('MMM d');
  static final DateFormat _dateLong = DateFormat('MMMM d, y');
  static final DateFormat _dateTimeShort = DateFormat('MM/dd HH:mm');
  static final DateFormat _dateTimeFull = DateFormat('yyyy-MM-dd HH:mm');

  // ─────────────────────────────────────────
  // Date Formatting
  // ─────────────────────────────────────────

  /// Format as "HH:mm" — e.g. "14:30"
  static String formatTime(DateTime dt) => _timeFormatter.format(dt);

  /// Format as "MM/dd" — e.g. "03/07"
  static String formatDateShort(DateTime dt) => _dateShort.format(dt);

  /// Format as "Mar 7" — e.g. "Mar 7"
  static String formatDateMedium(DateTime dt) => _dateMedium.format(dt);

  /// Format as "March 7, 2026"
  static String formatDateLong(DateTime dt) => _dateLong.format(dt);

  /// Format as "03/07 14:30"
  static String formatDateTimeShort(DateTime dt) => _dateTimeShort.format(dt);

  /// Format as "2026-03-07 14:30"
  static String formatDateTimeFull(DateTime dt) => _dateTimeFull.format(dt);

  // ─────────────────────────────────────────
  // Relative Time Display
  // ─────────────────────────────────────────

  /// Returns a human-friendly relative description:
  /// "Just now" / "X minutes ago" / "Today 14:30" / "Yesterday" / "Mar 7"
  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    } else if (_isSameDay(dt, now)) {
      return 'Today ${formatTime(dt)}';
    } else if (_isSameDay(dt, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday ${formatTime(dt)}';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d ${d == 1 ? 'day' : 'days'} ago';
    } else {
      return formatDateMedium(dt);
    }
  }

  // ─────────────────────────────────────────
  // Brew Date Grouping
  // ─────────────────────────────────────────

  /// Groups a list of DateTimes by calendar day.
  /// Returns a map where keys are yyyy-MM-dd strings and values are the indices.
  static Map<String, List<int>> groupByDay(List<DateTime> dates) {
    final result = <String, List<int>>{};
    for (var i = 0; i < dates.length; i++) {
      final key = _dayKey(dates[i]);
      result.putIfAbsent(key, () => []).add(i);
    }
    return result;
  }

  /// Returns a section header label for history grouping:
  /// "Today" / "Yesterday" / "This Week" / "Mar 2026"
  static String sectionHeader(DateTime dt) {
    final now = DateTime.now();
    if (_isSameDay(dt, now)) return 'Today';
    if (_isSameDay(dt, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    final diff = now.difference(dt).inDays;
    if (diff < 7) return 'This Week';
    return DateFormat('MMMM yyyy').format(dt);
  }

  // ─────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _dayKey(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }
}
