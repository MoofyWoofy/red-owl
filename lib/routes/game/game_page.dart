import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show GameColors;
import 'package:red_owl/routes/game/widgets/shared.dart'
    show GameBoard, GameStatusAnnouncer, HelpTile;
import 'package:red_owl/util/shared.dart' show Localization;
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
class WordlePage extends StatelessWidget {
  const WordlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        // Display the current date in the user's regional format as the title.
        title: MaterialLocalizations.of(context).formatCompactDate(DateTime.now()),
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
      body: const Column(
        children: [
          // Invisible live region that announces the win/loss outcome to
          // screen readers when the game ends.
          GameStatusAnnouncer(),
          // The shared grid + keyboard surface, bound to the daily notifier.
          Expanded(child: GameBoard()),
        ],
      ),
    );
  }
}
