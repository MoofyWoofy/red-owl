import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show GameColors, HistoryColors;

void main() {
  group('GameColors', () {
    const colors = GameColors(
      initial: Color(0xFF111111),
      green: Color(0xFF00FF00),
      yellow: Color(0xFFFFFF00),
      notInWord: Color(0xFF888888),
      borderInactive: Color(0xFFAAAAAA),
      borderActive: Color(0xFFBBBBBB),
    );

    test('stores all six color fields', () {
      expect(colors.initial, const Color(0xFF111111));
      expect(colors.green, const Color(0xFF00FF00));
      expect(colors.yellow, const Color(0xFFFFFF00));
      expect(colors.notInWord, const Color(0xFF888888));
      expect(colors.borderInactive, const Color(0xFFAAAAAA));
      expect(colors.borderActive, const Color(0xFFBBBBBB));
    });

    test('copyWith replaces only specified fields', () {
      final updated = colors.copyWith(green: const Color(0xFF00DD00));
      expect(updated.green, const Color(0xFF00DD00));
      expect(updated.initial, colors.initial);
      expect(updated.yellow, colors.yellow);
    });

    test('lerp returns this when other is not GameColors', () {
      final result = colors.lerp(null, 0.5);
      expect(result.initial, colors.initial);
    });

    test('lerp interpolates between two GameColors at t=0.5', () {
      const other = GameColors(
        initial: Color(0xFF222222),
        green: Color(0xFF00EE00),
        yellow: Color(0xFFEEEE00),
        notInWord: Color(0xFF999999),
        borderInactive: Color(0xFFCCCCCC),
        borderActive: Color(0xFFDDDDDD),
      );
      final result = colors.lerp(other, 0.5);
      expect(result.initial, isNotNull);
      expect(result.green, isNotNull);
    });

    test('lerp at t=0 returns original colors', () {
      const other = GameColors(
        initial: Color(0xFFFFFFFF),
        green: Color(0xFFFFFFFF),
        yellow: Color(0xFFFFFFFF),
        notInWord: Color(0xFFFFFFFF),
        borderInactive: Color(0xFFFFFFFF),
        borderActive: Color(0xFFFFFFFF),
      );
      final result = colors.lerp(other, 0.0);
      expect(result.initial, colors.initial);
    });

    test('lerp at t=1 returns other colors', () {
      const other = GameColors(
        initial: Color(0xFFFFFFFF),
        green: Color(0xFFFFFFFF),
        yellow: Color(0xFFFFFFFF),
        notInWord: Color(0xFFFFFFFF),
        borderInactive: Color(0xFFFFFFFF),
        borderActive: Color(0xFFFFFFFF),
      );
      final result = colors.lerp(other, 1.0);
      expect(result.initial, other.initial);
    });
  });

  group('HistoryColors', () {
    const colors = HistoryColors(
      green: Color(0xFF00FF00),
      yellow: Color(0xFFFFFF00),
      red: Color(0xFFFF0000),
    );

    test('stores all three color fields', () {
      expect(colors.green, const Color(0xFF00FF00));
      expect(colors.yellow, const Color(0xFFFFFF00));
      expect(colors.red, const Color(0xFFFF0000));
    });

    test('copyWith replaces only specified fields', () {
      final updated = colors.copyWith(red: const Color(0xFFEE0000));
      expect(updated.red, const Color(0xFFEE0000));
      expect(updated.green, colors.green);
      expect(updated.yellow, colors.yellow);
    });

    test('lerp returns this when other is not HistoryColors', () {
      final result = colors.lerp(null, 0.5);
      expect(result.green, colors.green);
    });

    test('lerp interpolates at t=1', () {
      const other = HistoryColors(
        green: Color(0xFF00EE00),
        yellow: Color(0xFFEEEE00),
        red: Color(0xFFEE0000),
      );
      final result = colors.lerp(other, 1.0);
      expect(result.green, other.green);
      expect(result.red, other.red);
    });
  });
}
