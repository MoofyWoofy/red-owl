import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;
import 'package:red_owl/riverpod/shared.dart' show gridProvider, hintProvider;
import 'package:red_owl/util/shared.dart' show Localization, WordleService, showSnackBar;

/// App-bar action that reveals one letter of today's word, once per day.
///
/// Picks the first position the player has not yet turned green and reveals the
/// answer's letter there via a snack bar (e.g. "Hint: letter 3 is A"). After
/// use the icon dims and further taps explain the hint is spent until tomorrow.
/// Availability is tracked by [hintProvider], which resets on day rollover.
class HintButton extends ConsumerWidget {
  const HintButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(hintProvider);

    return IconButton(
      icon: const Icon(Icons.lightbulb_outline),
      tooltip: context.l10n.hint,
      // Dim the icon once the hint has been spent for the day.
      color: available ? null : Theme.of(context).disabledColor,
      onPressed: () {
        if (!available) {
          showSnackBar(context, context.l10n.hintAlreadyUsed, 3);
          return;
        }

        final position = _firstUnsolvedPosition(ref);
        final answer = WordleService().wordOfTheDay;
        showSnackBar(
          context,
          context.l10n.hintReveal(position + 1, answer[position]),
          3,
        );
        ref.read(hintProvider.notifier).useHint();
      },
    );
  }

  /// Returns the first 0-based position the player has not yet guessed green,
  /// or 0 if every position is already solved.
  int _firstUnsolvedPosition(WidgetRef ref) {
    final grid = ref.read(gridProvider);
    final solved = <int>{};
    for (var i = 0; i < grid.tiles.length; i++) {
      if (grid.tiles[i].status == LetterStatus.green) {
        solved.add(i % 5);
      }
    }
    for (var p = 0; p < 5; p++) {
      if (!solved.contains(p)) return p;
    }
    return 0;
  }
}
