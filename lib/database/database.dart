import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class History extends Table {
  /// The wordle word.
  TextColumn get word => text().withLength(min: 5, max: 5)();
  /// Did user guess correctly?
  BoolColumn get guessCorrect => boolean()();
  /// The date the game was played.
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

@DriftDatabase(tables: [History])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'database');
  }
}
