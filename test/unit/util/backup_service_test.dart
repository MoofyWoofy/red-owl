// Unit tests for BackupService.
//
// Focused on the import path's promise that a malformed document is rejected
// *before* anything is written, so a bad file can never leave the app in a
// state that breaks the next finished game.
import 'dart:convert';

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

  setUp(() async {
    await installFakePathProvider();
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
  });
}
