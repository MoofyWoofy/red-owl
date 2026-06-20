// Unit tests for the Grid Riverpod notifier (the game's core state machine).
//
// These drive the notifier through `onKeyboardPressed` and assert on the
// resulting board state, the keyboard colours, the persisted aggregate stats,
// and the History database rows. A `testWidgets` host is used (rather than a
// bare ProviderContainer) so that `onKeyboardPressed` has a real BuildContext
// with a ScaffoldMessenger ancestor for its snack-bar feedback.
//
// The word of the day is deterministic for a given list + date, so each test
// reads `WordleService().wordOfTheDay` and types that exact word to force a
// win, and types other list words to force valid-but-wrong guesses.
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart'
    show LetterStatus, SharedPreferencesKeys, keyboardStatus;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/util/misc.dart' show dateToString;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../../helpers/test_helpers.dart';

/// A small, fixed word list with no repeated letters across enough entries to
/// build six distinct wrong guesses for the loss path.
const _testWords = [
  'apple',
  'berry',
  'chair',
  'dwarf',
  'eagle',
  'flame',
  'grape',
  'house',
];

void main() {
  /// Captured on first build of the host widget so tests can drive the notifier
  /// and supply a BuildContext to `onKeyboardPressed`.
  late WidgetRef capturedRef;
  late BuildContext capturedContext;

  setUp(() async {
    setSharedPreferencesMock();
    await SharedPreferenceService().init();
    await installFakePathProvider();
    setAssetBundleMock(_testWords);
    AppDatabase.setSingleton(AppDatabase.forTesting(NativeDatabase.memory()));
    await WordleService().init();
  });

  tearDown(() async {
    await AppDatabase().close();
    AppDatabase.resetSingleton();
    setAssetBundleMock(null);
  });

  /// Pumps a host that captures `ref`/`context` and forces the grid provider to
  /// build by watching it.
  Future<void> pumpHost(WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestApp(
        child: Consumer(
          builder: (context, ref, _) {
            capturedRef = ref;
            capturedContext = context;
            ref.watch(gridProvider);
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Types [word] one letter at a time through the notifier.
  Future<void> type(String word) async {
    final notifier = capturedRef.read(gridProvider.notifier);
    for (final ch in word.toUpperCase().split('')) {
      await notifier.onKeyboardPressed(key: ch, context: capturedContext);
    }
  }

  /// Submits the current row.
  Future<void> enter() => capturedRef
      .read(gridProvider.notifier)
      .onKeyboardPressed(key: 'ENTER', context: capturedContext);

  /// Drains the snack-bar timers scheduled by `showSnackBar` so the test does
  /// not end with a pending [Timer].
  Future<void> drainSnackBars(WidgetTester tester) =>
      tester.pumpAndSettle(const Duration(seconds: 4));

  group('Grid notifier', () {
    testWidgets('starts with an empty board', (tester) async {
      await pumpHost(tester);
      final grid = capturedRef.read(gridProvider);
      expect(grid.tiles, isEmpty);
      expect(grid.row, 0);
      expect(grid.column, 0);
      expect(grid.isGameOver, isFalse);
    });

    testWidgets('typing letters adds tiles and DELETE removes the last one',
        (tester) async {
      await pumpHost(tester);
      await type('ABC');
      var grid = capturedRef.read(gridProvider);
      expect(grid.tiles.map((t) => t.letter).join(), 'ABC');
      expect(grid.column, 3);

      await capturedRef
          .read(gridProvider.notifier)
          .onKeyboardPressed(key: 'DELETE', context: capturedContext);
      grid = capturedRef.read(gridProvider);
      expect(grid.tiles.map((t) => t.letter).join(), 'AB');
      expect(grid.column, 2);
    });

    testWidgets('a row never exceeds five letters', (tester) async {
      await pumpHost(tester);
      await type('ABCDEFG');
      final grid = capturedRef.read(gridProvider);
      expect(grid.tiles, hasLength(5));
      expect(grid.column, 5);
    });

    testWidgets('ENTER with fewer than five letters flags the shake animation',
        (tester) async {
      await pumpHost(tester);
      await type('ABC');
      await enter();
      final grid = capturedRef.read(gridProvider);
      expect(grid.notEnoughCharacters, isTrue);
      expect(grid.row, 0); // Row did not advance.
      await drainSnackBars(tester);
    });

    testWidgets('a word not in the list is rejected and the row stays put',
        (tester) async {
      await pumpHost(tester);
      await type('ZZZZZ');
      await enter();
      final grid = capturedRef.read(gridProvider);
      expect(grid.notEnoughCharacters, isTrue);
      expect(grid.row, 0);
      expect(grid.isGameOver, isFalse);
      await drainSnackBars(tester);
    });

    testWidgets('guessing the word of the day wins the game', (tester) async {
      await pumpHost(tester);
      final answer = WordleService().wordOfTheDay;

      await type(answer);
      await enter();

      final grid = capturedRef.read(gridProvider);
      expect(grid.isGameWon, isTrue);
      expect(grid.isGameOver, isTrue);
      // Every tile in the winning row is green.
      expect(
        grid.tiles.every((t) => t.status == LetterStatus.green),
        isTrue,
      );

      // Stats persisted: 1 played, 1 won, streak 1, distribution[0] == 1.
      final stats = SharedPreferenceService()
          .getStringList(SharedPreferencesKeys.statsData);
      expect(stats, ['1', '1', '1', '1']);
      final distribution = SharedPreferenceService()
          .getStringList(SharedPreferencesKeys.guessDistribution);
      expect(distribution!.first, '1');

      // A 'won' history row was written.
      final rows = await AppDatabase().select(AppDatabase().history).get();
      expect(rows, hasLength(1));
      expect(rows.first.gameState, GameState.won.name);

      await drainSnackBars(tester);
    });

    testWidgets('a valid wrong guess colours the keyboard and advances the row',
        (tester) async {
      await pumpHost(tester);
      final answer = WordleService().wordOfTheDay;
      // Pick any list word that is not the answer.
      final guess =
          _testWords.firstWhere((w) => w.toUpperCase() != answer);

      await type(guess);
      await enter();

      final grid = capturedRef.read(gridProvider);
      expect(grid.row, 1); // Advanced to the next row.
      // Every guessed letter now has a non-initial keyboard colour.
      for (final letter in guess.toUpperCase().split('')) {
        expect(grid.keyboardStatus[letter], isNot(LetterStatus.initial));
      }
      await drainSnackBars(tester);
    });

    testWidgets('six valid wrong guesses lose the game', (tester) async {
      await pumpHost(tester);
      final answer = WordleService().wordOfTheDay;
      final wrong = _testWords
          .where((w) => w.toUpperCase() != answer)
          .take(6)
          .toList();
      expect(wrong, hasLength(6));

      for (final word in wrong) {
        await type(word);
        await enter();
      }

      final grid = capturedRef.read(gridProvider);
      expect(grid.isGameOver, isTrue);
      expect(grid.isGameWon, isFalse);

      // Loss resets the streak; one game played, none won.
      final stats = SharedPreferenceService()
          .getStringList(SharedPreferencesKeys.statsData);
      expect(stats, ['1', '0', '0', '0']);

      final rows = await AppDatabase().select(AppDatabase().history).get();
      expect(rows, hasLength(1));
      expect(rows.first.gameState, GameState.lost.name);

      await drainSnackBars(tester);
    });

    testWidgets(
        'an unfinished game from a previous day is archived as incomplete',
        (tester) async {
      // Build a stored, in-progress grid dated yesterday.
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final storedGrid = models.Grid(
        column: 2,
        row: 0,
        tiles: const [
          models.Tile(
            letter: 'A',
            status: LetterStatus.initial,
            hasFlipAnimationPlayed: false,
          ),
          models.Tile(
            letter: 'P',
            status: LetterStatus.initial,
            hasFlipAnimationPlayed: false,
          ),
        ],
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: false,
        isGameOver: false,
        notEnoughCharacters: false,
      );
      final gridBase64 =
          base64.encode(utf8.encode(jsonEncode(storedGrid.toJson())));

      setSharedPreferencesMock({
        SharedPreferencesKeys.gridState.name: gridBase64,
        SharedPreferencesKeys.gameDate.name: dateToString(yesterday),
      });
      await SharedPreferenceService().init();

      await pumpHost(tester);
      // Let the fire-and-forget _addToDatabase insert complete.
      await tester.pumpAndSettle();

      // The board was reset to empty for today.
      final grid = capturedRef.read(gridProvider);
      expect(grid.tiles, isEmpty);

      // The stale grid was cleared and the date advanced to today.
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.gridState),
        isNull,
      );
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.gameDate),
        dateToString(DateTime.now()),
      );

      // The previous day's game was archived as incomplete.
      final rows = await AppDatabase().select(AppDatabase().history).get();
      expect(rows, hasLength(1));
      expect(rows.first.gameState, GameState.incomplete.name);
    });

    testWidgets('resetGrid clears the board and persisted grid state',
        (tester) async {
      await pumpHost(tester);
      await type('ABCDE');
      expect(capturedRef.read(gridProvider).tiles, hasLength(5));

      capturedRef.read(gridProvider.notifier).resetGrid();
      final grid = capturedRef.read(gridProvider);
      expect(grid.tiles, isEmpty);
      expect(grid.row, 0);
      expect(grid.column, 0);
    });
  });
}
