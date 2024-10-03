import 'package:flutter/material.dart' show Color, ThemeExtension, immutable;

@immutable
class GameColors extends ThemeExtension<GameColors> {
  const GameColors({
    required this.initial,
    required this.green,
    required this.yellow,
    required this.notInWord,
    required this.borderInactive,
    required this.borderActive,
  });

  /// Initial color for keyboard
  final Color? initial;

  /// Correct letter & position
  final Color? green;

  /// Correct letter but wrong position
  final Color? yellow;

  /// Letter is not in word
  final Color? notInWord;

  /// Border colors for tile
  final Color? borderInactive;

  /// Border colors for tile
  final Color? borderActive;

  @override
  GameColors copyWith({
    Color? initial,
    Color? green,
    Color? yellow,
    Color? notInWord,
    Color? borderInactive,
    Color? borderActive,
  }) {
    return GameColors(
      initial: initial ?? this.initial,
      green: green ?? this.green,
      yellow: yellow ?? this.yellow,
      notInWord: notInWord ?? this.notInWord,
      borderInactive: borderInactive ?? this.borderInactive,
      borderActive: borderActive ?? this.borderActive,
    );
  }

  @override
  GameColors lerp(GameColors? other, double t) {
    if (other is! GameColors) {
      return this;
    }
    return GameColors(
      initial: Color.lerp(initial, other.initial, t),
      green: Color.lerp(green, other.green, t),
      yellow: Color.lerp(yellow, other.yellow, t),
      notInWord: Color.lerp(notInWord, other.notInWord, t),
      borderInactive: Color.lerp(borderInactive, other.borderInactive, t),
      borderActive: Color.lerp(borderActive, other.borderActive, t),
    );
  }
}

class HistoryColors extends ThemeExtension<HistoryColors> {
  const HistoryColors({
    required this.green,
    required this.yellow,
    required this.red,
  });

  /// When user guessed word correctly
  final Color? green;

  /// When game is incomplete
  final Color? yellow;

  /// When user did not guess word correctly
  final Color? red;

  @override
  HistoryColors copyWith({
    Color? green,
    Color? yellow,
    Color? red,
  }) {
    return HistoryColors(
      green: green ?? this.green,
      yellow: yellow ?? this.yellow,
      red: red ?? this.red,
    );
  }

  @override
  HistoryColors lerp(HistoryColors? other, double t) {
    if (other is! HistoryColors) {
      return this;
    }
    return HistoryColors(
      green: Color.lerp(green, other.green, t),
      yellow: Color.lerp(yellow, other.yellow, t),
      red: Color.lerp(red, other.red, t),
    );
  }
}
