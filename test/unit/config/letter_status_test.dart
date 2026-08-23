// Unit tests for config enums and the keyboard status map.
//
// Covers LetterStatus values, keyboardLayout (28 keys, correct rows),
// SharedPreferencesKeys completeness, and BoolFamilyProviderIDs.
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart'
    show
        LetterStatus,
        keyboardLayout,
        initialKeyboardStatus,
        BoolFamilyProviderIDs,
        SharedPreferencesKeys;

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

  group('keyboardLayout', () {
    test('contains 28 entries (26 letters + ENTER + DELETE)', () {
      expect(keyboardLayout, hasLength(28));
    });

    test('first row contains Q through P', () {
      final firstRow = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
      for (final key in firstRow) {
        expect(keyboardLayout.contains(key), true,
            reason: '$key should be in keyboard');
      }
    });

    test('second row contains A through L', () {
      final secondRow = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
      for (final key in secondRow) {
        expect(keyboardLayout.contains(key), true,
            reason: '$key should be in keyboard');
      }
    });

    test('third row contains ENTER, Z-M, DELETE', () {
      expect(keyboardLayout.contains('ENTER'), true);
      expect(keyboardLayout.contains('DELETE'), true);
      final thirdRowLetters = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];
      for (final key in thirdRowLetters) {
        expect(keyboardLayout.contains(key), true,
            reason: '$key should be in keyboard');
      }
    });

    test('initialKeyboardStatus starts every key at initial', () {
      for (final entry in initialKeyboardStatus().entries) {
        expect(entry.value, LetterStatus.initial);
      }
    });

    // Regression: this used to be one mutable top-level map handed straight to
    // the grid notifier as its initial state, so the daily and practice boards
    // shared the same object and mutating it changed notifier state without
    // going through Riverpod.
    test('initialKeyboardStatus returns a fresh map each call', () {
      final first = initialKeyboardStatus();
      final second = initialKeyboardStatus();
      expect(identical(first, second), isFalse);

      first['Q'] = LetterStatus.green;
      expect(second['Q'], LetterStatus.initial);
      expect(initialKeyboardStatus()['Q'], LetterStatus.initial);
    });
  });

  group('SharedPreferencesKeys', () {
    test('has fourteen values', () {
      expect(SharedPreferencesKeys.values, hasLength(14));
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
