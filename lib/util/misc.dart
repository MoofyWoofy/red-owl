import 'package:intl/intl.dart';

import 'package:red_owl/models/shared.dart' show Grid;

/// Convert Date to a String using ISO 8601
String dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

/// Convert Date to a String using ISO 8601
DateTime stringToDate(String date) => DateTime.parse(date);

/// return [date] with time set to 00:00:00.000
DateTime getDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// converts ['1','2','3'] to [1.0, 2.0, 3.0]
List<double> convertListStringToListDouble(List<String> arg) =>
    arg.map((e) => double.parse(e)).toList();

/// returns true if game is in progress
bool isGameInProgress(Grid grid) {
  return grid.tiles.isNotEmpty && !grid.isGameOver;
}

/// returns win rate from 0 - 100... eg: 75
String getWinRate(String wins, String games) {
  if (wins == '0' && games == '0') {
    return '0';
  } else {
    return (double.parse(wins) / double.parse(games) * 100).round().toString();
  }
}
