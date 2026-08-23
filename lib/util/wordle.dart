import 'dart:io';
import 'dart:math' as math show Random;
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

/// Splits raw word-list text into trimmed, lower-case, non-empty words.
///
/// Top-level (not a method) so it can be handed to [compute] and run in a
/// background isolate, keeping the ~13k-line parse off the UI thread.
List<String> _parseWordList(String data) => data
    .split('\n')
    .map((e) => e.trim().toLowerCase())
    .where((e) => e.isNotEmpty)
    .toList();

/// Singleton service that manages the word list and evaluates player guesses.
///
/// Responsibilities:
/// - Loads the word list from the bundled asset or the user's custom file.
/// - Derives a deterministic "word of the day" by seeding a [Random] with
///   the numeric date (`yyyyMMdd`), so every device gets the same word.
/// - Checks a submitted guess against the current answer and returns a raw
///   JSON map that [GuessResult.fromJson] can deserialise.
///
/// Implemented as a singleton (`factory` constructor returns `_instance`) so
/// the word-of-the-day is only computed once per app launch.
class WordleService {
  /// The answer for today's game, set by [init].
  late String _wordOfTheDay;

  /// Lazily-populated, normalised copy of the active word list.
  ///
  /// `getWordList` reads from disk/assets on the first call and reuses this for
  /// subsequent calls (every guess hits the list), so the file is only read
  /// once per list source. [init] clears it whenever the source may have
  /// changed (custom-list toggle, import, or backup restore).
  List<String>? _cachedWordList;

  /// The in-flight load, if one is running.
  ///
  /// Startup issues concurrent reads (the word of the day and the rehydrated
  /// board both want the list), and each miss would otherwise read the file and
  /// spawn its own `compute` isolate to parse ~13k lines. Sharing the future
  /// collapses those into one load.
  Future<List<String>>? _pendingLoad;

  static final WordleService _instance = WordleService._internal();

  /// Returns the singleton [WordleService] instance.
  factory WordleService() => _instance;

  WordleService._internal();

  /// Today's word (uppercase). Must call [init] before accessing.
  String get wordOfTheDay => _wordOfTheDay;

  /// Initialises the service by loading [_wordOfTheDay] for today.
  ///
  /// Must be awaited during app startup (in `main()`) before the first
  /// widget build. Can be called again after the custom word list is
  /// imported to pick a new word from the updated list; doing so clears the
  /// cached list so the new source is re-read.
  Future<void> init() async {
    _cachedWordList = null;
    _pendingLoad = null;
    _wordOfTheDay = await getWordOfTheDay();
  }

  /// Returns the word of the day for [wordDate] (defaults to today).
  ///
  /// Seeds a [Random] with the integer form of the date (`yyyyMMdd`) so that
  /// the same date always produces the same word across devices and restarts.
  Future<String> getWordOfTheDay([DateTime? wordDate]) async {
    final wordlist = await getWordList;
    final date = wordDate ?? DateTime.now();
    // Deterministic seed: same date → same word everywhere. Built arithmetically
    // rather than via `DateFormat('yyyyMMdd')`, which formats with the ambient
    // `Intl.defaultLocale` — a locale that renders non-ASCII digits would make
    // the seed unparseable and change the word of the day per device. The value
    // is identical to the old one for every Gregorian date.
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = math.Random(seed);
    return wordlist[random.nextInt(wordlist.length)].trim().toUpperCase();
  }

  /// Returns a non-deterministic random word (uppercase) from the active list.
  ///
  /// Used by the practice / unlimited mode, where each game should pick a fresh
  /// answer unrelated to the date so the daily word isn't spoiled.
  Future<String> randomWord() async {
    final wordlist = await getWordList;
    final random = math.Random();
    return wordlist[random.nextInt(wordlist.length)].trim().toUpperCase();
  }

