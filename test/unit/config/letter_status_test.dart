// Unit tests for config enums and the keyboard status map.
//
// Covers LetterStatus values, keyboardStatus layout (28 keys, correct rows),
// SharedPreferencesKeys completeness, and BoolFamilyProviderIDs.
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart'
    show LetterStatus, keyboardStatus, BoolFamilyProviderIDs, SharedPreferencesKeys;

void main() {
  group('LetterStatus', () {
    test('has exactly four values', () {
      expect(LetterStatus.values, hasLength(4));
    });

    test('contains initial, yellow, green, notInWord', () {
      expect(LetterStatus.values, containsAll([
        LetterStatus.initial,
        LetterStatus.yellow,
        LetterStatus.green,
        LetterStatus.notInWord,
      ]));
    });
  });

  group('keyboardStatus', () {
    test('contains 28 entries (26 letters + ENTER + DELETE)', () {
      expect(keyboardStatus, hasLength(28));
    });

    test('first row contains Q through P', () {
      final firstRow = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
      for (final key in firstRow) {
        expect(keyboardStatus.containsKey(key), true,
            reason: '$key should be in keyboard');
      }
    });

    test('second row contains A through L', () {
      final secondRow = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
      for (final key in secondRow) {
        expect(keyboardStatus.containsKey(key), true,
            reason: '$key should be in keyboard');
      }
    });

    test('third row contains ENTER, Z-M, DELETE', () {
      expect(keyboardStatus.containsKey('ENTER'), true);
      expect(keyboardStatus.containsKey('DELETE'), true);
      final thirdRowLetters = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];
      for (final key in thirdRowLetters) {
        expect(keyboardStatus.containsKey(key), true,
            reason: '$key should be in keyboard');
      }
    });

    test('all values are LetterStatus.initial', () {
      for (final entry in keyboardStatus.entries) {
        expect(entry.value, LetterStatus.initial);
      }
    });
  });

  group('SharedPreferencesKeys', () {
    test('has fifteen values', () {
      expect(SharedPreferencesKeys.values, hasLength(15));
    });

    test('contains all expected keys', () {
      expect(SharedPreferencesKeys.values, containsAll([
        SharedPreferencesKeys.isDarkMode,
        SharedPreferencesKeys.gridState,
        SharedPreferencesKeys.gameDate,
        SharedPreferencesKeys.statsData,
        SharedPreferencesKeys.guessDistribution,
        SharedPreferencesKeys.useCustomList,
        SharedPreferencesKeys.isColorBlindMode,
        SharedPreferencesKeys.localeCode,
        SharedPreferencesKeys.fontScale,
        SharedPreferencesKeys.motionSpeed,
        SharedPreferencesKeys.isHardMode,
        SharedPreferencesKeys.hintUsedDate,
        SharedPreferencesKeys.reminderEnabled,
        SharedPreferencesKeys.reminderTime,
        SharedPreferencesKeys.lastPlayedDate,
      ]));
    });
  });

  group('BoolFamilyProviderIDs', () {
    test('has exactly five values', () {
      expect(BoolFamilyProviderIDs.values, hasLength(5));
    });

    test('contains all expected provider ids', () {
      expect(BoolFamilyProviderIDs.values, containsAll([
        BoolFamilyProviderIDs.isDarkMode,
        BoolFamilyProviderIDs.useCustomList,
        BoolFamilyProviderIDs.isColorBlindMode,
        BoolFamilyProviderIDs.isHardMode,
        BoolFamilyProviderIDs.reminderEnabled,
      ]));
    });
  });
}
