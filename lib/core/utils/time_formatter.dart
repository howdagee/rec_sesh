import 'package:intl/intl.dart';

/// A collection of helper functions for formatting DateTime objects into various string formats.
class DateTimeFormatter {
  const DateTimeFormatter._();

  /// Formats a DateTime object into "Month Day" format (e.g., "Jun 6").
  static String getShortMonthDay(DateTime dateTime) {
    return DateFormat('MMM d').format(dateTime);
  }

  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final isFuture = difference.isNegative;
    final absDifference =
        difference.abs(); // Work with absolute difference for calculations

    String prefix = isFuture ? 'in' : ''; // For future dates: "in 5 minutes"
    String suffix = isFuture ? '' : 'ago'; // For past dates: "5 minutes ago"

    if (absDifference.inSeconds < 10) {
      return 'Just now'; // Very recent, regardless of past or future
    } else if (absDifference.inSeconds < 60) {
      final seconds = absDifference.inSeconds;
      return '$prefix $seconds second${seconds == 1 ? '' : 's'} $suffix'.trim();
    } else if (absDifference.inMinutes < 60) {
      final minutes = absDifference.inMinutes;
      return '$prefix $minutes minute${minutes == 1 ? '' : 's'} $suffix'.trim();
    } else if (absDifference.inHours < 24) {
      final hours = absDifference.inHours;
      return '$prefix $hours hour${hours == 1 ? '' : 's'} $suffix'.trim();
    } else if (absDifference.inDays == 1) {
      // Special handling for exactly 1 day difference
      return isFuture ? 'Tomorrow' : 'Yesterday';
    } else if (absDifference.inDays < 7) {
      final days = absDifference.inDays;
      return '$prefix $days day${days == 1 ? '' : 's'} $suffix'.trim();
    } else if (absDifference.inDays < 30) {
      // Approximately 4 weeks
      final weeks = (absDifference.inDays / 7).round();
      return '$prefix $weeks week${weeks == 1 ? '' : 's'} $suffix'.trim();
    } else if (absDifference.inDays < 365) {
      // Approximately 12 months
      final months = (absDifference.inDays / 30).round();
      return '$prefix $months month${months == 1 ? '' : 's'} $suffix'.trim();
    } else {
      final years = (absDifference.inDays / 365).round();
      return '$prefix $years year${years == 1 ? '' : 's'} $suffix'.trim();
    }
  }

  /// Formats a DateTime object into "Weekday at HH:MM AM/PM" format (e.g., "Sunday at 4:30 PM").
  static String getWeekdayAtTime(DateTime dateTime) {
    // 'EEEE' for full weekday name (e.g., 'Sunday')
    // 'h' for 12-hour format (e.g., '4')
    // 'mm' for minute with leading zero (e.g., '30')
    // 'a' for AM/PM marker
    return DateFormat('EEEE \'at\' h:mm a').format(dateTime);
  }

  /// Formats a DateTime object into "Month Day, Year" format (e.g., "June 5, 2025").
  static String getMonthDayYear(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy').format(dateTime);
  }
}
