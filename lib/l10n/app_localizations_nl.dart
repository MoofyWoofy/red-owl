// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Rode Uil';

  @override
  String get daily => 'Dagelijks';

  @override
  String get practice => 'Oefenen';

  @override
  String get newWord => 'Nieuw woord';

  @override
  String get stats => 'Statistieken';

  @override
  String get howToPlay => 'HOE TE SPELEN';

  @override
  String get sixTries => 'Je hebt 6 pogingen om het woord te raden.';

  @override
  String get helpLine0 =>
      'De kleur van de letters verandert om aan te geven of ze correct zijn.';

  @override
  String get example => 'Voorbeeld';

  @override
  String get helpLine1 =>
      'is groen, omdat het in het woord zit en op de juiste plek staat';

  @override
  String get helpLine2 =>
      'is geel, omdat het in het woord zit maar op de verkeerde plek staat';

  @override
  String get helpLine3 => 'zijn grijs, omdat ze niet in het woord zitten';

  @override
  String get close => 'Sluiten';

  @override
  String get exit => 'Afsluiten';

  @override
  String get help => 'Help';

  @override
  String get hint => 'Hint';

  @override
  String hintReveal(int position, String letter) {
    return 'Hint: letter $position is $letter';
  }

  @override
  String get hintAlreadyUsed => 'Je hebt de hint van vandaag al gebruikt';

  @override
  String get share => 'Delen';

  @override
  String get settings => 'Instellingen';

  @override
  String get darkMode => 'Donkere modus';

  @override
  String get colorBlindMode => 'Kleurenblind / hoog contrast';

  @override
  String get hardMode => 'Moeilijke modus';

  @override
  String get hardModeLocked =>
      'Moeilijke modus kan niet worden gewijzigd zodra je vandaag bent begonnen';

  @override
  String hardModeLetterMustBe(int position, String letter) {
    return 'Letter $position moet $letter zijn';
  }

  @override
  String hardModeMustContain(String letter) {
    return 'Gok moet $letter bevatten';
  }

  @override
  String get language => 'Taal';

  @override
  String get systemDefault => 'Systeemstandaard';

  @override
  String get fontSize => 'Tekstgrootte';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeNormal => 'Normaal';

  @override
  String get fontSizeLarge => 'Groot';

  @override
  String get fontSizeExtraLarge => 'Extra groot';

  @override
  String get animationSpeed => 'Animatiesnelheid';

  @override
  String get motionReduced => 'Verminderd';

  @override
  String get motionFast => 'Snel';

  @override
  String get motionNormal => 'Normaal';

  @override
  String get motionSlow => 'Langzaam';

  @override
  String get a11yEmptyTile => 'Leeg';

  @override
  String get a11yStatusCorrect => 'correct';

  @override
  String get a11yStatusPresent => 'aanwezig';

  @override
  String get a11yStatusAbsent => 'afwezig';

  @override
  String a11yLetterWithStatus(String letter, String status) {
    return '$letter, $status';
  }

  @override
  String get a11yEnterKey => 'Enter';

  @override
  String get a11yDeleteKey => 'Verwijderen';

  @override
  String a11yWinAnnouncement(int count) {
    return 'Gewonnen! Opgelost in $count van 6 pogingen.';
  }

  @override
  String a11yLossAnnouncement(String word) {
    return 'Geen pogingen meer. Het woord was $word.';
  }

  @override
  String get customWordList => 'Gebruik aangepaste woordenlijst';

  @override
  String get gameInProgressChangingWordList =>
      'Spel bezig, het wijzigen van de woordenlijst zal het spel resetten';

  @override
  String get gameInProgressImportingWordList =>
      'Spel bezig, het importeren van de woordenlijst zal het spel resetten';

  @override
  String get success => 'Succes';

  @override
  String get import => 'Importeren';

  @override
  String get view => 'Bekijken';

  @override
  String get customList => 'Aangepaste lijst';

  @override
  String importInvalidLine(int line, String word) {
    return 'Regel $line: \"$word\" is geen geldig woord van 5 letters';
  }

  @override
  String get importReadError =>
      'Bestand kon niet worden gelezen. Controleer of het een geldig .txt-bestand is.';

  @override
  String get importTooLarge =>
      'Bestand is te groot. De maximale grootte is 5 MB.';

  @override
  String importFewWords(int count) {
    return '$count woorden geïmporteerd. Minder dan 365 betekent dat dagelijkse woorden binnen een jaar herhalen.';
  }

  @override
  String get yetAnotherWordApp => 'Nog een Wordle-app';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get about => 'Over';

  @override
  String get checkOutWordleStats => 'Bekijk mijn Wordle! statistieken';

  @override
  String get wordsGuessed => 'Woorden Geraden';

  @override
  String get winRate => 'Winstpercentage';

  @override
  String get maxStreak => 'Maximale Reeks';

  @override
  String get green => 'Groen';

  @override
  String get helpGuessCorrect => 'betekent dat je correct hebt geraden';

  @override
  String get yellow => 'Geel';

  @override
  String get helpGameIncomplete => 'betekent dat het spel niet voltooid was';

  @override
  String get red => 'Rood';

  @override
  String get helpGuessWrong => 'betekent dat je het woord niet hebt geraden';

  @override
  String get burnt => 'VERBRAND';

  @override
  String get whisk => 'GARD';

  @override
  String get ideas => 'IDEËEN';

  @override
  String get statistics => 'Statistieken';

  @override
  String get guessDistribution => 'Gokverdeling';

  @override
  String get history => 'Geschiedenis';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterLast30 => '30 dagen';

  @override
  String get filterDateRange => 'Bereik';

  @override
  String get noGamesInRange => 'Geen spellen in dit bereik.';

  @override
  String get played => 'Gespeeld';

  @override
  String get wins => 'Gewonnen';

  @override
  String get avgGuesses => 'Gem. pogingen';

  @override
  String get win => 'Winst %';

  @override
  String get currentStreak => 'Huidige Reeks';

  @override
  String get playGameFirst => 'Speel eerst een spel.';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get exportData => 'Gegevens exporteren';

  @override
  String get importData => 'Gegevens importeren';

  @override
  String get includeWordListTitle => 'Woordenlijst opnemen?';

  @override
  String get includeWordListContent =>
      'Je aangepaste woordenlijst opnemen in de export?';

  @override
  String get importOverwriteWarning =>
      'Importeren vervangt je huidige statistieken, geschiedenis en instellingen. Doorgaan?';

  @override
  String get importFailed => 'Importeren mislukt: ongeldig back-upbestand';

  @override
  String get exportFailed => 'Exporteren mislukt';
}