  /// Resolves and returns the active word list.
  ///
  /// When the user has enabled the custom word list and the file exists,
  /// reads `custom_list.txt` from the application documents directory.
  /// If the file is missing (e.g. user enabled the toggle but never imported),
  /// copies the bundled list to `custom_list.txt` and returns that.
  /// Falls back to the bundled `assets/word_list.txt` when the custom list
  /// feature is disabled.
  ///
  /// Every word is normalised to a trimmed, lower-case form so that guess
  /// matching in [checkGuessWord] (which lower-cases the guess) is independent
  /// of how the imported file was cased or spaced.
  Future<List<String>> get getWordList {
    // Serve the cached copy if it has already been loaded for this source.
    final cached = _cachedWordList;
    if (cached != null) return Future.value(cached);

    // Join the load already in flight rather than starting a second one.
    return _pendingLoad ??= _loadWordList().then((words) {
      _cachedWordList = words;
      _pendingLoad = null;
      return words;
    }, onError: (Object error, StackTrace stackTrace) {
      // Clear the slot so a later call can retry instead of replaying the
      // failure forever.
      _pendingLoad = null;
      Error.throwWithStackTrace(error, stackTrace);
    });
  }

  /// Reads and parses the active word list from disk or the bundled asset.
  Future<List<String>> _loadWordList() async {
    var useCustomList =
        SharedPreferenceService().getBool(SharedPreferencesKeys.useCustomList);
    List<String> words;
    if (useCustomList != null && useCustomList) {
      Directory directory = await getApplicationDocumentsDirectory();
      try {
        File file = File(path.join(directory.path, 'custom_list.txt'));
        final contents = await file.readAsString();
        words = await compute(_parseWordList, contents);
      } on PathNotFoundException {
        // File doesn't exist yet — seed it from the bundled asset.
        final String data = await rootBundle.loadString('assets/word_list.txt');
        words = await compute(_parseWordList, data);

        File file = File('${directory.path}/custom_list.txt');
        await file.writeAsString(words.join('\n'));
      }

      // A custom list with no usable words cannot answer `getWordOfTheDay`
      // (`nextInt(0)` throws) and, since it is read on every launch, would stop
      // the app from starting at all. Both write paths now reject an empty list
      // (`importWordList` and `BackupService.importFromJson`), but a file
      // written by an older build can still be on disk, so fall back to the
      // bundled list rather than failing.
      if (words.isEmpty) {
        final String data = await rootBundle.loadString('assets/word_list.txt');
        words = await compute(_parseWordList, data);
      }
    } else {
      final String data = await rootBundle.loadString('assets/word_list.txt');
      words = await compute(_parseWordList, data);
    }

    return words;
  }

  /// Matches a single valid word: exactly five ASCII letters.
  static final RegExp _wordPattern = RegExp(r'^[a-zA-Z]{5}$');

  /// Whether [word] is a usable word-list entry: exactly five ASCII letters.
  ///
  /// Exposed so [BackupService] can hold a word list restored from a backup to
  /// the same rule [importWordList] applies to one picked from a file, rather
  /// than keeping a second copy of the pattern that could drift from this one.
  static bool isValidWord(String word) => _wordPattern.hasMatch(word);

  /// A custom list with fewer than this many unique words won't last a full
  /// year of daily play before words repeat. Imports below it still succeed but
  /// are flagged with a warning.
  static const int recommendedMinimumWords = 365;

  /// Upper bound on the size of an importable word-list file. Anything larger is
  /// rejected rather than read fully into memory (a 5-letter-per-line list this
  /// big is far beyond any legitimate dictionary).
  static const int maxImportFileBytes = 5 * 1024 * 1024;

