import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}

extension DateTimeExtension on DateTime {
  String formatDate() {
    DateTime now = DateTime.now();

    if (now.day == day && now.month == month && now.year == year) {
      return 'Today';
    }

    if (now.day == day - 1 && now.month == month && now.year == year) {
      return 'Tomorrow';
    }

    return DateFormat('dd-MM-yyyy').format(this);
  }

  String formatTime([bool is24HourFormat = true]) {
    return DateFormat(
      is24HourFormat ? 'HH:mm' : 'hh:mm a',
    ).format(this);
  }
}