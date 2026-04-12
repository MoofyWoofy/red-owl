import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/database/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase', () {
    test('schemaVersion is 1', () {
      expect(db.schemaVersion, 1);
    });

    test('inserts a won game and retrieves it', () async {
      final date = DateTime(2024, 6, 15);
      await db.into(db.history).insert(
            HistoryCompanion.insert(
              word: 'HELLO',
              date: date,
              gameState: GameState.won.name,
            ),
          );
      final results = await db.select(db.history).get();
      expect(results, hasLength(1));
      expect(results.first.word, 'HELLO');
      expect(results.first.gameState, 'won');
    });

    test('inserts a lost game and retrieves it', () async {
      final date = DateTime(2024, 6, 16);
      await db.into(db.history).insert(
            HistoryCompanion.insert(
              word: 'WORLD',
              date: date,
              gameState: GameState.lost.name,
            ),
          );
      final results = await db.select(db.history).get();
      expect(results, hasLength(1));
      expect(results.first.gameState, 'lost');
    });

    test('inserts an incomplete game', () async {
      final date = DateTime(2024, 6, 17);
      await db.into(db.history).insert(
            HistoryCompanion.insert(
              word: 'PLUME',
              date: date,
              gameState: GameState.incomplete.name,
            ),
          );
      final results = await db.select(db.history).get();
      expect(results.first.gameState, 'incomplete');
    });

    test('date column acts as primary key and prevents duplicates', () async {
      final date = DateTime(2024, 6, 15);
      await db.into(db.history).insert(
            HistoryCompanion.insert(
              word: 'FIRST',
              date: date,
              gameState: GameState.won.name,
            ),
          );
      expect(
        () => db.into(db.history).insert(
              HistoryCompanion.insert(
                word: 'DUPED',
                date: date,
                gameState: GameState.lost.name,
              ),
            ),
        throwsA(anything),
      );
    });

    test('retrieves multiple entries in order', () async {
      final dates = [
        DateTime(2024, 6, 13),
        DateTime(2024, 6, 14),
        DateTime(2024, 6, 15),
      ];
      for (final date in dates) {
        await db.into(db.history).insert(
              HistoryCompanion.insert(
                word: 'WORDS',
                date: date,
                gameState: GameState.won.name,
              ),
            );
      }
      final results = await db.select(db.history).get();
      expect(results, hasLength(3));
    });

    test('word column enforces length between 5 and 5', () async {
      expect(
        () => db.into(db.history).insert(
              HistoryCompanion.insert(
                word: 'HI',
                date: DateTime(2024, 6, 18),
                gameState: GameState.won.name,
              ),
            ),
        throwsA(anything),
      );
    });

    test('word column rejects strings longer than 5 characters', () async {
      expect(
        () => db.into(db.history).insert(
              HistoryCompanion.insert(
                word: 'TOOLONG',
                date: DateTime(2024, 6, 19),
                gameState: GameState.won.name,
              ),
            ),
        throwsA(anything),
      );
    });

    test('can delete entries', () async {
      final date = DateTime(2024, 6, 20);
      await db.into(db.history).insert(
            HistoryCompanion.insert(
              word: 'ERASE',
              date: date,
              gameState: GameState.won.name,
            ),
          );
      var results = await db.select(db.history).get();
      expect(results, hasLength(1));

      await (db.delete(db.history)
            ..where((t) => t.date.equals(date)))
          .go();
      results = await db.select(db.history).get();
      expect(results, isEmpty);
    });

    test('empty database returns no rows', () async {
      final results = await db.select(db.history).get();
      expect(results, isEmpty);
    });
  });

  group('GameState enum', () {
    test('has exactly three values', () {
      expect(GameState.values, hasLength(3));
    });

    test('values are won, lost, incomplete', () {
      expect(GameState.values, contains(GameState.won));
      expect(GameState.values, contains(GameState.lost));
      expect(GameState.values, contains(GameState.incomplete));
    });

    test('name property returns lowercase string', () {
      expect(GameState.won.name, 'won');
      expect(GameState.lost.name, 'lost');
      expect(GameState.incomplete.name, 'incomplete');
    });
  });
}
