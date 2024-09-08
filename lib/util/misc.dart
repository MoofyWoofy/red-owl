import 'package:intl/intl.dart';

/// Convert Date to a String using ISO 8601
String dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

/// Convert Date to a String using ISO 8601
DateTime stringToDate(String date) => DateTime.parse(date);

/// return [date] with time set to 00:00:00.000
DateTime getDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);
