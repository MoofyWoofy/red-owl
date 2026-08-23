// Unit tests for BackupService.
//
// Focused on the import path's promise that a malformed document is rejected
// *before* anything is written, so a bad file can never leave the app in a
// state that breaks the next finished game.
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/util/backup_service.dart';
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// A minimal, valid backup document; [overrides] replace top-level sections.
  String backupJson({Map<String, dynamic> overrides = const {}}) {
    return jsonEncode({
      'version': BackupService.backupVersion,
      'exportedAt': DateTime(2026, 8, 22).toIso8601String(),
      'settings': {'isDarkMode': true, 'useCustomList': false},
      'stats': {
        'statsData': ['10', '7', '3', '5'],
        'guessDistribution': ['0', '1', '2', '3', '1', '0'],
      },
      'history': [
        {'word': 'CRANE', 'gameState': 'won', 'date': '2026-08-21'},
      ],
      ...overrides,
    });
  }

  /// The temp directory `path_provider` resolves to for this test. Captured
  /// here because `installFakePathProvider` creates a *fresh* directory on each
  /// call, so re-invoking it would point away from the file just written.
  late Directory tempDir;

  setUp(() async {
    tempDir = await installFakePathProvider();
    setSharedPreferencesMock();
    await SharedPreferenceService().init();
    AppDatabase.setSingleton(AppDatabase.forTesting(NativeDatabase.memory()));
  });

  tearDown(() async {
    await AppDatabase().close();
    AppDatabase.resetSingleton();
  });

  group('BackupService.importFromJson', () {
    test('applies a valid backup', () async {
      await BackupService().importFromJson(backupJson());

      expect(
        SharedPreferenceService().getStringList(SharedPreferencesKeys.statsData),
        ['10', '7', '3', '5'],
      );
      expect(
        SharedPreferenceService()
            .getStringList(SharedPreferencesKeys.guessDistribution),
        ['0', '1', '2', '3', '1', '0'],
      );
      expect(SharedPreferenceService().getBool(SharedPreferencesKeys.isDarkMode),
          isTrue);
      final rows = await AppDatabase().select(AppDatabase().history).get();
      expect(rows, hasLength(1));
      expect(rows.first.word, 'CRANE');
    });

    // Regression: the backup used to carry only isDarkMode and useCustomList,
    // so hard mode, colour-blind mode, the language, text size, animation
    // speed and the whole reminder configuration were silently lost when a
    // user restored onto a new device.
    test('round-trips every user setting', () async {
      final prefs = SharedPreferenceService();
      prefs.setBool(SharedPreferencesKeys.isDarkMode, true);
      prefs.setBool(SharedPreferencesKeys.useCustomList, true);
      prefs.setBool(SharedPreferencesKeys.isColorBlindMode, true);
      prefs.setBool(SharedPreferencesKeys.isHardMode, true);
      prefs.setBool(SharedPreferencesKeys.reminderEnabled, true);
      prefs.setString(SharedPreferencesKeys.localeCode, 'nl');
      prefs.setString(SharedPreferencesKeys.fontScale, 'large');
      prefs.setString(SharedPreferencesKeys.motionSpeed, 'slow');
      prefs.setString(SharedPreferencesKeys.reminderTime, '07:45');

      final exported = await BackupService().buildBackup(includeWordList: false);
      expect(exported['version'], 2);

      // Wipe everything, then restore from the exported document.
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      await BackupService().importFromJson(jsonEncode(exported));

      expect(prefs.getBool(SharedPreferencesKeys.isDarkMode), isTrue);
      expect(prefs.getBool(SharedPreferencesKeys.useCustomList), isTrue);
      expect(prefs.getBool(SharedPreferencesKeys.isColorBlindMode), isTrue);
      expect(prefs.getBool(SharedPreferencesKeys.isHardMode), isTrue);
      expect(prefs.getBool(SharedPreferencesKeys.reminderEnabled), isTrue);
      expect(prefs.getString(SharedPreferencesKeys.localeCode), 'nl');
      expect(prefs.getString(SharedPreferencesKeys.fontScale), 'large');
      expect(prefs.getString(SharedPreferencesKeys.motionSpeed), 'slow');
      expect(prefs.getString(SharedPreferencesKeys.reminderTime), '07:45');
    });

    test('a version 1 backup still imports', () async {
      // Older files carry only the two original settings; the rest are absent
      // and must simply be left alone rather than failing the import.
      final json = jsonEncode({
        'version': 1,
        'settings': {'isDarkMode': true, 'useCustomList': false},
        'history': const [],
      });
      await BackupService().importFromJson(json);
      expect(SharedPreferenceService().getBool(SharedPreferencesKeys.isDarkMode),
          isTrue);
    });

    test('ignores settings of the wrong type', () async {
      final json = jsonEncode({
        'version': BackupService.backupVersion,
        'settings': {'isHardMode': 'yes', 'fontScale': 42},
        'history': const [],
      });
      await BackupService().importFromJson(json);
      expect(SharedPreferenceService().getBool(SharedPreferencesKeys.isHardMode),
          isNull);
      expect(SharedPreferenceService().getString(SharedPreferencesKeys.fontScale),
          isNull);
    });

    test('rejects a document that is not valid JSON', () {
      expect(() => BackupService().importFromJson('{not json'),
          throwsFormatException);
    });

    test('rejects a future backup version', () {
      final json = backupJson(
          overrides: {'version': BackupService.backupVersion + 1});
      expect(
          () => BackupService().importFromJson(json), throwsFormatException);
    });

    // Regression: `stats` used to be written after only an `is List` check.
    // A wrong length or a non-numeric entry survived the import and then broke
    // the next finished game, because `Grid._updateStatsData` destructures
    // `statsData` positionally and `int.parse`s every entry.
    group('rejects malformed stats', () {
      final badStats = <String, Map<String, dynamic>>{
        'statsData too short': {
          'statsData': ['0', '0'],
          'guessDistribution': ['0', '0', '0', '0', '0', '0'],
        },
        'statsData too long': {
          'statsData': ['0', '0', '0', '0', '0'],
          'guessDistribution': ['0', '0', '0', '0', '0', '0'],
        },
        'statsData non-numeric': {
          'statsData': ['0', 'abc', '0', '0'],
          'guessDistribution': ['0', '0', '0', '0', '0', '0'],
        },
        'statsData negative': {
          'statsData': ['0', '-1', '0', '0'],
          'guessDistribution': ['0', '0', '0', '0', '0', '0'],
        },
        'guessDistribution too short': {
          'statsData': ['0', '0', '0', '0'],
          'guessDistribution': ['0', '0', '0'],
        },
        'guessDistribution non-numeric': {
          'statsData': ['0', '0', '0', '0'],
          'guessDistribution': ['0', '0', 'x', '0', '0', '0'],
        },
        'stats not a list': {
          'statsData': 'nope',
          'guessDistribution': ['0', '0', '0', '0', '0', '0'],
        },
      };

      badStats.forEach((name, stats) {
        test(name, () async {
          // Seed known-good values that must survive the failed import.
          SharedPreferenceService().setStringList(
              SharedPreferencesKeys.statsData, ['1', '1', '1', '1']);

          await expectLater(
            BackupService().importFromJson(backupJson(overrides: {
              'stats': stats,
            })),
            throwsFormatException,
          );

          // Nothing was written: prefs and the history table are untouched.
          expect(
            SharedPreferenceService()
                .getStringList(SharedPreferencesKeys.statsData),
            ['1', '1', '1', '1'],
          );
          final rows =
              await AppDatabase().select(AppDatabase().history).get();
          expect(rows, isEmpty);
        });
      });
    });

    test('rejects malformed history without writing stats', () async {
      SharedPreferenceService().setStringList(
          SharedPreferencesKeys.statsData, ['1', '1', '1', '1']);

      await expectLater(
        BackupService().importFromJson(backupJson(overrides: {
          'history': [
            {'word': 'TOOLONG', 'gameState': 'won', 'date': '2026-08-21'},
          ],
        })),
        throwsFormatException,
      );

      expect(
        SharedPreferenceService().getStringList(SharedPreferencesKeys.statsData),
        ['1', '1', '1', '1'],
      );
    });

    test('a backup without a stats section imports cleanly', () async {
      final json = jsonEncode({
        'version': BackupService.backupVersion,
        'history': const [],
      });
      await BackupService().importFromJson(json);
      expect(
        SharedPreferenceService().getStringList(SharedPreferencesKeys.statsData),
        isNull,
      );
    });

    group('custom word list', () {
      /// Reads back whatever the import wrote to custom_list.txt.
      Future<List<String>> savedWordList() async {
        final file = File('${tempDir.path}/custom_list.txt');
        if (!file.existsSync()) return [];
        return file.readAsLinesSync();
      }

      test('a valid list is written to disk', () async {
        await BackupService().importFromJson(backupJson(overrides: {
          'customWordList': ['crane', 'slate', 'PIANO'],
        }));
        expect(await savedWordList(), ['crane', 'slate', 'PIANO']);
      });

      test('blank entries are dropped', () async {
        await BackupService().importFromJson(backupJson(overrides: {
          'customWordList': ['crane', '', '   ', 'slate'],
        }));
        expect(await savedWordList(), ['crane', 'slate']);
      });

      test('duplicates are removed case-insensitively', () async {
        await BackupService().importFromJson(backupJson(overrides: {
          'customWordList': ['crane', 'CRANE', 'Crane', 'slate'],
        }));
        expect(await savedWordList(), ['crane', 'slate']);
      });

      // The word of the day is drawn from this file on every launch and the
      // board is built for five-letter answers, so a bad entry has to be
      // rejected at the import rather than surfacing as a broken game.
      for (final (name, entry) in [
        ('a word that is too short', 'cat'),
        ('a word that is too long', 'crustacean'),
        ('a word with digits', 'cr4ne'),
        ('a word with punctuation', "cran'"),
        ('a non-string entry', 42),
      ]) {
        test('rejects $name without writing it', () async {
          await expectLater(
            BackupService().importFromJson(backupJson(overrides: {
              'customWordList': ['crane', entry],
            })),
            throwsFormatException,
          );
          expect(await savedWordList(), isEmpty);
        });
      }

      test('rejects a list with no usable words', () async {
        await expectLater(
          BackupService().importFromJson(backupJson(overrides: {
            'customWordList': ['', '  '],
          })),
          throwsFormatException,
        );
      });

      test('rejects a customWordList that is not a list', () async {
        await expectLater(
          BackupService().importFromJson(
              backupJson(overrides: {'customWordList': 'crane'})),
          throwsFormatException,
        );
      });

      // The word list is written last, so a bad entry must abort before the
      // history and stats writes rather than after them.
      test('an invalid word leaves existing data untouched', () async {
        await BackupService().importFromJson(backupJson());
        final before =
            await AppDatabase().select(AppDatabase().history).get();
        expect(before, hasLength(1));

        await expectLater(
          BackupService().importFromJson(backupJson(overrides: {
            'history': [
              {'word': 'SLATE', 'gameState': 'lost', 'date': '2026-08-20'},
            ],
            'customWordList': ['nope!'],
          })),
          throwsFormatException,
        );

        final after = await AppDatabase().select(AppDatabase().history).get();
        expect(after, hasLength(1));
        expect(after.single.word, 'CRANE');
      });
    });

    group('history replacement', () {
      test('replaces the table wholesale', () async {
        await BackupService().importFromJson(backupJson());
        await BackupService().importFromJson(backupJson(overrides: {
          'history': [
            {'word': 'SLATE', 'gameState': 'lost', 'date': '2026-08-20'},
            {'word': 'PIANO', 'gameState': 'won', 'date': '2026-08-19'},
          ],
        }));

        final rows = await AppDatabase().select(AppDatabase().history).get();
        expect(rows, hasLength(2));
        expect(rows.map((r) => r.word), containsAll(['SLATE', 'PIANO']));
        expect(rows.map((r) => r.word), isNot(contains('CRANE')));
      });

      // The delete and the inserts run in one transaction, so the table is
      // never observable as emptied-but-not-yet-refilled.
      test('an empty history section clears the table', () async {
        await BackupService().importFromJson(backupJson());
        await BackupService()
            .importFromJson(backupJson(overrides: {'history': <dynamic>[]}));
        expect(
          await AppDatabase().select(AppDatabase().history).get(),
          isEmpty,
        );
      });

      test('duplicate dates collapse to the last entry', () async {
        await BackupService().importFromJson(backupJson(overrides: {
          'history': [
            {'word': 'SLATE', 'gameState': 'lost', 'date': '2026-08-20'},
            {'word': 'PIANO', 'gameState': 'won', 'date': '2026-08-20'},
          ],
        }));
        final rows = await AppDatabase().select(AppDatabase().history).get();
        expect(rows, hasLength(1));
        expect(rows.single.word, 'PIANO');
      });
    });
  });
}
