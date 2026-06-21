import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyEvent, LogicalKeyboardKey, ServicesBinding;
import 'package:red_owl/config/shared.dart'
    show LetterStatus, animationTiming, keyboardStatus;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/routes/game/widgets/shared.dart'
    show BounceAnimation, KeyboardRow, PopInAnimation, ShakeAnimation, Tile;

/// The interactive game surface: the 5×6 tile grid and the on-screen keyboard.
///
/// Reads and drives whichever notifier is bound to `gridProvider` in the
/// current scope, so it serves both the daily game and the practice game (the
/// latter overrides `gridProvider` with a [PracticeGrid] via a `ProviderScope`).
///
/// Hardware keyboard input is captured via [ServicesBinding.keyboard] so that
/// desktop and web users can type letters, ENTER, and BACKSPACE directly. The
/// keyboard status map is reset on mount so stale colours from a previous
/// session don't bleed through.
class GameBoard extends ConsumerStatefulWidget {
  const GameBoard({super.key});

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends ConsumerState<GameBoard> {
  /// Handler registered with [ServicesBinding.keyboard] to intercept physical
  /// key events so desktop and web users can play with a hardware keyboard.
  ///
  /// Maps `Enter`/`numpad Enter` → `ENTER`, `Backspace` → `DELETE`, and any
  /// single `A`–`Z` character → the corresponding letter. Only [KeyDownEvent]s
  /// are handled so a held key doesn't insert repeated letters. Input is
  /// ignored once the game is over, mirroring the on-screen keyboard.
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (ref.read(gridProvider).isGameOver) return false;

    final notifier = ref.read(gridProvider.notifier);
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      notifier.onKeyboardPressed(key: 'ENTER', context: context);
      return true;
    }
    if (key == LogicalKeyboardKey.backspace) {
      notifier.onKeyboardPressed(key: 'DELETE', context: context);
      return true;
    }

    // A single printable A–Z character (ignores digits, symbols, shortcuts).
    final character = event.character;
    if (character != null && character.length == 1) {
      final upper = character.toUpperCase();
      final code = upper.codeUnitAt(0);
      if (code >= 0x41 && code <= 0x5A) {
        notifier.onKeyboardPressed(key: upper, context: context);
        return true;
      }
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    // Reset all key colors to their default state at the start of each session.
    keyboardStatus.updateAll((key, val) => LetterStatus.initial);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The board is inherently left-to-right (5-letter Latin words and a QWERTY
    // keyboard), so pin it to LTR even when the rest of the UI is RTL.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
      children: [
        // ── Tile grid (5 columns × 6 rows = 30 cells) ───────────────────
        Expanded(
          flex: 5,
          child: GridView.builder(
              itemCount: 30,
              padding: const EdgeInsets.all(40),
              // Non-scrollable: the entire grid always fits in the viewport.
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                bool animatePopInEffect = false,
                    animateBounceEffect = false,
                    animateShakeEffect = false;
                final grid = ref.watch(gridProvider);
                // gridIndex is the flat index of the most recently typed tile.
                int gridIndex = (grid.row * 5 + grid.column) - 1;
                int bounceDelay = animationTiming.bounce.initialDelay!;
                // All tile indexes in the current (active) row.
                var currentTilesRowIndexes =
                    List.generate(5, (i) => (grid.row * 5) + i);

                // Pop-in: only the tile that was just typed (not on ENTER/DELETE).
                if (gridIndex == index &&
                    !grid.isEnterOrDeletePressed &&
                    !grid.notEnoughCharacters) {
                  animatePopInEffect = true;
                }
                // Bounce: all tiles in the winning row, staggered left-to-right.
                if (grid.isGameWon) {
                  if (currentTilesRowIndexes.contains(index)) {
                    animateBounceEffect = true;
                    bounceDelay +=
                        animationTiming.bounce.intervalDelay! * (index % 5);
                  }
                }
                // Shake: all tiles in the current row on invalid submission.
                if (grid.notEnoughCharacters) {
                  if (currentTilesRowIndexes.contains(index)) {
                    animateShakeEffect = true;
                  }
                }

                return ShakeAnimation(
                  runAnimation: animateShakeEffect,
                  child: BounceAnimation(
                    runAnimation: animateBounceEffect,
                    delay: bounceDelay,
                    child: PopInAnimation(
                      runAnimation: animatePopInEffect,
                      child: Tile(
                        index: index,
                        hasFlipAnimationPlayed: index < (grid.tiles.length)
                            ? grid.tiles[index].hasFlipAnimationPlayed
                            : false,
                      ),
                    ),
                  ),
                );
              }),
        ),
        // ── On-screen keyboard ──────────────────────────────────────────
        const Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                // Row 1: Q W E R T Y U I O P
                KeyboardRow(minIndex: 0, maxIndex: 10),
                SizedBox(height: 8),
                // Row 2: A S D F G H J K L (centered with spacers)
                KeyboardRow(minIndex: 11, maxIndex: 19, addSpacer: true),
                SizedBox(height: 8),
                // Row 3: ENTER Z X C V B N M DELETE
                KeyboardRow(minIndex: 20, maxIndex: 29),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}
