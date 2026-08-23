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
import 'package:red_owl/util/wordle.dart' show WordleService;

/// Serialises the user's data to a single JSON document and restores it again.
///
/// The backup covers three categories of data, mirroring how the app stores
/// them:
/// - **settings** — every user preference from SharedPreferences: the dark
///   mode, color-blind, hard mode, custom-list and reminder toggles, plus the
///   language, text-size, animation-speed and reminder-time values.
/// - **stats** — the `statsData` and `guessDistribution` arrays from
///   SharedPreferences.
/// - **history** — every row of the Drift [History] table.
///
/// The custom word list (`custom_list.txt`) is *optionally* included; the
/// caller decides at export time (see [hasCustomWordList]).
///
/// The in-progress game board ([SharedPreferencesKeys.gridState]), the game
/// date and the hint-used date are deliberately **not** part of a backup —
/// they are transient daily state, not something worth transferring between
/// devices.
///
/// Implemented as a singleton so it can be swapped/mocked consistently with the
/// other services ([SharedPreferenceService], [WordleService]).
class BackupService {
  /// Schema version written into every backup. Bump when the format changes in
  /// a way [importFromJson] needs to branch on; imports with a higher version
  /// than this are rejected.
  ///
  /// - **1** — `settings` carried only `isDarkMode` and `useCustomList`.
  /// - **2** — `settings` carries every user preference (see
  ///   [_backedUpBoolSettings] / [_backedUpStringSettings]). Version 1 files
  ///   still import: the extra keys are simply absent and those preferences are
  ///   left at their current values.
  static const int backupVersion = 2;

  /// Boolean preferences included in a backup, keyed by their JSON field name.
  ///
  /// Everything the user can toggle in Settings belongs here. Transient daily
  /// state (`gridState`, `gameDate`, `hintUsedDate`) is deliberately excluded.
  static const Map<String, SharedPreferencesKeys> _backedUpBoolSettings = {
    'isDarkMode': SharedPreferencesKeys.isDarkMode,
    'useCustomList': SharedPreferencesKeys.useCustomList,
    'isColorBlindMode': SharedPreferencesKeys.isColorBlindMode,
    'isHardMode': SharedPreferencesKeys.isHardMode,
    'reminderEnabled': SharedPreferencesKeys.reminderEnabled,
  };

  /// String preferences included in a backup, keyed by their JSON field name.
  ///
  /// The values are opaque codes (`localeCode`, `fontScale`, `motionSpeed`) and
  /// an `HH:mm` reminder time. They are type-checked on import but not matched
  /// against a known-code list: each notifier already falls back to its default
  /// for a value it does not recognise, so a stale code degrades rather than
  /// failing the whole import.
  static const Map<String, SharedPreferencesKeys> _backedUpStringSettings = {
    'localeCode': SharedPreferencesKeys.localeCode,
    'fontScale': SharedPreferencesKeys.fontScale,
    'motionSpeed': SharedPreferencesKeys.motionSpeed,
    'reminderTime': SharedPreferencesKeys.reminderTime,
  };

  static const String _customListFileName = 'custom_list.txt';

  /// Expected length of the `statsData` array:
  /// `[gamesPlayed, gamesWon, currentStreak, maxStreak]`. `Grid._updateStatsData`
  /// destructures exactly these four positions.
  static const int statsDataLength = 4;

  /// Expected length of the `guessDistribution` array: one counter per possible
  /// winning row (1–6). `Grid._updateStatsData` indexes it by row.
  static const int guessDistributionLength = 6;

  /// Validates one persisted counter array, returning it as the list of strings
  /// the preference store holds, or `null` when the section is absent.
  ///
  /// Requires exactly [expectedLength] entries, each a non-negative integer, so
  /// the array can never break the `int.parse` / positional-index reads that
  /// consume it. Throws a [FormatException] describing [label] otherwise.
  static List<String>? _parseCounters(
      Object? raw, int expectedLength, String label) {
    if (raw == null) return null;
    if (raw is! List) {
      throw FormatException('"$label" must be a list');
    }
    if (raw.length != expectedLength) {
      throw FormatException(
          '"$label" must have $expectedLength entries, got ${raw.length}');
    }
    return [
      for (final entry in raw)
        () {
          final value = int.tryParse(entry.toString());
          if (value == null || value < 0) {
            throw FormatException('"$label" has a non-numeric entry: $entry');
          }
          return value.toString();
        }(),
    ];
  }

