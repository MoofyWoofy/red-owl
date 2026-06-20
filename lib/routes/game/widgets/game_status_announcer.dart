import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/util/shared.dart' show Localization, WordleService;

/// An invisible accessibility live region that announces the game outcome.
///
/// Watches the grid and, once the game is over, exposes a localized win/loss
/// message as a [Semantics] `liveRegion`. Screen readers (TalkBack/VoiceOver)
/// speak the message automatically when it appears, so blind players learn the
/// result, which is otherwise only conveyed by tile colours and a transient
/// snack bar. While a game is in progress the region is empty and silent.
class GameStatusAnnouncer extends ConsumerWidget {
  const GameStatusAnnouncer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grid = ref.watch(gridProvider);

    String message = '';
    if (grid.isGameOver) {
      message = grid.isGameWon
          // On a win the board row was not advanced, so the 0-based row index
          // plus one is the number of guesses taken.
          ? context.l10n.a11yWinAnnouncement(grid.row + 1)
          : context.l10n
              .a11yLossAnnouncement(WordleService().wordOfTheDay.toUpperCase());
    }

    return Semantics(
      liveRegion: true,
      label: message,
      // Zero-size: this node exists only to carry the announcement.
      child: const SizedBox.shrink(),
    );
  }
}
