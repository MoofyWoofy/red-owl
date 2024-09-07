import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyRepeatEvent, KeyUpEvent, ServicesBinding;
import 'package:intl/intl.dart';
import 'package:red_owl/config/shared.dart'
    show LetterStatus, animationTiming, keyboardStatus;
import 'package:red_owl/riverpod/shared.dart' show gridProvider;
import 'package:red_owl/routes/game/widgets/shared.dart'
    show BounceAnimation, KeyboardRow, PopInAnimation, ShakeAnimation, Tile;
import 'package:red_owl/widgets/shared.dart' show appBar;

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
        title: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        showSettingIcon: true,
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
