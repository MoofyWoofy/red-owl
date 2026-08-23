// Regression tests for [Grid.build]'s handling of unreadable persisted state.
//
// `gridState` (base64-wrapped JSON) and `gameDate` (`yyyy-MM-dd`) both live in
// SharedPreferences, so a partial write, a downgrade to a build with a
// different model shape, or a hand-edited backup can leave a value that cannot
// be decoded. Before this was guarded, each of the cases below threw a
// FormatException straight out of `build`, putting `gridProvider` into an error
// state; because the bad value stayed on disk it did so again on every launch,
// leaving no recovery but clearing the app's data.
//
// The contract asserted here: never throw, fall back to a blank board, and
// clear the poisoned key so the next launch starts clean.
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart'
    show LetterStatus, SharedPreferencesKeys, initialKeyboardStatus;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/util/misc.dart' show dateToString;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../../helpers/test_helpers.dart';

const _testWords = ['apple', 'berry', 'chair'];

/// Base64-wrapped JSON in the same shape the [Tile] widget persists.
String _encodeGrid(models.Grid grid) =>
    base64.encode(utf8.encode(jsonEncode(grid.toJson())));

/// A one-letter, in-progress board.
models.Grid _boardInProgress() => models.Grid(
      column: 1,
      row: 0,
      tiles: [
        models.Tile(
          letter: 'A',
          status: LetterStatus.initial,
          hasFlipAnimationPlayed: false,
        )
      ],
      keyboardStatus: initialKeyboardStatus(),
      runFlipAnimation: false,
      isEnterOrDeletePressed: false,
      isGameWon: false,
      isGameOver: false,
      notEnoughCharacters: false,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Boots the services with [prefs] already in the store.
  Future<void> boot(Map<String, Object> prefs) async {
    setSharedPreferencesMock(prefs);
    await SharedPreferenceService().init();
    await installFakePathProvider();
    setAssetBundleMock(_testWords);
    AppDatabase.setSingleton(AppDatabase.forTesting(NativeDatabase.memory()));
    await WordleService().init();
  }

  tearDown(() async {
    await AppDatabase().close();
    AppDatabase.resetSingleton();
    setAssetBundleMock(null);
  });

  /// Reads the grid through a container, as the widget tree does.
  models.Grid readGrid() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container.read(gridProvider);
  }

  void expectBlankBoard(models.Grid grid) {
    expect(grid.tiles, isEmpty);
    expect(grid.row, 0);
    expect(grid.column, 0);
    expect(grid.isGameOver, isFalse);
  }

  group('unreadable gridState', () {
    test('invalid base64 falls back to a blank board', () async {
      await boot({SharedPreferencesKeys.gridState.name: 'not-base64!!!'});
      expectBlankBoard(readGrid());
    });

    test('valid base64 that is not JSON falls back to a blank board', () async {
      // base64 of "hello there".
      await boot({SharedPreferencesKeys.gridState.name: 'aGVsbG8gdGhlcmU='});
      expectBlankBoard(readGrid());
    });

    test('JSON of the wrong shape falls back to a blank board', () async {
      final wrongShape = base64.encode(utf8.encode(jsonEncode({'nope': 1})));
      await boot({SharedPreferencesKeys.gridState.name: wrongShape});
      expectBlankBoard(readGrid());
    });

    test('the poisoned value is cleared, so a relaunch starts clean', () async {
      await boot({SharedPreferencesKeys.gridState.name: 'not-base64!!!'});
      readGrid();
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.gridState),
        isNull,
      );
      // The date is stamped forward so the board is not re-archived tomorrow.
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.gameDate),
        dateToString(DateTime.now()),
      );
    });
  });

  group('unreadable gameDate', () {
    test('falls back to a blank board rather than throwing', () async {
      await boot({
        SharedPreferencesKeys.gameDate.name: 'garbage',
        SharedPreferencesKeys.gridState.name: _encodeGrid(_boardInProgress()),
      });
      // The board itself decodes, but with no readable date there is no way to
      // tell which day it belongs to, so it is not trusted as today's.
      expectBlankBoard(readGrid());
    });

    test('does not archive a board it cannot date', () async {
      await boot({
        SharedPreferencesKeys.gameDate.name: 'garbage',
        SharedPreferencesKeys.gridState.name: _encodeGrid(_boardInProgress()),
      });
      readGrid();
      await Future<void>.delayed(Duration.zero);
      final rows = await AppDatabase().select(AppDatabase().history).get();
      expect(rows, isEmpty);
    });

    test('repairs the stamp so the next launch is clean', () async {
      await boot({SharedPreferencesKeys.gameDate.name: 'garbage'});
      readGrid();
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.gameDate),
        dateToString(DateTime.now()),
      );
    });
  });

  group('readable state is unaffected', () {
    test('a board saved today is restored as-is', () async {
      await boot({
        SharedPreferencesKeys.gameDate.name: dateToString(DateTime.now()),
        SharedPreferencesKeys.gridState.name: _encodeGrid(_boardInProgress()),
      });
      final grid = readGrid();
      expect(grid.tiles, hasLength(1));
      expect(grid.tiles.single.letter, 'A');
      expect(grid.column, 1);
    });

    test('a missing gameDate still keeps a decodable board', () async {
      // Boards saved before any stamp existed are treated as today's.
      await boot({
        SharedPreferencesKeys.gridState.name: _encodeGrid(_boardInProgress()),
      });
      expect(readGrid().tiles, hasLength(1));
    });

    test('yesterday\'s unfinished board is still archived', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await boot({
        SharedPreferencesKeys.gameDate.name: dateToString(yesterday),
        SharedPreferencesKeys.gridState.name: _encodeGrid(_boardInProgress()),
      });
      expectBlankBoard(readGrid());
      await Future<void>.delayed(Duration.zero);
      final rows = await AppDatabase().select(AppDatabase().history).get();
      expect(rows, hasLength(1));
      expect(rows.single.gameState, GameState.incomplete.name);
    });
  });
}
