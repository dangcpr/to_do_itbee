import 'package:intl/intl.dart';

extension StringExtension on String {
  /// Converts the string to a DateTime object.
  /// 
  /// If [isLocalTime] is true, the string is parsed as local time.
  /// Otherwise, it is parsed as UTC time.

  DateTime toDateTime({bool isLocalTime = false}) {
    if (isLocalTime) return DateTime.parse(this);
    return DateTime.parse(this).toUtc();
  }
}

extension DateTimeExtension on DateTime {
  /// Formats the DateTime object as a string.
  ///
  /// If the DateTime object is today, then 'Today' is returned.
  /// If the DateTime object is tomorrow, then 'Tomorrow' is returned.
  /// If the DateTime object is yesterday, then 'Yesterday' is returned.
  /// Otherwise, the DateTime object is formatted as 'dd-MM-yyyy'.
  String formatDate() {
    DateTime now = DateTime.now().toLocal();
    DateTime dateLocal = toLocal();

    int day = dateLocal.day;
    int month = dateLocal.month;
    int year = dateLocal.year;

    if (now.day == day && now.month == month && now.year == year) {
      return 'Today';
    }

    if (now.day == day - 1 && now.month == month && now.year == year) {
      return 'Tomorrow';
    }

    if (now.day == day + 1 && now.month == month && now.year == year) {
      return 'Yesterday';
    }

    return DateFormat('dd-MM-yyyy').format(toLocal());
  }

  /// Formats the DateTime object as a time string.
  ///
  /// If [is24HourFormat] is true, the time is formatted as 'HH:mm'.
  /// Otherwise, the time is formatted as 'hh:mm a'.
  ///
  /// The time is always formatted as local time.
  String formatTime([bool is24HourFormat = true]) {
    return DateFormat(is24HourFormat ? 'HH:mm' : 'hh:mm a').format(toLocal());
  }
}
