import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show GameColors, HistoryColors;

/// Light theme used when dark mode is off.
///
/// Registers [GameColors] and [HistoryColors] theme extensions so that game
/// widgets can look up the correct tile and history row colors without
/// hard-coding them. The seed color is [Colors.red] to match the app icon.
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.light,
  ),
  brightness: Brightness.light,
  extensions: const <ThemeExtension<dynamic>>[
    GameColors(
      initial: Color.fromRGBO(211, 214, 218, 1),
      yellow: Color.fromRGBO(201, 180, 88, 1),
      green: Color.fromRGBO(106, 170, 100, 1),
      notInWord: Color.fromRGBO(120, 124, 126, 1),
      borderInactive: Color.fromRGBO(211, 214, 218, 1),
      borderActive: Color.fromRGBO(135, 138, 140, 1),
    ),
    HistoryColors(
      green: Color.fromRGBO(72, 199, 142, 1),
      red: Color.fromRGBO(255, 82, 113, 1),
      yellow: Color.fromRGBO(255, 193, 0, 1),
    )
  ],
);

/// Dark theme used when dark mode is on.
///
/// Uses the same [GameColors] / [HistoryColors] structure as [lightTheme]
/// but with muted, darker variants of each color so the interface remains
/// legible in low-light environments.
final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  extensions: const <ThemeExtension<dynamic>>[
    GameColors(
      initial: Color.fromRGBO(129, 131, 132, 1),
      yellow: Color.fromRGBO(181, 159, 59, 1),
      green: Color.fromRGBO(83, 141, 78, 1),
      notInWord: Color.fromRGBO(58, 58, 60, 1),
      borderInactive: Color.fromRGBO(58, 58, 60, 1),
      borderActive: Color.fromRGBO(86, 87, 88, 1),
    ),
    HistoryColors(
      green: Color.fromRGBO(0, 76, 48, 1),
      red: Color.fromRGBO(101, 10, 30, 1),
      yellow: Color.fromRGBO(180, 145, 0, 1),
    )
  ],
);

/// Light theme variant for the color-blind / high-contrast mode.
///
/// Replaces the green/yellow tile palette with the widely-recognised Wordle
/// high-contrast scheme — **blue** for a correct-position letter and
/// **orange** for a present-but-misplaced letter — which is distinguishable
/// under the most common forms of color blindness (deutan/protan). Borders and
/// the "not in word" grey are also darkened to raise overall contrast.
final lightThemeHighContrast = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.light,
  ),
  brightness: Brightness.light,
  extensions: const <ThemeExtension<dynamic>>[
    GameColors(
      initial: Color.fromRGBO(211, 214, 218, 1),
      // Orange = present (was yellow).
      yellow: Color.fromRGBO(228, 119, 38, 1),
      // Blue = correct position (was green).
      green: Color.fromRGBO(33, 115, 196, 1),
      notInWord: Color.fromRGBO(90, 94, 96, 1),
      borderInactive: Color.fromRGBO(150, 153, 157, 1),
      borderActive: Color.fromRGBO(80, 83, 85, 1),
    ),
    HistoryColors(
      // Won = blue, incomplete = orange, lost stays a distinct red/pink.
      green: Color.fromRGBO(33, 115, 196, 1),
      red: Color.fromRGBO(255, 82, 113, 1),
      yellow: Color.fromRGBO(228, 119, 38, 1),
    )
  ],
);

/// Dark theme variant for the color-blind / high-contrast mode.
///
/// Same blue/orange substitution as [lightThemeHighContrast], tuned for a
/// dark background.
final darkThemeHighContrast = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  extensions: const <ThemeExtension<dynamic>>[
    GameColors(
      initial: Color.fromRGBO(129, 131, 132, 1),
      yellow: Color.fromRGBO(231, 124, 47, 1),
      green: Color.fromRGBO(54, 130, 207, 1),
      notInWord: Color.fromRGBO(58, 58, 60, 1),
      borderInactive: Color.fromRGBO(100, 102, 104, 1),
      borderActive: Color.fromRGBO(140, 142, 144, 1),
    ),
    HistoryColors(
      green: Color.fromRGBO(0, 60, 120, 1),
      red: Color.fromRGBO(101, 10, 30, 1),
      yellow: Color.fromRGBO(160, 80, 0, 1),
    )
  ],
);
