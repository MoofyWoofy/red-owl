// Unit tests for WordleService.
//
// Uses installFakePathProvider() so the application documents directory points
// at a temp folder, letting importWordList read/write real files in isolation.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;
import 'package:red_owl/util/wordle.dart';

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WordleService word-of-the-day and guess checking', () {
    const words = ['apple', 'berry', 'chair', 'dwarf', 'eagle', 'flame'];

    setUp(() async {
      await installFakePathProvider();
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      setAssetBundleMock(words);
    });

    tearDown(() => setAssetBundleMock(null));

    test('returns the same word for the same date every time', () async {
      final date = DateTime(2024, 3, 14);
      final first = await WordleService().getWordOfTheDay(date);
      final second = await WordleService().getWordOfTheDay(date);
      expect(first, second);
      // The chosen word is one of the list words, upper-cased.
      expect(words.map((w) => w.toUpperCase()), contains(first));
    });

    test('different dates can select different words', () async {
      // Sweep a month of dates; with six words the seed must land on at least
      // two distinct answers, proving the date actually drives the choice.
      final seen = <String>{};
      for (var day = 1; day <= 28; day++) {
        seen.add(await WordleService().getWordOfTheDay(DateTime(2024, 1, day)));
      }
      expect(seen.length, greaterThan(1));
    });

    test('checkGuessWord reports a correct guess', () async {
      await WordleService().init();
      final answer = WordleService().wordOfTheDay;
      final result = await WordleService().checkGuessWord(answer);
      expect(result['is_correct'], isTrue);
      expect(result['is_word_in_list'], isTrue);
    });

    test('checkGuessWord rejects a word that is not in the list', () async {
      await WordleService().init();
      final result = await WordleService().checkGuessWord('ZZZZZ');
      expect(result['is_correct'], isFalse);
      expect(result['is_word_in_list'], isFalse);
      expect(result.containsKey('character_info'), isFalse);
    });

    test('checkGuessWord scores each character of a valid wrong guess',
        () async {
      await WordleService().init();
      final answer = WordleService().wordOfTheDay;
      // Any list word other than the answer is a valid wrong guess.
      final guess =
          words.map((w) => w.toUpperCase()).firstWhere((w) => w != answer);

      final result = await WordleService().checkGuessWord(guess);
      expect(result['is_correct'], isFalse);
      expect(result['is_word_in_list'], isTrue);

      final info = result['character_info'] as List;
      expect(info, hasLength(5));
      // Each character is scored relative to the answer.
      for (var i = 0; i < 5; i++) {
        final scoring = info[i]['scoring'] as Map;
        expect(scoring['in_word'], answer.contains(guess[i]));
        expect(scoring['correct_idx'], guess[i] == answer[i]);
      }
    });

    test('checkGuessWord lower-cases the guess for list membership', () async {
      await WordleService().init();
      // The list stores lower-case words; an upper-case non-answer guess must
      // still be recognised as in-list.
      final answer = WordleService().wordOfTheDay;
      final guess =
          words.map((w) => w.toUpperCase()).firstWhere((w) => w != answer);
      final result = await WordleService().checkGuessWord(guess);
      expect(result['is_word_in_list'], isTrue);
    });

    test('checkGuessWord scores against an explicit answer when provided',
        () async {
      await WordleService().init();
      // Force a specific answer different from the word of the day.
      final result =
          await WordleService().checkGuessWord('APPLE', answer: 'APPLE');
      expect(result['is_correct'], isTrue);

      // A wrong guess is scored relative to the supplied answer, not the daily.
      final wrong =
          await WordleService().checkGuessWord('BERRY', answer: 'APPLE');
      expect(wrong['is_correct'], isFalse);
      final info = wrong['character_info'] as List;
      for (var i = 0; i < 5; i++) {
        final scoring = info[i]['scoring'] as Map;
        expect(scoring['in_word'], 'APPLE'.contains('BERRY'[i]));
        expect(scoring['correct_idx'], 'BERRY'[i] == 'APPLE'[i]);
      }
    });

    test('randomWord returns an uppercase word from the active list', () async {
      final upper = words.map((w) => w.toUpperCase()).toSet();
      for (var i = 0; i < 20; i++) {
        expect(upper, contains(await WordleService().randomWord()));
      }
    });
  });

  group('WordleService.importWordList', () {
    late Directory docsDir;

    setUp(() async {
      docsDir = await installFakePathProvider();
    });

    test('saves a valid list and reports success', () async {
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync('apple\nBerry\nCHAIR\n');

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.success);
      expect(result.words, ['apple', 'Berry', 'CHAIR']);

      final saved = File(p.join(docsDir.path, 'custom_list.txt'));
      expect(saved.existsSync(), isTrue);
      expect(saved.readAsLinesSync(), ['apple', 'Berry', 'CHAIR']);
    });

    test('ignores blank and whitespace-only lines', () async {
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync('apple\n\n   \nchair\n');

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.success);
      expect(result.words, ['apple', 'chair']);
    });

    test('rejects a non-5-letter word and reports the line', () async {
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync('apple\nfour\nchair\n');

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.invalidWord);
      expect(result.lineNumber, 2);
      expect(result.invalidWord, 'four');
    });

    test('removes duplicate words case-insensitively, keeping order', () async {
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync('apple\nchair\nApple\nBERRY\nchair\n');

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.success);
      // First occurrences kept, later case-insensitive repeats dropped.
      expect(result.words, ['apple', 'chair', 'BERRY']);
    });

    test('flags lists below the recommended minimum', () async {
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync('apple\nchair\nberry\n');

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.success);
      expect(result.belowRecommendedMinimum, isTrue);
    });

    test('does not flag lists at or above the recommended minimum', () async {
      // Generate unique 5-letter all-letter words (aaaaa, aaaab, ...).
      String wordFor(int index) {
        var n = index;
        final letters = List.filled(5, 'a');
        for (var pos = 4; pos >= 0; pos--) {
          letters[pos] = String.fromCharCode(97 + (n % 26));
          n ~/= 26;
        }
        return letters.join();
      }

      final words = List.generate(
        WordleService.recommendedMinimumWords,
        wordFor,
      );
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync(words.join('\n'));

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.success);
      expect(result.words, hasLength(WordleService.recommendedMinimumWords));
      expect(result.belowRecommendedMinimum, isFalse);
    });

    test('rejects a word containing non-letters', () async {
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync('apple\nch1ir\n');

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.invalidWord);
      expect(result.lineNumber, 2);
      expect(result.invalidWord, 'ch1ir');
    });

    test('rejects files larger than the size cap', () async {
      final src = File(p.join(docsDir.path, 'big.txt'))
        ..writeAsBytesSync(
            List.filled(WordleService.maxImportFileBytes + 1, 0x61));

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.fileTooLarge);
    });

    test('reports a read error for an unreadable file', () async {
      final missing = File(p.join(docsDir.path, 'does_not_exist.txt'));

      final result = await WordleService().importWordList(missing);

      expect(result.status, WordListImportStatus.readError);
    });
  });
}
