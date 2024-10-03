import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyRepeatEvent, KeyUpEvent, ServicesBinding;
import 'package:red_owl/config/shared.dart'
    show GameColors, LetterStatus, animationTiming, keyboardStatus;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/routes/game/widgets/shared.dart';
import 'package:red_owl/util/shared.dart' show dateToString;
import 'package:red_owl/widgets/shared.dart' show HelpIconButton, appBar;

class WordlePage extends ConsumerStatefulWidget {
  const WordlePage({super.key, required this.gameType});
  final String gameType;

  @override
  ConsumerState<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends ConsumerState<WordlePage> {
  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      // print("Key down: $key");
    } else if (event is KeyUpEvent) {
      // print("Key up: $key");
    } else if (event is KeyRepeatEvent) {
      // print("Key repeat: $key");
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    keyboardStatus.updateAll((key, val) => LetterStatus.initial);
  }

  @override
  void dispose() {
    super.dispose();
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: dateToString(DateTime.now()),
        showSettingIcon: true,
        widgets: [
          HelpIconButton(
            title: "HOW TO PLAY",
            body: [
              const Text('You have 6 tries to guess the word.'),
              const SizedBox(height: 10),
              const Text(
                  'The color of the letters will change to show how if they are correct.'),
              const SizedBox(height: 10),
              const Divider(),
              const Text('Example:'),
              const SizedBox(height: 5),
              Row(
                children: [
                  HelpTile(
                      background: Theme.of(context)
                          .extension<GameColors>()!
                          .notInWord!,
                      letter: 'S'),
                  const SizedBox(width: 5),
                  HelpTile(
                      background: Theme.of(context)
                          .extension<GameColors>()!
                          .notInWord!,
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
                      background: Theme.of(context)
                          .extension<GameColors>()!
                          .notInWord!,
                      letter: 'E'),
                ],
              ),
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
                    const TextSpan(
                      text:
                          ' is green, because it is in the word and in the correct spot.',
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
                    const TextSpan(
                      text:
                          ' is yellow, because it is in the word but in the wrong spot.',
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
                    const TextSpan(
                      text: ' are gray, because they are not in the word.',
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
          Expanded(
            flex: 5,
            child: GridView.builder(
                itemCount: 30,
                padding: const EdgeInsets.all(40),
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
                  var grid = ref.watch(gridProvider);
                  int gridIndex = (grid.row * 5 + grid.column) - 1;
                  int bounceDelay = animationTiming.bounce.initialDelay!;
                  var currentTilesRowIndexes =
                      List.generate(5, (i) => (grid.row * 5) + i);
                  if (gridIndex == index &&
                      !grid.isEnterOrDeletePressed &&
                      !grid.notEnoughCharacters) {
                    animatePopInEffect = true;
                  }
                  if (grid.isGameWon) {
                    if (currentTilesRowIndexes.contains(index)) {
                      animateBounceEffect = true;
                      bounceDelay +=
                          animationTiming.bounce.intervalDelay! * (index % 5);
                    }
                  }
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
          const Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  KeyboardRow(minIndex: 0, maxIndex: 10),
                  SizedBox(height: 8),
                  KeyboardRow(minIndex: 11, maxIndex: 19, addSpacer: true),
                  SizedBox(height: 8),
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
