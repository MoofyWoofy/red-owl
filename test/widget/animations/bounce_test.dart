// Widget tests for the winning-row bounce animation.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/routes/game/widgets/shared.dart' show BounceAnimation;

/// Host that can turn the trigger off and on again, as happens when a second
/// practice game is won after "New word" resets the board.
class _Host extends StatefulWidget {
  const _Host();
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  bool run = false;

  /// Flips the trigger from outside the widget (calling `setState` directly
  /// from a test would be reaching into a protected member).
  void setRun(bool value) => setState(() => run = value);
  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: BounceAnimation(
          runAnimation: run,
          delay: 0,
          child: const SizedBox(width: 10, height: 10),
        ),
      );
}

void main() {
  /// The tile's current slide offset.
  Offset offsetOf(WidgetTester tester) => tester
      .widget<SlideTransition>(find.byType(SlideTransition))
      .position
      .value;

  /// Triggers a win and samples the offset partway through the bounce.
  Future<Offset> playAndSampleMidBounce(
      WidgetTester tester, _HostState state) async {
    state.setRun(true);
    await tester.pump();
    // Fire the (zero-length) stagger delay, then advance into the bounce.
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 250));
    final offset = offsetOf(tester);
    await tester.pumpAndSettle();
    return offset;
  }

  testWidgets('bounces on the first win', (tester) async {
    await tester.pumpWidget(const _Host());
    final state = tester.state<_HostState>(find.byType(_Host));

    expect(offsetOf(tester), Offset.zero);
    expect(await playAndSampleMidBounce(tester, state), isNot(Offset.zero));
  });

  // Regression: the controller was driven with a plain `forward()` and never
  // reset, so it stayed at 1.0 after the first win and every later win
  // completed instantly with no visible bounce.
  testWidgets('bounces again on a second win', (tester) async {
    await tester.pumpWidget(const _Host());
    final state = tester.state<_HostState>(find.byType(_Host));

    final first = await playAndSampleMidBounce(tester, state);

    // Board reset, then a second win.
    state.setRun(false);
    await tester.pump();
    final second = await playAndSampleMidBounce(tester, state);

    expect(first, isNot(Offset.zero));
    expect(second, isNot(Offset.zero),
        reason: 'the second win did not move the tile, so the bounce did not '
            'replay');
    expect(second, first);
  });
}
