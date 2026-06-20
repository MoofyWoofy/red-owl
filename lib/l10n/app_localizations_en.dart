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
  String get stats => 'Stats';

  @override
  String get howToPlay => 'HOW TO PLAY';

  @override
  String get sixTries => 'You have 6 tries to guess the word.';

  @override
  String get helpLine0 =>
      'The color of the letters will change to show how if they are correct.';

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
  String get share => 'Share';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

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
  String get statistics => 'Statistics';

  @override
  String get guessDistribution => 'Guess Distribution';

  @override
  String get history => 'History';

  @override
  String get played => 'Played';

  @override
  String get win => 'Win %';

  @override
  String get currentStreak => 'Current Streak';

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
}
