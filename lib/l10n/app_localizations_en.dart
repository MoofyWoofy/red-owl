// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Red Owl';

  @override
  String get daily => 'Daily';

  @override
  String get practice => 'Practice';

  @override
  String get newWord => 'New word';

  @override
  String get stats => 'Stats';

  @override
  String get howToPlay => 'HOW TO PLAY';

  @override
  String get sixTries => 'You have 6 tries to guess the word.';

  @override
  String get helpLine0 =>
      'The color of the letters will change to show if they are correct.';

  @override
  String get example => 'Example';

  @override
  String get helpLine1 =>
      'is green, because it is in the word and in the correct spot';

  @override
  String get helpLine2 =>
      'is yellow, because it is in the word but in the wrong spot';

  @override
  String get helpLine3 => 'are gray, because they are not in the word';

  @override
  String get close => 'Close';

  @override
  String get exit => 'Exit';

  @override
  String get help => 'Help';

  @override
  String get shareResult => 'Share result';

  @override
  String get hint => 'Hint';

  @override
  String hintReveal(int position, String letter) {
    return 'Hint: letter $position is $letter';
  }

  @override
  String get hintAlreadyUsed => 'You\'ve already used today\'s hint';

  @override
  String get share => 'Share';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get colorBlindMode => 'Color-blind / high contrast';

  @override
  String get hardMode => 'Hard mode';

  @override
  String get hardModeLocked =>
      'Hard mode can\'t be changed once you\'ve started today\'s game';

  @override
  String hardModeLetterMustBe(int position, String letter) {
    return 'Letter $position must be $letter';
  }

  @override
  String hardModeMustContain(String letter) {
    return 'Guess must contain $letter';
  }

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get fontSize => 'Text size';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeExtraLarge => 'Extra large';

  @override
  String get animationSpeed => 'Animation speed';

  @override
  String get motionReduced => 'Reduced';

  @override
  String get motionFast => 'Fast';

  @override
  String get motionNormal => 'Normal';

  @override
  String get motionSlow => 'Slow';

  @override
  String get a11yEmptyTile => 'Empty';

  @override
  String get a11yStatusCorrect => 'correct';

  @override
  String get a11yStatusPresent => 'present';

  @override
  String get a11yStatusAbsent => 'absent';

  @override
  String a11yLetterWithStatus(String letter, String status) {
    return '$letter, $status';
  }

  @override
  String get a11yEnterKey => 'Enter';

  @override
  String get a11yDeleteKey => 'Delete';

  @override
  String a11yWinAnnouncement(int count) {
    return 'You won! Solved in $count of 6 guesses.';
  }

  @override
  String a11yLossAnnouncement(String word) {
    return 'Out of guesses. The word was $word.';
  }

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get reminderBody => 'Today\'s word is waiting — come play!';

  @override
  String get customWordList => 'Use custom word list';

  @override
  String get gameInProgressChangingWordList =>
      'Game in progress, changing word list will reset the game';

  @override
  String get gameInProgressImportingWordList =>
      'Game in progress, importing word list will reset the game';

  @override
  String get success => 'Success';

  @override
  String get import => 'Import';

  @override
  String get view => 'View';

  @override
  String get customList => 'Custom list';

  @override
  String importInvalidLine(int line, String word) {
    return 'Line $line: \"$word\" is not a valid 5-letter word';
  }

  @override
  String get importReadError =>
      'File could not be read. Check that it is a valid .txt file.';

  @override
  String get importTooLarge => 'File is too large. The maximum size is 5 MB.';

  @override
  String importFewWords(int count) {
    return 'Imported $count words. Fewer than 365 means daily words repeat within a year.';
  }

  @override
  String get yetAnotherWordApp => 'Yet another wordle app';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get about => 'About';

  @override
  String get checkOutWordleStats => 'Check out my Wordle! stats';

  @override
  String get wordsGuessed => 'Words Guessed';

  @override
  String get winRate => 'Win Rate';

  @override
  String get maxStreak => 'Max Streak';

  @override
  String get green => 'Green';

  @override
  String get helpGuessCorrect => 'means you guessed correctly';

  @override
  String get yellow => 'Yellow';

  @override
  String get helpGameIncomplete => 'means the game was incomplete';

  @override
  String get red => 'Red';

  @override
  String get helpGuessWrong => 'means you did not manage guess the word';

  @override
  String get burnt => 'BURNT';

  @override
  String get whisk => 'WHISK';

  @override
  String get ideas => 'IDEAS';

  @override
  String get resetStats => 'Reset statistics';

  @override
  String get resetStatsConfirm =>
      'This permanently deletes all statistics and game history. Continue?';

  @override
  String get statistics => 'Statistics';

  @override
  String get guessDistribution => 'Guess Distribution';

  @override
  String get history => 'History';

  @override
  String get filterAll => 'All';

  @override
  String get filterLast30 => '30 days';

  @override
  String get filterDateRange => 'Range';

  @override
  String get noGamesInRange => 'No games in this range.';

  @override
  String get played => 'Played';

  @override
  String get wins => 'Wins';

  @override
  String get avgGuesses => 'Avg guesses';

  @override
  String get win => 'Win %';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String streakMilestone(int streak) {
    return '🔥 $streak-day streak! Tap share to brag.';
  }

  @override
  String get playGameFirst => 'Play a game first.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get includeWordListTitle => 'Include word list?';

  @override
  String get includeWordListContent =>
      'Include your custom word list in the export?';

  @override
  String get importOverwriteWarning =>
      'Importing will replace your current stats, history and settings. Continue?';

  @override
  String get importFailed => 'Import failed: invalid backup file';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get youGotIt => 'You got it!';

  @override
  String get notEnoughLetters => 'Not enough letters';

  @override
  String notInWordList(String word) {
    return '\'$word\' is not in the word list';
  }

  @override
  String get betterLuckNextTime => 'Better luck next time';
}
