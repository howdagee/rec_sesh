import 'package:intl/intl.dart';

/// A collection of helper functions for formatting DateTime objects into various string formats.
class DateTimeFormatter {
  const DateTimeFormatter._();

  /// Formats a DateTime object into "Month Day" format (e.g., "Jun 6").
  static String getMonthDay(DateTime dateTime) {
    return DateFormat('MMM d').format(dateTime);
  }

  /// Formats a DateTime object into "Weekday at HH:MM AM/PM" format (e.g., "Sunday at 4:30 PM").
  static String getWeekdayAtTime(DateTime dateTime) {
    // 'EEEE' for full weekday name (e.g., 'Sunday')
    // 'h' for 12-hour format (e.g., '4')
    // 'mm' for minute with leading zero (e.g., '30')
    // 'a' for AM/PM marker
    return DateFormat('EEEE \'at\' h:mm a').format(dateTime);
  }

  /// Formats a DateTime object into "Month Year" format (e.g., "June 2025").
  static String getMonthYear(DateTime dateTime) {
    return DateFormat('MMMM yyyy').format(dateTime);
  }
}