  /// Validates [file] as a custom word list and, if it is valid, writes it to
  /// `custom_list.txt` in the application documents directory.
  ///
  /// Returns a [WordListImportResult] describing the outcome so the caller can
  /// show an appropriate, localised message:
  /// - [WordListImportStatus.readError] — the file could not be read.
  /// - [WordListImportStatus.invalidWord] — a line is not a 5-letter word
  ///   ([WordListImportResult.lineNumber] / [WordListImportResult.invalidWord]).
  /// - [WordListImportStatus.success] — the list was saved.
  ///
  /// Blank lines (e.g. a trailing newline) are ignored, and duplicate words are
  /// removed case-insensitively (keeping the first occurrence) so they don't
  /// skew the deterministic daily-word seeding. On success the cached word list
  /// is cleared; the caller should re-run [init] to pick the new word of the
  /// day.
  Future<WordListImportResult> importWordList(File file) async {
    // Guard the size before reading the whole file into memory.
    final int length;
    try {
      length = await file.length();
    } on FileSystemException {
      return const WordListImportResult.readError();
    }
    if (length > maxImportFileBytes) {
      return const WordListImportResult.fileTooLarge();
    }

    final String contents;
    try {
      contents = await file.readAsString();
    } on FileSystemException {
      return const WordListImportResult.readError();
    }

    final words = contents
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // An empty list would make the word of the day unresolvable
    // (`nextInt(0)` throws), and because the list is persisted the failure
    // repeats on every launch — `main()` awaits `WordleService().init()`, so
    // the app would no longer start. Reject it here instead.
    if (words.isEmpty) {
      return const WordListImportResult.empty();
    }

    for (var i = 0; i < words.length; i++) {
      if (!_wordPattern.hasMatch(words[i])) {
        return WordListImportResult.invalidWord(i + 1, words[i]);
      }
    }

    // Drop duplicates (case-insensitively) while preserving order, since the
    // active list is lower-cased on read and repeats would bias word-of-the-day.
    final seen = <String>{};
    final uniqueWords = [
      for (final word in words)
        if (seen.add(word.toLowerCase())) word,
    ];

    final directory = await getApplicationDocumentsDirectory();
    final dest = File(path.join(directory.path, 'custom_list.txt'));
    await dest.writeAsString(uniqueWords.join('\n'));
    _cachedWordList = null;
    _pendingLoad = null;

    return WordListImportResult.success(
      uniqueWords,
      belowRecommendedMinimum: uniqueWords.length < recommendedMinimumWords,
    );
  }

  /// Scores every character of [guessWord] against [answer] using the standard
  /// Wordle two-pass algorithm, returning raw JSON-compatible maps with `char`,
  /// `in_word` and `correct_idx` fields for [CharacterInfo].
  ///
  /// Each letter of the answer may only be consumed **once**. A naive
  /// `answer.contains(letter)` test over-reports repeated letters: for answer
  /// `CRANE` and guess `EERIE` it would mark all three `E`s, when only the
  /// final (exact-match) `E` may be credited.
  ///
  /// Pass 1 claims exact matches (green) and tallies the answer letters they
  /// did *not* consume. Pass 2 walks left to right and marks a letter present
  /// (yellow) only while unclaimed copies of it remain, so the number of
  /// green + yellow marks for a letter never exceeds its count in the answer.
  ///
  /// Example — answer `CRANE`, guess `EERIE`:
  /// `[grey, grey, yellow, grey, green]` (the single `E` is spent on the
  /// exact match at index 4, leaving none for indices 0 and 1).
  static List<Map<String, dynamic>> _scoreGuess(
      String guessWord, String answer) {
    final length = guessWord.length;
    final isCorrectIndex = List<bool>.filled(length, false);
    final isPresent = List<bool>.filled(length, false);

    // Pass 1 — exact matches, tallying the answer letters left over.
    final unclaimed = <String, int>{};
    for (var idx = 0; idx < length; idx++) {
      if (idx < answer.length && guessWord[idx] == answer[idx]) {
        isCorrectIndex[idx] = true;
      } else if (idx < answer.length) {
        unclaimed.update(answer[idx], (count) => count + 1, ifAbsent: () => 1);
      }
    }

    // Pass 2 — present-but-misplaced, consuming from the leftovers.
    for (var idx = 0; idx < length; idx++) {
      if (isCorrectIndex[idx]) continue;
      final character = guessWord[idx];
      final remaining = unclaimed[character] ?? 0;
      if (remaining > 0) {
        isPresent[idx] = true;
        unclaimed[character] = remaining - 1;
      }
    }

    return [
      for (var idx = 0; idx < length; idx++)
        {
          'char': guessWord[idx],
          'scoring': {
            // Greens are in the word too; the grid checks `correct_idx` first.
            'in_word': isCorrectIndex[idx] || isPresent[idx],
            'correct_idx': isCorrectIndex[idx],
          }
        }
    ];
  }

