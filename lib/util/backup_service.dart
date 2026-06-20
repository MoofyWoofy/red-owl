import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show InsertMode;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, getTemporaryDirectory;
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/util/misc.dart' show dateToString, getDateOnly;
import 'package:red_owl/util/shared_preference_service.dart';

/// Serialises the user's data to a single JSON document and restores it again.
///
/// The backup covers three categories of data, mirroring how the app stores
/// them:
/// - **settings** — `isDarkMode` and `useCustomList` from SharedPreferences.
/// - **stats** — the `statsData` and `guessDistribution` arrays from
///   SharedPreferences.
/// - **history** — every row of the Drift [History] table.
///
/// The custom word list (`custom_list.txt`) is *optionally* included; the
/// caller decides at export time (see [hasCustomWordList]).
///
/// The in-progress game board ([SharedPreferencesKeys.gridState]) is
/// deliberately **not** part of a backup — it is transient daily state, not
/// something worth transferring between devices.
///
/// Implemented as a singleton so it can be swapped/mocked consistently with the
/// other services ([SharedPreferenceService], [WordleService]).
class BackupService {
  /// Schema version written into every backup. Bump when the format changes in
  /// a way [importFromJson] needs to branch on; imports with a higher version
  /// than this are rejected.
  static const int backupVersion = 1;

  static const String _customListFileName = 'custom_list.txt';

  static final BackupService _instance = BackupService._internal();

  /// Returns the singleton [BackupService] instance.
  factory BackupService() => _instance;

  BackupService._internal();

  /// Resolves the on-disk location of the imported custom word list.
  Future<File> _customListFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(path.join(dir.path, _customListFileName));
  }

  /// Returns `true` when the user has previously imported a custom word list.
  ///
  /// Used by the Settings page to decide whether to offer the "include word
  /// list in export?" prompt.
  Future<bool> hasCustomWordList() async {
    return (await _customListFile()).exists();
  }

  /// Builds the backup as a JSON-encodable map.
  ///
  /// When [includeWordList] is `true` and a custom list exists, its words are
  /// embedded under the `customWordList` key.
  Future<Map<String, dynamic>> buildBackup({
    required bool includeWordList,
  }) async {
    final prefs = SharedPreferenceService();

    // Read the whole history table.
    final db = AppDatabase();
    final historyRows = await db.select(db.history).get();
    await db.close();

    final history = historyRows
        .map((row) => {
              'word': row.word,
              'gameState': row.gameState,
              'date': dateToString(row.date),
            })
        .toList();

    final backup = <String, dynamic>{
      'version': backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': {
        'isDarkMode': prefs.getBool(SharedPreferencesKeys.isDarkMode),
        'useCustomList': prefs.getBool(SharedPreferencesKeys.useCustomList),
      },
      'stats': {
        'statsData': prefs.getStringList(SharedPreferencesKeys.statsData),
        'guessDistribution':
            prefs.getStringList(SharedPreferencesKeys.guessDistribution),
      },
      'history': history,
    };

    if (includeWordList && await hasCustomWordList()) {
      backup['customWordList'] = await (await _customListFile()).readAsLines();
    }

    return backup;
  }

  /// Writes a pretty-printed backup JSON to a file in the temporary directory
  /// and returns it, ready to be handed to `share_plus`.
  ///
  /// The file name embeds today's date, e.g. `red_owl_backup_2024-05-23.json`.
  Future<File> exportToFile({required bool includeWordList}) async {
    final backup = await buildBackup(includeWordList: includeWordList);
    final jsonString = const JsonEncoder.withIndent('  ').convert(backup);

    final dir = await getTemporaryDirectory();
    final fileName = 'red_owl_backup_${dateToString(DateTime.now())}.json';
    final file = File(path.join(dir.path, fileName));
    await file.writeAsString(jsonString);
    return file;
  }

  /// Parses [jsonString] and applies it, replacing the current settings, stats,
  /// history and (when present) custom word list.
  ///
  /// Validation runs to completion **before** anything is written, so an
  /// invalid file throws a [FormatException] and leaves all existing data
  /// untouched. Unknown or missing sections are skipped rather than treated as
  /// errors, so partial backups still import cleanly.
  Future<void> importFromJson(String jsonString) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonString);
    } on FormatException {
      throw const FormatException('File is not valid JSON');
    }
    if (decoded is! Map) {
      throw const FormatException('Backup root must be a JSON object');
    }

    final version = decoded['version'];
    if (version is! int || version > backupVersion) {
      throw FormatException('Unsupported backup version: $version');
    }

    // ── Validate history up-front so a bad entry aborts before any write ──────
    final historyEntries = <HistoryCompanion>[];
    final rawHistory = decoded['history'];
    if (rawHistory != null) {
      if (rawHistory is! List) {
        throw const FormatException('"history" must be a list');
      }
      final validStates = GameState.values.map((e) => e.name).toSet();
      for (final entry in rawHistory) {
        if (entry is! Map) {
          throw const FormatException('Invalid history entry');
        }
        final word = entry['word'];
        final gameState = entry['gameState'];
        final dateStr = entry['date'];
        if (word is! String || word.length != 5) {
          throw FormatException('Invalid history word: $word');
        }
        if (gameState is! String || !validStates.contains(gameState)) {
          throw FormatException('Invalid game state: $gameState');
        }
        if (dateStr is! String) {
          throw const FormatException('Invalid history date');
        }
        final DateTime date;
        try {
          date = getDateOnly(DateTime.parse(dateStr));
        } on FormatException {
          throw FormatException('Invalid history date: $dateStr');
        }
        historyEntries.add(HistoryCompanion.insert(
          word: word,
          date: date,
          gameState: gameState,
        ));
      }
    }

    // ── All validation passed — apply the backup ─────────────────────────────
    final prefs = SharedPreferenceService();

    final settings = decoded['settings'];
    if (settings is Map) {
      if (settings['isDarkMode'] is bool) {
        prefs.setBool(SharedPreferencesKeys.isDarkMode, settings['isDarkMode']);
      }
      if (settings['useCustomList'] is bool) {
        prefs.setBool(
            SharedPreferencesKeys.useCustomList, settings['useCustomList']);
      }
    }

    final stats = decoded['stats'];
    if (stats is Map) {
      if (stats['statsData'] is List) {
        prefs.setStringList(SharedPreferencesKeys.statsData,
            (stats['statsData'] as List).map((e) => e.toString()).toList());
      }
      if (stats['guessDistribution'] is List) {
        prefs.setStringList(
            SharedPreferencesKeys.guessDistribution,
            (stats['guessDistribution'] as List)
                .map((e) => e.toString())
                .toList());
      }
    }

    // Replace the history table with the imported rows.
    final db = AppDatabase();
    await db.delete(db.history).go();
    for (final entry in historyEntries) {
      await db.into(db.history).insert(entry, mode: InsertMode.insertOrReplace);
    }
    await db.close();

    // Restore the custom word list when present.
    final customWordList = decoded['customWordList'];
    if (customWordList is List) {
      final file = await _customListFile();
      await file
          .writeAsString(customWordList.map((e) => e.toString()).join('\n'));
    }
  }
}
