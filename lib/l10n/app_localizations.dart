import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Red Owl'**
  String get appName;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'HOW TO PLAY'**
  String get howToPlay;

  /// No description provided for @sixTries.
  ///
  /// In en, this message translates to:
  /// **'You have 6 tries to guess the word.'**
  String get sixTries;

  /// No description provided for @helpLine0.
  ///
  /// In en, this message translates to:
  /// **'The color of the letters will change to show how if they are correct.'**
  String get helpLine0;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// No description provided for @helpLine1.
  ///
  /// In en, this message translates to:
  /// **'is green, because it is in the word and in the correct spot'**
  String get helpLine1;

  /// No description provided for @helpLine2.
  ///
  /// In en, this message translates to:
  /// **'is yellow, because it is in the word but in the wrong spot'**
  String get helpLine2;

  /// No description provided for @helpLine3.
  ///
  /// In en, this message translates to:
  /// **'are gray, because they are not in the word'**
  String get helpLine3;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @colorBlindMode.
  ///
  /// In en, this message translates to:
  /// **'Color-blind / high contrast'**
  String get colorBlindMode;

  /// No description provided for @hardMode.
  ///
  /// In en, this message translates to:
  /// **'Hard mode'**
  String get hardMode;

  /// No description provided for @hardModeLocked.
  ///
  /// In en, this message translates to:
  /// **'Hard mode can\'t be changed once you\'ve started today\'s game'**
  String get hardModeLocked;

  /// No description provided for @hardModeLetterMustBe.
  ///
  /// In en, this message translates to:
  /// **'Letter {position} must be {letter}'**
  String hardModeLetterMustBe(int position, String letter);

  /// No description provided for @hardModeMustContain.
  ///
  /// In en, this message translates to:
  /// **'Guess must contain {letter}'**
  String hardModeMustContain(String letter);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get fontSize;

  /// No description provided for @fontSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get fontSizeNormal;

  /// No description provided for @fontSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeLarge;

  /// No description provided for @fontSizeExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get fontSizeExtraLarge;

  /// No description provided for @animationSpeed.
  ///
  /// In en, this message translates to:
  /// **'Animation speed'**
  String get animationSpeed;

  /// No description provided for @motionReduced.
  ///
  /// In en, this message translates to:
  /// **'Reduced'**
  String get motionReduced;

  /// No description provided for @motionFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get motionFast;

  /// No description provided for @motionNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get motionNormal;

  /// No description provided for @motionSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get motionSlow;

  /// No description provided for @a11yEmptyTile.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get a11yEmptyTile;

  /// No description provided for @a11yStatusCorrect.
  ///
  /// In en, this message translates to:
  /// **'correct'**
  String get a11yStatusCorrect;

  /// No description provided for @a11yStatusPresent.
  ///
  /// In en, this message translates to:
  /// **'present'**
  String get a11yStatusPresent;

  /// No description provided for @a11yStatusAbsent.
  ///
  /// In en, this message translates to:
  /// **'absent'**
  String get a11yStatusAbsent;

  /// No description provided for @a11yLetterWithStatus.
  ///
  /// In en, this message translates to:
  /// **'{letter}, {status}'**
  String a11yLetterWithStatus(String letter, String status);

  /// No description provided for @a11yEnterKey.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get a11yEnterKey;

  /// No description provided for @a11yDeleteKey.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get a11yDeleteKey;

  /// No description provided for @a11yWinAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'You won! Solved in {count} of 6 guesses.'**
  String a11yWinAnnouncement(int count);

  /// No description provided for @a11yLossAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Out of guesses. The word was {word}.'**
  String a11yLossAnnouncement(String word);

  /// No description provided for @customWordList.
  ///
  /// In en, this message translates to:
  /// **'Use custom word list'**
  String get customWordList;

  /// No description provided for @gameInProgressChangingWordList.
  ///
  /// In en, this message translates to:
  /// **'Game in progress, changing word list will reset the game'**
  String get gameInProgressChangingWordList;

  /// No description provided for @gameInProgressImportingWordList.
  ///
  /// In en, this message translates to:
  /// **'Game in progress, importing word list will reset the game'**
  String get gameInProgressImportingWordList;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @customList.
  ///
  /// In en, this message translates to:
  /// **'Custom list'**
  String get customList;

  /// No description provided for @importInvalidLine.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: \"{word}\" is not a valid 5-letter word'**
  String importInvalidLine(int line, String word);

  /// No description provided for @importReadError.
  ///
  /// In en, this message translates to:
  /// **'File could not be read. Check that it is a valid .txt file.'**
  String get importReadError;

  /// No description provided for @importTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large. The maximum size is 5 MB.'**
  String get importTooLarge;

  /// No description provided for @importFewWords.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} words. Fewer than 365 means daily words repeat within a year.'**
  String importFewWords(int count);

  /// No description provided for @yetAnotherWordApp.
  ///
  /// In en, this message translates to:
  /// **'Yet another wordle app'**
  String get yetAnotherWordApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @checkOutWordleStats.
  ///
  /// In en, this message translates to:
  /// **'Check out my Wordle! stats'**
  String get checkOutWordleStats;

  /// No description provided for @wordsGuessed.
  ///
  /// In en, this message translates to:
  /// **'Words Guessed'**
  String get wordsGuessed;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// No description provided for @maxStreak.
  ///
  /// In en, this message translates to:
  /// **'Max Streak'**
  String get maxStreak;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @helpGuessCorrect.
  ///
  /// In en, this message translates to:
  /// **'means you guessed correctly'**
  String get helpGuessCorrect;

  /// No description provided for @yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get yellow;

  /// No description provided for @helpGameIncomplete.
  ///
  /// In en, this message translates to:
  /// **'means the game was incomplete'**
  String get helpGameIncomplete;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @helpGuessWrong.
  ///
  /// In en, this message translates to:
  /// **'means you did not manage guess the word'**
  String get helpGuessWrong;

  /// No description provided for @burnt.
  ///
  /// In en, this message translates to:
  /// **'BURNT'**
  String get burnt;

  /// No description provided for @whisk.
  ///
  /// In en, this message translates to:
  /// **'WHISK'**
  String get whisk;

  /// No description provided for @ideas.
  ///
  /// In en, this message translates to:
  /// **'IDEAS'**
  String get ideas;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @guessDistribution.
  ///
  /// In en, this message translates to:
  /// **'Guess Distribution'**
  String get guessDistribution;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @played.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get played;

  /// No description provided for @win.
  ///
  /// In en, this message translates to:
  /// **'Win %'**
  String get win;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @playGameFirst.
  ///
  /// In en, this message translates to:
  /// **'Play a game first.'**
  String get playGameFirst;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @includeWordListTitle.
  ///
  /// In en, this message translates to:
  /// **'Include word list?'**
  String get includeWordListTitle;

  /// No description provided for @includeWordListContent.
  ///
  /// In en, this message translates to:
  /// **'Include your custom word list in the export?'**
  String get includeWordListContent;

  /// No description provided for @importOverwriteWarning.
  ///
  /// In en, this message translates to:
  /// **'Importing will replace your current stats, history and settings. Continue?'**
  String get importOverwriteWarning;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: invalid backup file'**
  String get importFailed;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
