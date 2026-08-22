// Unit tests for the utility functions in lib/util/misc.dart.
//
// Covers: dateToString, stringToDate, getDateOnly,
// convertListStringToListDouble, isGameInProgress, and getWinRate.
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show Intl;
import 'package:red_owl/config/shared.dart' show LetterStatus, keyboardStatus;
import 'package:red_owl/models/shared.dart' show Grid, Tile;
import 'package:red_owl/util/misc.dart';

void main() {
  group('dateToString', () {
    test('formats a date as yyyy-MM-dd', () {
      final date = DateTime(2024, 1, 15);
      expect(dateToString(date), '2024-01-15');
    });

    test('pads single-digit month and day with zero', () {
      final date = DateTime(2024, 3, 5);
      expect(dateToString(date), '2024-03-05');
    });

    // The result is a storage key read back by DateTime.parse, so it must stay
    // ASCII digits regardless of the active locale. `DateFormat` would follow
    // `Intl.defaultLocale` and could emit non-ASCII numerals.
    test('is independent of the ambient locale', () {
      final previous = Intl.defaultLocale;
      addTearDown(() => Intl.defaultLocale = previous);

      final date = DateTime(2024, 3, 5);
      for (final locale in ['en_US', 'nl', 'ar', 'hi', 'fa']) {
        Intl.defaultLocale = locale;
        expect(dateToString(date), '2024-03-05', reason: 'locale $locale');
        expect(stringToDate(dateToString(date)), date, reason: 'locale $locale');
      }
    });

    test('handles December 31', () {
      final date = DateTime(2025, 12, 31);
      expect(dateToString(date), '2025-12-31');
    });

    test('handles January 1', () {
      final date = DateTime(2025, 1, 1);
      expect(dateToString(date), '2025-01-01');
    });
  });

  group('stringToDate', () {
    test('parses a yyyy-MM-dd string back to DateTime', () {
      final result = stringToDate('2024-06-20');
      expect(result.year, 2024);
      expect(result.month, 6);
      expect(result.day, 20);
    });

    test('parses an ISO 8601 datetime string', () {
      final result = stringToDate('2024-06-20T14:30:00.000');
      expect(result.year, 2024);
      expect(result.hour, 14);
    });

    test('throws on invalid date string', () {
      expect(() => stringToDate('not-a-date'), throwsFormatException);
    });
  });

  group('getDateOnly', () {
    test('strips time components from DateTime', () {
      final dateTime = DateTime(2024, 3, 15, 14, 30, 45, 123);
      final dateOnly = getDateOnly(dateTime);
      expect(dateOnly, DateTime(2024, 3, 15));
      expect(dateOnly.hour, 0);
      expect(dateOnly.minute, 0);
      expect(dateOnly.second, 0);
      expect(dateOnly.millisecond, 0);
    });

    test('returns the same date when time is already midnight', () {
      final dateTime = DateTime(2024, 3, 15);
      final dateOnly = getDateOnly(dateTime);
      expect(dateOnly, dateTime);
    });

    test('handles DateTime.now() without error', () {
      final dateOnly = getDateOnly(DateTime.now());
      expect(dateOnly.hour, 0);
      expect(dateOnly.minute, 0);
    });
  });

  group('convertListStringToListDouble', () {
    test('converts string list to double list', () {
      expect(
        convertListStringToListDouble(['1', '2', '3']),
        [1.0, 2.0, 3.0],
      );
    });

    test('handles decimal strings', () {
      expect(
        convertListStringToListDouble(['1.5', '2.75']),
        [1.5, 2.75],
      );
    });

    test('returns empty list for empty input', () {
      expect(convertListStringToListDouble([]), isEmpty);
    });

    test('handles zero values', () {
      expect(
        convertListStringToListDouble(['0', '0', '0']),
        [0.0, 0.0, 0.0],
      );
    });

    // Deliberately lenient: the input is persisted preference data, so one bad
    // entry renders as an empty bar instead of taking down the Stats page.
    test('treats non-numeric input as zero', () {
      expect(convertListStringToListDouble(['abc']), [0.0]);
      expect(convertListStringToListDouble(['1', 'abc', '3']), [1.0, 0.0, 3.0]);
    });
  });

  group('isGameInProgress', () {
    test('returns true when tiles exist and game is not over', () {
      final grid = Grid(
        column: 2,
        row: 0,
        tiles: [
          const Tile(
            letter: 'H',
            status: LetterStatus.initial,
            hasFlipAnimationPlayed: false,
          ),
          const Tile(
            letter: 'E',
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
      expect(isGameInProgress(grid), true);
    });

    test('returns false when tiles are empty', () {
      final grid = Grid(
        column: 0,
        row: 0,
        tiles: const [],
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: false,
        isGameOver: false,
        notEnoughCharacters: false,
      );
      expect(isGameInProgress(grid), false);
    });

    test('returns false when game is over', () {
      final grid = Grid(
        column: 5,
        row: 1,
        tiles: [
          const Tile(
            letter: 'H',
            status: LetterStatus.green,
            hasFlipAnimationPlayed: true,
          ),
        ],
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: true,
        isGameOver: true,
        notEnoughCharacters: false,
      );
      expect(isGameInProgress(grid), false);
    });
  });

  group('getWinRate', () {
    test('returns 0 when both wins and games are 0', () {
      expect(getWinRate('0', '0'), '0');
    });

    test('returns 100 when all games are won', () {
      expect(getWinRate('10', '10'), '100');
    });

    test('returns 50 for half wins', () {
      expect(getWinRate('5', '10'), '50');
    });

    test('rounds to nearest integer', () {
      expect(getWinRate('1', '3'), '33');
      expect(getWinRate('2', '3'), '67');
    });

    test('handles single game won', () {
      expect(getWinRate('1', '1'), '100');
    });

    test('handles zero wins with games played', () {
      expect(getWinRate('0', '5'), '0');
    });

    test('handles large numbers', () {
      expect(getWinRate('750', '1000'), '75');
    });

    // Regression: the old guard only caught the exact '0'/'0' pair, so any
    // other zero-games input divided by zero and `Infinity.round()` threw.
    test('returns 0 for any zero-games input', () {
      expect(getWinRate('3', '0'), '0');
      expect(getWinRate('0', '0'), '0');
    });

    test('treats non-numeric input as zero', () {
      expect(getWinRate('abc', '10'), '0');
      expect(getWinRate('5', 'abc'), '0');
    });
  });

  group('getAverageGuesses', () {
    test('returns 0 when there are no wins', () {
      expect(getAverageGuesses(['0', '0', '0', '0', '0', '0']), '0');
    });

    test('averages a single bucket', () {
      // Three wins all in 3 guesses → average 3.0.
      expect(getAverageGuesses(['0', '0', '3', '0', '0', '0']), '3.0');
    });

    test('averages across buckets to one decimal', () {
      // 1 win in 2 guesses + 2 wins in 3 guesses → (2 + 3 + 3) / 3 = 2.666…
      expect(getAverageGuesses(['0', '1', '2', '0', '0', '0']), '2.7');
    });

    test('a single one-guess win averages to 1.0', () {
      expect(getAverageGuesses(['1', '0', '0', '0', '0', '0']), '1.0');
    });

    test('treats non-numeric entries as zero', () {
      expect(getAverageGuesses(['0', 'x', '3', '0', '0', '0']), '3.0');
    });
  });

  group('isStreakMilestone', () {
    test('recognises notable milestones', () {
      expect(isStreakMilestone(5), isTrue);
      expect(isStreakMilestone(10), isTrue);
      expect(isStreakMilestone(100), isTrue);
      expect(isStreakMilestone(365), isTrue);
    });

    test('rejects non-milestone streaks', () {
      expect(isStreakMilestone(0), isFalse);
      expect(isStreakMilestone(4), isFalse);
      expect(isStreakMilestone(7), isFalse);
      expect(isStreakMilestone(99), isFalse);
    });
  });
}
