import 'package:flutter/material.dart';
import 'package:red_owl/routes/game/widgets/shared.dart' show Letter;
import 'package:red_owl/config/shared.dart' show keyboardStatus;

/// Renders a single row of on-screen keyboard keys.
///
/// The full keyboard is split into three rows by [minIndex] / [maxIndex]
/// which slice the ordered [keyboardStatus] map:
/// - Row 1 (Q–P):  minIndex=0,  maxIndex=10
/// - Row 2 (A–L):  minIndex=11, maxIndex=19, addSpacer=true
/// - Row 3 (ENTER, Z–M, DELETE): minIndex=20, maxIndex=29
///
/// Keys outside the index range are emitted as zero-size [SizedBox] widgets
/// so the map iteration stays in sync with the original insertion order.
///
/// ENTER and DELETE keys are given a wider flex (8) so they stand out from
/// letter keys (flex 4).
class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    super.key,
    /// Index of the first key (inclusive) to render in this row.
    required this.minIndex,
    /// Index of the last key (inclusive) to render in this row.
    required this.maxIndex,
    /// Whether to add [Spacer] widgets on both sides to center the row.
    /// Used on row 2 which is one key shorter than row 1.
    this.addSpacer = false,
  });

  /// First key index (inclusive) to include in this row.
  final int minIndex;

  /// Last key index (inclusive) to include in this row.
  final int maxIndex;

  /// Adds [Spacer] on both sides to horizontally centre a shorter row.
  final bool addSpacer;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (addSpacer) const Spacer(),
        ...keyboardStatus.entries.map((e) {
          index++;
          if (index >= minIndex && index <= maxIndex) {
            switch (e.key) {
              case 'ENTER':
              case 'DELETE':
                // Action keys are twice as wide as letter keys.
                return Expanded(flex: 8, child: Letter(letter: e.key));
              default:
                return Expanded(flex: 4, child: Letter(letter: e.key));
            }
          }
          // Keys outside this row's range are invisible placeholders.
          return const SizedBox();
        }),
        if (addSpacer) const Spacer(),
      ],
    );
  }
}
