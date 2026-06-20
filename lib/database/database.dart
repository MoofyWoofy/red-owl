// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

part 'database.g.dart';

/// Drift table that stores one row for each completed or abandoned game.
///
/// The primary key is [date], enforcing at most one record per calendar day.
/// [gameState] is constrained to the string names of the [GameState] enum
/// via a `CHECK` constraint so invalid values are rejected at the DB level.
class History extends Table {
  /// The 5-letter Wordle answer for that day (uppercase).
  TextColumn get word => text().withLength(min: 5, max: 5)();

  /// Outcome of the game: one of `'won'`, `'lost'`, or `'incomplete'`.
  /// Validated against [GameState.values] via a database CHECK constraint.
  TextColumn get gameState => text()
      .check(gameState.isIn(GameState.values.map((v) => v.name).toList()))();

  /// The calendar date on which the game was played (midnight, local time).
  /// Acts as the primary key so each day can only have one history entry.
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

/// The application's Drift (SQLite) database.
///
/// Stores the [History] table used by the Stats page to display past game
/// results. The database file is created automatically in the app's support
/// directory on first launch.
@DriftDatabase(tables: [History])
class AppDatabase extends _$AppDatabase {
  /// Process-wide singleton. Sharing one connection avoids opening (and
  /// leaking) a new SQLite handle every time a widget or notifier needs the
  /// database.
  static AppDatabase? _instance;

  /// Returns the shared [AppDatabase], opening the persistent SQLite file named
  /// `'database'` on first use. The instance lives for the whole app session
  /// and is deliberately never closed.
  factory AppDatabase() => _instance ??= AppDatabase._internal();

  AppDatabase._internal() : super(_openConnection());

  /// Creates an in-memory database for unit tests.
  ///
  /// Accepts any [QueryExecutor] (typically [NativeDatabase.memory()]) so
  /// tests run in isolation without touching the file system.
  @visibleForTesting
  AppDatabase.forTesting(super.executor);

  /// Installs [database] as the shared singleton so production code that calls
  /// `AppDatabase()` (the Grid notifier, History widget, BackupService) talks
  /// to a test database. Pair with [resetSingleton] in `tearDown`.
  @visibleForTesting
  static void setSingleton(AppDatabase database) => _instance = database;

  /// Clears the shared singleton so the next `AppDatabase()` call rebuilds it.
  @visibleForTesting
  static void resetSingleton() => _instance = null;

  @override
  int get schemaVersion => 1;

  /// Opens a persistent SQLite connection using drift_flutter's default
  /// platform-specific path (app support directory).
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'database');
  }
}

/// Possible outcomes for a single game session, persisted to [History].
enum GameState {
  /// The player guessed the word within six attempts.
  won,

  /// The player used all six attempts without guessing the word.
  lost,

  /// The game was active when the day rolled over; progress was abandoned.
  incomplete,
}
