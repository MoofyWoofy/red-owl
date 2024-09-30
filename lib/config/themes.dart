import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show CustomColors;

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.light,
  ),
  brightness: Brightness.light,
  extensions: const <ThemeExtension<dynamic>>[
    CustomColors(
      initial: Color.fromRGBO(211, 214, 218, 1),
      yellow: Color.fromRGBO(201, 180, 88, 1),
      green: Color.fromRGBO(106, 170, 100, 1),
      notInWord: Color.fromRGBO(120, 124, 126, 1),
      borderInactive: Color.fromRGBO(211, 214, 218, 1),
      borderActive: Color.fromRGBO(135, 138, 140, 1),
      historyGreen: Color.fromRGBO(72, 199, 142, 1),
      historyRed: Color.fromRGBO(255, 82, 113, 1),
      historyYellow: Color.fromRGBO(255, 193, 0, 1),
    ),
  ],
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  extensions: const <ThemeExtension<dynamic>>[
    CustomColors(
      initial: Color.fromRGBO(129, 131, 132, 1),
      yellow: Color.fromRGBO(181, 159, 59, 1),
      green: Color.fromRGBO(83, 141, 78, 1),
      notInWord: Color.fromRGBO(58, 58, 60, 1),
      borderInactive: Color.fromRGBO(58, 58, 60, 1),
      borderActive: Color.fromRGBO(86, 87, 88, 1),
      historyGreen: Color.fromRGBO(0, 76, 48, 1),
      historyRed: Color.fromRGBO(101, 10, 30, 1),
      historyYellow: Color.fromRGBO(180, 145, 0, 1),
    ),
  ],
);
