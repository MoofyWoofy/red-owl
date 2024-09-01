import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show CustomColors, LetterStatus;
import 'package:red_owl/riverpod/shared.dart';

class Letter extends ConsumerWidget {
  const Letter({super.key, required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? backgroundColor;
    Color? textColor;
    var grid = ref.watch(gridProvider);
    switch (grid.keyboardStatus[letter]) {
      case LetterStatus.initial:
        backgroundColor = Theme.of(context).extension<CustomColors>()?.initial;
        break;
      case LetterStatus.green:
        backgroundColor = Theme.of(context).extension<CustomColors>()?.green;
        textColor = Colors.white;
        break;
      case LetterStatus.yellow:
        backgroundColor = Theme.of(context).extension<CustomColors>()?.yellow;
        textColor = Colors.white;
        break;
      case LetterStatus.notInWord:
      case null:
        backgroundColor =
            Theme.of(context).extension<CustomColors>()?.notInWord;
        textColor = Colors.white;
        break;
    }

    return IgnorePointer(
      ignoring: grid.isGameOver,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.black38,
          onTap: () {
            ref.read(gridProvider.notifier).onKeyboardPressed(
                  key: letter,
                  context: context,
                );
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: letter != "DELETE"
                ? Text(
                    letter,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  )
                : const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.backspace_outlined,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
