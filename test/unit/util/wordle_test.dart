// Unit tests for WordleService.
//
// Uses installFakePathProvider() so the application documents directory points
// at a temp folder, letting importWordList read/write real files in isolation.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:red_owl/util/wordle.dart';

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    test('rejects a word containing non-letters', () async {
      final src = File(p.join(docsDir.path, 'source.txt'))
        ..writeAsStringSync('apple\nch1ir\n');

      final result = await WordleService().importWordList(src);

      expect(result.status, WordListImportStatus.invalidWord);
      expect(result.lineNumber, 2);
      expect(result.invalidWord, 'ch1ir');
    });

    test('reports a read error for an unreadable file', () async {
      final missing = File(p.join(docsDir.path, 'does_not_exist.txt'));

      final result = await WordleService().importWordList(missing);

      expect(result.status, WordListImportStatus.readError);
    });
  });
}
