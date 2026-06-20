import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'
    show
        KeyDownEvent,
        KeyEvent,
        LogicalKeyboardKey,
        ServicesBinding;
import 'package:red_owl/config/shared.dart'
    show GameColors, LetterStatus, animationTiming, keyboardStatus;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/routes/game/widgets/shared.dart';
import 'package:red_owl/util/shared.dart' show Localization, dateToString;
import 'package:red_owl/widgets/shared.dart' show HelpIconButton, appBar;

/// The main Wordle gameplay screen.
///
/// Layout:
/// - **AppBar**: shows today's date, a help button (opens instructions dialog),
///   and a settings gear icon.
/// - **Grid** (flex 5): a 5×6 [GridView] of [Tile] widgets. Each tile can be
///   animated with [PopInAnimation], [BounceAnimation], and [ShakeAnimation].
/// - **Keyboard** (flex 2): three [KeyboardRow] rows rendered in a column.
///
/// Hardware keyboard input is captured via [ServicesBinding.keyboard] so that
/// desktop and web users can type letters, ENTER, and BACKSPACE directly.
/// The keyboard status map is reset to [LetterStatus.initial] on every page
/// open so stale colors from a previous session don't bleed through.
class WordlePage extends ConsumerStatefulWidget {
  const WordlePage({super.key});

  @override
  ConsumerState<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends ConsumerState<WordlePage> {
  /// Handler registered with [ServicesBinding.keyboard] to intercept physical
  /// key events so desktop and web users can play with a hardware keyboard.
  ///
  /// Maps `Enter`/`numpad Enter` → `ENTER`, `Backspace` → `DELETE`, and any
  /// single `A`–`Z` character → the corresponding letter, forwarding each to
  /// [Grid.onKeyboardPressed]. Only [KeyDownEvent]s are handled so a held key
  /// doesn't insert repeated letters. Input is ignored once the game is over,
  /// mirroring the [IgnorePointer] on the on-screen keyboard.
  ///
  /// Returns `true` when an event was consumed so it doesn't also, for example,
  /// activate a focused button; otherwise `false` to let it propagate.
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
    // Register hardware keyboard handler for desktop/web support.
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    // Reset all key colors to their default state at the start of each session.
    keyboardStatus.updateAll((key, val) => LetterStatus.initial);
  }

  @override
  void dispose() {
    super.dispose();
    // Always deregister to avoid memory leaks and stale callbacks.
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        // Display the current date (ISO format) as the page title.
        title: dateToString(DateTime.now()),
        showSettingIcon: true,
        widgets: [
          HelpIconButton(
            title: context.l10n.howToPlay,
            body: [
              Text(context.l10n.sixTries),
              const SizedBox(height: 10),
              Text(context.l10n.helpLine0),
              const SizedBox(height: 10),
              const Divider(),
              // Example word "STARE" with color-coded tiles.
              Text('${context.l10n.example}:'),
              const SizedBox(height: 5),
              Row(
                children: [
                  HelpTile(
                      background:
                          Theme.of(context).extension<GameColors>()!.notInWord!,
                      letter: 'S'),
                  const SizedBox(width: 5),
                  HelpTile(
                      background:
                          Theme.of(context).extension<GameColors>()!.notInWord!,
                      letter: 'T'),
                  const SizedBox(width: 5),
                  HelpTile(
                      background:
                          Theme.of(context).extension<GameColors>()!.green!,
                      letter: 'A'),
                  const SizedBox(width: 5),
                  HelpTile(
                      background:
                          Theme.of(context).extension<GameColors>()!.yellow!,
                      letter: 'R'),
                  const SizedBox(width: 5),
                  HelpTile(
                      background:
                          Theme.of(context).extension<GameColors>()!.notInWord!,
                      letter: 'E'),
                ],
              ),
              // Explanation for each letter color using RichText highlights.
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: 'A',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    TextSpan(
                      text: ' ${context.l10n.helpLine1}.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: 'R',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    TextSpan(
                      text: ' ${context.l10n.helpLine2}.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: 'S',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: 'T',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: 'E',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    TextSpan(
                      text: ' ${context.l10n.helpLine3}.',
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
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