  /// Validates the optional `customWordList` section, returning the words to
  /// write, or `null` when the section is absent.
  ///
  /// Held to the same rule as [WordleService.importWordList]: every entry must
  /// be exactly five ASCII letters ([WordleService.isValidWord]), blanks are
  /// dropped, and duplicates are removed case-insensitively (repeats would bias
  /// the deterministic word-of-the-day seeding). A section that is present but
  /// yields no usable words is rejected.
  ///
  /// Without this the section went to disk unchecked, while a list picked from
  /// a file did not. The word of the day is drawn from whatever is on disk on
  /// every launch, and the board is built for five-letter answers -- the fixed
  /// five columns and the `i % 5` scoring in `Grid.onKeyboardPressed` both
  /// assume it -- so an unchecked list breaks the game rather than the import.
  static List<String>? _parseCustomWordList(Object? raw) {
    if (raw == null) return null;
    if (raw is! List) {
      throw const FormatException('"customWordList" must be a list');
    }
    final seen = <String>{};
    final words = <String>[];
    for (final entry in raw) {
      if (entry is! String) {
        throw FormatException('Invalid word-list entry: $entry');
      }
      final word = entry.trim();
      // Blank lines (e.g. a trailing newline in the exported file) are noise.
      if (word.isEmpty) continue;
      if (!WordleService.isValidWord(word)) {
        throw FormatException('Invalid word-list entry: $entry');
      }
      if (seen.add(word.toLowerCase())) words.add(word);
    }
    if (words.isEmpty) {
      throw const FormatException('"customWordList" has no usable words');
    }
    return words;
  }

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

    // Read the whole history table (shared singleton connection).
    final db = AppDatabase();
    final historyRows = await db.select(db.history).get();

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
        for (final entry in _backedUpBoolSettings.entries)
          entry.key: prefs.getBool(entry.value),
        for (final entry in _backedUpStringSettings.entries)
          entry.key: prefs.getString(entry.value),
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
  /// Validation of the `history` rows, the `stats` counter arrays and the
  /// `customWordList` entries all runs to completion **before** anything is
  /// written, so an invalid file throws a [FormatException] and leaves all
  /// existing data untouched. Unknown or missing sections are skipped rather
  /// than treated as errors, so partial backups still import cleanly.
  ///
  /// The history replacement runs in a single transaction, so a write that
  /// fails midway cannot leave the table half-restored either.
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

    // ── Validate stats up-front too ──────────────────────────────────────────
    // These arrays are read back with `int.parse` and positional destructuring
    // (`Grid._updateStatsData`) and with `double.parse` (the Stats page), so a
    // wrong length or a non-numeric entry does not fail here — it breaks the
    // next finished game instead. Reject the file rather than write it.
    List<String>? statsData;
    List<String>? guessDistribution;
    final stats = decoded['stats'];
    if (stats is Map) {
      statsData = _parseCounters(
          stats['statsData'], statsDataLength, 'stats.statsData');
      guessDistribution = _parseCounters(stats['guessDistribution'],
          guessDistributionLength, 'stats.guessDistribution');
    }

    // ── And the custom word list, before it can reach disk ───────────────────
    final customWordList = _parseCustomWordList(decoded['customWordList']);

    // ── All validation passed — apply the backup ─────────────────────────────
    final prefs = SharedPreferenceService();

    final settings = decoded['settings'];
    if (settings is Map) {
      // Absent keys are skipped, so a version 1 backup (which carried only
      // isDarkMode and useCustomList) still imports cleanly.
      _backedUpBoolSettings.forEach((field, key) {
        final value = settings[field];
        if (value is bool) prefs.setBool(key, value);
      });
      _backedUpStringSettings.forEach((field, key) {
        final value = settings[field];
        if (value is String) prefs.setString(key, value);
      });
    }

    if (statsData != null) {
      prefs.setStringList(SharedPreferencesKeys.statsData, statsData);
    }
    if (guessDistribution != null) {
      prefs.setStringList(
          SharedPreferencesKeys.guessDistribution, guessDistribution);
    }

    // Replace the history table with the imported rows (shared singleton).
    //
    // One transaction, because the delete would otherwise commit before the
    // inserts: a failure (or the app being killed) partway through the loop
    // left history permanently truncated, with the original rows already gone
    // and the replacements never written. The batch also collapses what were
    // per-row round trips into a single set of statements.
    final db = AppDatabase();
    await db.transaction(() async {
      await db.delete(db.history).go();
      await db.batch((batch) => batch.insertAll(
            db.history,
            historyEntries,
            mode: InsertMode.insertOrReplace,
          ));
    });

    // Restore the custom word list when present (validated above).
    if (customWordList != null) {
      final file = await _customListFile();
      await file.writeAsString(customWordList.join('\n'));
    }
  }
}