  /// Evaluates [guessWord] against the answer and returns a raw JSON map
  /// suitable for [GuessResult.fromJson].
  ///
  /// [answer] defaults to today's word; the practice mode passes its own random
  /// answer so the same evaluation logic serves both flows.
  ///
  /// Three outcomes:
  /// 1. **Correct** – [guessWord] matches the answer.
  ///    `is_correct: true`, no character_info needed.
  /// 2. **Not in list** – word not found in the active word list.
  ///    `is_word_in_list: false`, row does not advance.
  /// 3. **In list but wrong** – returns per-character scoring
  ///    (`character_info`) so each tile can be coloured green/yellow/grey.
  Future<Map<String, dynamic>> checkGuessWord(String guessWord,
      {String? answer}) async {
    final target = answer ?? _wordOfTheDay;
    if (guessWord == target) {
      return {
        'guess': guessWord,
        'is_correct': true,
        'is_word_in_list': true,
      };
    }

    // Check if the word is in the word list.
    List<String> wordList = await getWordList;
    if (!wordList.contains(guessWord.toLowerCase())) {
      return {
        'guess': guessWord,
        'is_correct': false,
        'is_word_in_list': false,
      };
    }

    // Word is valid — evaluate each character against the answer.
    final guessResult = _scoreGuess(guessWord, target);
    return {
      'guess': guessWord,
      'is_correct': false,
      'is_word_in_list': true,
      'character_info': guessResult,
    };
  }
}

/// Outcome categories for [WordleService.importWordList].
enum WordListImportStatus {
  /// The list was valid and saved.
  success,

  /// A line was not a valid 5-letter word.
  invalidWord,

  /// The chosen file could not be read.
  readError,

  /// The chosen file contained no words at all.
  empty,

  /// The chosen file exceeds [WordleService.maxImportFileBytes].
  fileTooLarge,
}

/// Result of attempting to import a custom word list.
///
/// Carries enough detail for the UI to build a specific, localised message
/// (e.g. which line failed) without the service depending on Flutter widgets.
class WordListImportResult {
  /// Successful import; [words] holds the saved, de-duplicated list.
  ///
  /// [belowRecommendedMinimum] is `true` when the list has fewer than
  /// [WordleService.recommendedMinimumWords] words.
  const WordListImportResult.success(
    this.words, {
    this.belowRecommendedMinimum = false,
  })  : status = WordListImportStatus.success,
        lineNumber = null,
        invalidWord = null;

  /// A line failed validation. [lineNumber] is 1-based; [invalidWord] is the
  /// offending text.
  const WordListImportResult.invalidWord(this.lineNumber, this.invalidWord)
      : status = WordListImportStatus.invalidWord,
        words = null,
        belowRecommendedMinimum = false;

  /// The file contained no words at all (blank, or only blank lines).
  const WordListImportResult.empty()
      : status = WordListImportStatus.empty,
        words = null,
        lineNumber = null,
        invalidWord = null,
        belowRecommendedMinimum = false;

  /// The file could not be read.
  const WordListImportResult.readError()
      : status = WordListImportStatus.readError,
        words = null,
        lineNumber = null,
        invalidWord = null,
        belowRecommendedMinimum = false;

  /// The file exceeded the maximum allowed size.
  const WordListImportResult.fileTooLarge()
      : status = WordListImportStatus.fileTooLarge,
        words = null,
        lineNumber = null,
        invalidWord = null,
        belowRecommendedMinimum = false;

  /// The category of outcome.
  final WordListImportStatus status;

  /// The saved words on success, otherwise `null`.
  final List<String>? words;

  /// 1-based line number of the first invalid word, if any.
  final int? lineNumber;

  /// The offending text for [WordListImportStatus.invalidWord].
  final String? invalidWord;

  /// Whether a successful import had fewer than the recommended number of words.
  final bool belowRecommendedMinimum;
}
