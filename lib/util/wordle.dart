import 'dart:io';
import 'dart:math' as math show Random;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

class WordleService {
  /// Word of the day
  late String _wordOfTheDay;

  static final WordleService _instance = WordleService._internal();
  factory WordleService() => _instance;
  WordleService._internal();

  String get wordOfTheDay => _wordOfTheDay;

  Future<void> init() async {
    _wordOfTheDay = await getWordOfTheDay();
  }

  /// if [wordDate] is null, get today's word else get word for that particular date.
  Future<String> getWordOfTheDay([DateTime? wordDate]) async {
    final wordlist = await getWordList;
    final date = wordDate ?? DateTime.now();
    final random = math.Random(int.parse(DateFormat('yyyyMMdd').format(date)));
    return wordlist[random.nextInt(wordlist.length)].trim().toUpperCase();
  }

  Future<List<String>> get getWordList async {
    var useCustomList =
        SharedPreferenceService().getBool(SharedPreferencesKeys.useCustomList);
    if (useCustomList != null && useCustomList) {
      Directory directory = await getApplicationDocumentsDirectory();
      try {
        File file = File(path.join(directory.path, 'custom_list.txt'));
        return await file.readAsLines();
      } on PathNotFoundException {
        // If files doesn't exist, save default word list to custom list and return that.
        final String data = await rootBundle.loadString('assets/word_list.txt');
        List<String> words = data.split('\n').map((e) => e.trim()).toList();

        File file = File('${directory.path}/custom_list.txt');
        file.writeAsString(words.join('\n'));
        return words;
      }
    } else {
      final String data = await rootBundle.loadString('assets/word_list.txt');
      return data.split('\n').map((e) => e.trim()).toList();
    }
  }

  Map<String, dynamic> _checkCharacter(
      String guessCharacter, String answer, int idx) {
    return {
      'char': guessCharacter,
      'scoring': {
        'in_word': answer.contains(guessCharacter),
        'correct_idx': guessCharacter == answer[idx]
      }
    };
  }

  Future<Map<String, dynamic>> checkGuessWord(String guessWord) async {
    if (guessWord == WordleService()._wordOfTheDay) {
      return {
        'guess': guessWord,
        'is_correct': true,
        'is_word_in_list': true,
      };
    }

    // Check if the word is in the word list
    List<String> wordList = await getWordList;
    if (!wordList.contains(guessWord.toLowerCase())) {
      return {
        'guess': guessWord,
        'is_correct': false,
        'is_word_in_list': false,
      };
    }

    // Check the word against the answer
    List<Map<String, dynamic>> guessResult = [];
    for (int idx = 0; idx < guessWord.length; idx++) {
      guessResult.add(_checkCharacter(guessWord[idx], _wordOfTheDay, idx));
    }
    return {
      'guess': guessWord,
      'is_correct': false,
      'is_word_in_list': true,
      'character_info': guessResult,
    };
  }
}
