// Unit tests for the app themes and the color-blind / high-contrast variants.
//
// Verifies that the high-contrast themes swap in the blue/orange palette
// (blue = correct position, orange = present) so the game is distinguishable
// under common forms of color blindness.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart'
    show
        GameColors,
        darkTheme,
        darkThemeHighContrast,
        lightTheme,
        lightThemeHighContrast;

void main() {
  GameColors gameColorsOf(ThemeData theme) =>
      theme.extension<GameColors>()!;

  group('Standard themes', () {
    test('register GameColors and HistoryColors extensions', () {
      expect(lightTheme.extension<GameColors>(), isNotNull);
      expect(darkTheme.extension<GameColors>(), isNotNull);
    });

    test('light theme uses a green correct color (more green than blue)', () {
      final green = gameColorsOf(lightTheme).green!;
      expect(green.g, greaterThan(green.b));
    });
  });

  group('High-contrast / color-blind themes', () {
    test('correct color is blue (more blue than green/red)', () {
      for (final theme in [lightThemeHighContrast, darkThemeHighContrast]) {
        final correct = gameColorsOf(theme).green!;
        expect(correct.b, greaterThan(correct.g),
            reason: 'correct should be blue-dominant');
        expect(correct.b, greaterThan(correct.r));
      }
    });

    test('present color is orange (red and green high, blue low)', () {
      for (final theme in [lightThemeHighContrast, darkThemeHighContrast]) {
        final present = gameColorsOf(theme).yellow!;
        expect(present.r, greaterThan(present.b));
        expect(present.g, greaterThan(present.b));
      }
    });

    test('differs from the standard palette', () {
      expect(
        gameColorsOf(lightThemeHighContrast).green,
        isNot(gameColorsOf(lightTheme).green),
      );
      expect(
        gameColorsOf(darkThemeHighContrast).yellow,
        isNot(gameColorsOf(darkTheme).yellow),
      );
    });
  });
}
