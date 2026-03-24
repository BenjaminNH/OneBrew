import 'package:intl/intl.dart';
import 'package:one_brew/l10n/app_localizations.dart';

/// OneBrew Date & Time Formatting Utilities
/// Provides consistent date/time display across the app.
/// Uses the `intl` package for locale-aware formatting.
abstract final class AppDateUtils {
  // ─────────────────────────────────────────
  // Date Formatting
  // ─────────────────────────────────────────

  /// Format as "HH:mm" — e.g. "14:30"
  static String formatTime(DateTime dt, {String? localeName}) =>
      DateFormat.Hm(localeName).format(dt);

  /// Format as "MM/dd" — e.g. "03/07"
  static String formatDateShort(DateTime dt, {String? localeName}) =>
      DateFormat.Md(localeName).format(dt);

  /// Format as "Mar 7" — e.g. "Mar 7"
  static String formatDateMedium(DateTime dt, {String? localeName}) =>
      DateFormat.MMMd(localeName).format(dt);

  /// Format as "March 7, 2026"
  static String formatDateLong(DateTime dt, {String? localeName}) =>
      DateFormat.yMMMMd(localeName).format(dt);

  /// Format as "03/07 14:30"
  static String formatDateTimeShort(DateTime dt, {String? localeName}) =>
      DateFormat.Md(localeName).add_Hm().format(dt);

  /// Format as "2026-03-07 14:30"
  static String formatDateTimeFull(DateTime dt, {String? localeName}) =>
      DateFormat.yMd(localeName).add_Hm().format(dt);

  // ─────────────────────────────────────────
  // Relative Time Display
  // ─────────────────────────────────────────

  /// Returns a human-friendly relative description:
  /// "Just now" / "X minutes ago" / "Today 14:30" / "Yesterday" / "Mar 7"
  static String formatRelative(
    DateTime dt, {
    AppLocalizations? l10n,
    String? localeName,
  }) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) {
      return l10n?.dateJustNow ?? 'Just now';
    } else if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return l10n?.dateMinutesAgo(minutes) ??
          '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (_isSameDay(dt, now)) {
      final time = formatTime(dt, localeName: localeName);
      return l10n?.dateTodayAt(time) ?? 'Today $time';
    } else if (_isSameDay(dt, now.subtract(const Duration(days: 1)))) {
      final time = formatTime(dt, localeName: localeName);
      return l10n?.dateYesterdayAt(time) ?? 'Yesterday $time';
    } else if (diff.inDays < 7) {
      final days = diff.inDays;
      return l10n?.dateDaysAgo(days) ??
          '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return formatDateMedium(dt, localeName: localeName);
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
  static String sectionHeader(
    DateTime dt, {
    AppLocalizations? l10n,
    String? localeName,
  }) {
    final now = DateTime.now();
    if (_isSameDay(dt, now)) return l10n?.dateToday ?? 'Today';
    if (_isSameDay(dt, now.subtract(const Duration(days: 1)))) {
      return l10n?.dateYesterday ?? 'Yesterday';
    }
    final diff = now.difference(dt).inDays;
    if (diff < 7) return l10n?.dateThisWeek ?? 'This Week';
    return DateFormat.yMMMM(localeName).format(dt);
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
