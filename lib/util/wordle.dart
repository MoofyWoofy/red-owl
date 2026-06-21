import 'dart:io';
import 'dart:math' as math show Random;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

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
    _wordOfTheDay = await getWordOfTheDay();
  }

  /// Returns the word of the day for [wordDate] (defaults to today).
  ///
  /// Seeds a [Random] with the integer form of the date (`yyyyMMdd`) so that
  /// the same date always produces the same word across devices and restarts.
  Future<String> getWordOfTheDay([DateTime? wordDate]) async {
    final wordlist = await getWordList;
    final date = wordDate ?? DateTime.now();
    // Deterministic seed: same date → same word everywhere.
    final random = math.Random(int.parse(DateFormat('yyyyMMdd').format(date)));
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
  Future<List<String>> get getWordList async {
    // Serve the cached copy if it has already been loaded for this source.
    final cached = _cachedWordList;
    if (cached != null) return cached;

    var useCustomList =
        SharedPreferenceService().getBool(SharedPreferencesKeys.useCustomList);
    List<String> words;
    if (useCustomList != null && useCustomList) {
      Directory directory = await getApplicationDocumentsDirectory();
      try {
        File file = File(path.join(directory.path, 'custom_list.txt'));
        final lines = await file.readAsLines();
        words = lines
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList();
      } on PathNotFoundException {
        // File doesn't exist yet — seed it from the bundled asset.
        final String data = await rootBundle.loadString('assets/word_list.txt');
        words = data
            .split('\n')
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList();

        File file = File('${directory.path}/custom_list.txt');
        file.writeAsString(words.join('\n'));
      }
    } else {
      final String data = await rootBundle.loadString('assets/word_list.txt');
      words = data
          .split('\n')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    _cachedWordList = words;
    return words;
  }

  /// Matches a single valid word: exactly five ASCII letters.
  static final RegExp _wordPattern = RegExp(r'^[a-zA-Z]{5}$');

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

    return WordListImportResult.success(
      uniqueWords,
      belowRecommendedMinimum: uniqueWords.length < recommendedMinimumWords,
    );
  }

  /// Evaluates a single [guessCharacter] at position [idx] against [answer].
  ///
  /// Returns a raw JSON-compatible map with `char`, `in_word`, and
  /// `correct_idx` fields used to build [CharacterInfo] objects.
  Map<String, dynamic> _checkCharacter(
      String guessCharacter, String answer, int idx) {
    return {
      'char': guessCharacter,
      'scoring': {
        'in_word': answer.contains(guessCharacter),
        'correct_idx': guessCharacter == answer[idx],
      }
    };
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
    List<Map<String, dynamic>> guessResult = [];
    for (int idx = 0; idx < guessWord.length; idx++) {
      guessResult.add(_checkCharacter(guessWord[idx], target, idx));
    }
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
