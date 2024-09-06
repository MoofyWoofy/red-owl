import 'dart:io';
import 'dart:math' as math show Random;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

class WordleService {
  /// Word of the day
  late final String _wordOfTheDay;

  // ? WTF is this magic
  static final WordleService _instance = WordleService._internal();
  factory WordleService() => _instance;
  WordleService._internal();

  Future<void> init() async {
    _wordOfTheDay = await _getWordOfTheDay();
    print('wordle ans: $_wordOfTheDay');
  }

  Future<String> _getWordOfTheDay() async {
    final wordlist = await _getWordList();
    final random =
        math.Random(int.parse(DateFormat('yyyyMMdd').format(DateTime.now())));
    return wordlist[random.nextInt(wordlist.length)].trim().toUpperCase();
  }

  Future<List<String>> _getWordList() async {
    final String data = await rootBundle.loadString('assets/word_list.txt');
    return data.split('\n').map((e) => e.trim()).toList();
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
    //TODO: valid and then remove toUpperCase() and toLowerCase().

    if (guessWord == WordleService()._wordOfTheDay) {
      return {
        'guess': guessWord,
        'is_correct': true,
        'is_word_in_list': true,
      };
    }

    // Check if the word is in the word list
    List<String> wordList = await _getWordList();
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
