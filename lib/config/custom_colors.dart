import 'package:flutter/material.dart' show Color, ThemeExtension, immutable;

/// Theme extension that carries the six game-specific colors used on the
/// tile grid and the on-screen keyboard.
///
/// Both [lightTheme] and [darkTheme] register their own [GameColors] instance
/// inside `ThemeData.extensions`. Widgets retrieve them via
/// `Theme.of(context).extension<GameColors>()!`.
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

  /// Background color for a letter key / tile that has not yet been evaluated.
  final Color? initial;

  /// Background used when a letter is in the correct position in the answer.
  final Color? green;

  /// Background used when a letter exists in the answer but is misplaced.
  final Color? yellow;

  /// Background used when a letter does not appear in the answer at all.
  final Color? notInWord;

  /// Border color for an empty tile that is not the current active position.
  final Color? borderInactive;

  /// Border color for the tile at the current cursor position (letter just typed).
  final Color? borderActive;

  /// Returns a new [GameColors] with the specified fields replaced.
  /// Fields not provided fall back to the existing values.
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

  /// Linearly interpolates between this and [other] at fraction [t].
  /// Returns `this` unchanged if [other] is not a [GameColors] instance
  /// (required by the [ThemeExtension] contract).
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

/// Theme extension that carries the three history-row background colors
/// shown on the Stats page.
///
/// Each row in the history list is colored to indicate the game outcome.
class HistoryColors extends ThemeExtension<HistoryColors> {
  const HistoryColors({
    required this.green,
    required this.yellow,
    required this.red,
  });

  /// Background used when the player successfully guessed the word.
  final Color? green;

  /// Background used when a game was abandoned mid-play (incomplete).
  final Color? yellow;

  /// Background used when the player ran out of guesses without solving it.
  final Color? red;

  /// Returns a new [HistoryColors] with the specified fields replaced.
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

  /// Linearly interpolates between this and [other] at fraction [t].
  /// Returns `this` unchanged if [other] is not a [HistoryColors] instance.
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
