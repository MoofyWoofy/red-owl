import 'package:flutter/material.dart' show Color, ThemeExtension, immutable;

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.initial,
    required this.green,
    required this.yellow,
    required this.notInWord,
    required this.borderInactive,
    required this.borderActive,
    required this.historyGreen,
    required this.historyRed,
    required this.historyYellow,
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

  final Color? historyGreen;
  final Color? historyRed;
  final Color? historyYellow;

  @override
  CustomColors copyWith({
    Color? initial,
    Color? green,
    Color? yellow,
    Color? notInWord,
    Color? borderInactive,
    Color? borderActive,
    Color? historyGreen,
    Color? historyRed,
    Color? historyYellow,
  }) {
    return CustomColors(
      initial: initial ?? this.initial,
      green: green ?? this.green,
      yellow: yellow ?? this.yellow,
      notInWord: notInWord ?? this.notInWord,
      borderInactive: borderInactive ?? this.borderInactive,
      borderActive: borderActive ?? this.borderActive,
      historyGreen: historyGreen ?? this.historyGreen,
      historyRed: historyRed ?? this.historyRed,
      historyYellow: historyYellow ?? this.historyYellow,
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      initial: Color.lerp(initial, other.initial, t),
      green: Color.lerp(green, other.green, t),
      yellow: Color.lerp(yellow, other.yellow, t),
      notInWord: Color.lerp(notInWord, other.notInWord, t),
      borderInactive: Color.lerp(borderInactive, other.borderInactive, t),
      borderActive: Color.lerp(borderActive, other.borderActive, t),
      historyGreen: Color.lerp(historyGreen, other.historyGreen, t),
      historyRed: Color.lerp(historyRed, other.historyGreen, t),
      historyYellow: Color.lerp(historyYellow, other.historyGreen, t),
    );
  }
}
