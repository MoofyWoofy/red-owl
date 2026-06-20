// Widget tests for the shared screen-reader label helper used by the grid
// tiles and on-screen keyboard.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;
import 'package:red_owl/routes/game/widgets/shared.dart'
    show letterStatusLabel;

import '../../helpers/test_helpers.dart';

void main() {
  /// Pumps a Builder and returns the label produced by [letterStatusLabel] for
  /// the given [letter]/[status] under a localized context.
  Future<String> labelFor(
    WidgetTester tester,
    String letter,
    LetterStatus? status,
  ) async {
    late String result;
    await tester.pumpWidget(
      makeTestApp(
        child: Builder(
          builder: (context) {
            result = letterStatusLabel(context, letter, status);
            return const SizedBox();
          },
        ),
      ),
    );
    return result;
  }

  group('letterStatusLabel', () {
    testWidgets('returns the bare letter for an unevaluated tile',
        (tester) async {
      expect(await labelFor(tester, 'A', LetterStatus.initial), 'A');
      expect(await labelFor(tester, 'A', null), 'A');
    });

    testWidgets('appends the status word for evaluated letters',
        (tester) async {
      expect(await labelFor(tester, 'A', LetterStatus.green), 'A, correct');
      expect(await labelFor(tester, 'B', LetterStatus.yellow), 'B, present');
      expect(await labelFor(tester, 'C', LetterStatus.notInWord), 'C, absent');
    });
  });
}
