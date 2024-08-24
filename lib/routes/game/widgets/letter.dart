import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show CustomColors, LetterStatus;
import 'package:red_owl/riverpod/shared.dart';

class Letter extends ConsumerWidget {
  const Letter({super.key, required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? color;
    switch (ref.watch(gridProvider).keyboardStatus[letter]) {
      case LetterStatus.initial:
        color = Theme.of(context).extension<CustomColors>()?.initial;
        break;
      case LetterStatus.green:
        color = Theme.of(context).extension<CustomColors>()?.green;
        break;
      case LetterStatus.yellow:
        color = Theme.of(context).extension<CustomColors>()?.yellow;
        break;
      case LetterStatus.notInWord:
      case null:
        color = Theme.of(context).extension<CustomColors>()?.notInWord;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.black38,
        onTap: () {
          ref.read(gridProvider.notifier).onKeyboardPressed(key: letter);
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: letter != "DELETE"
              ? Text(
                  letter,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                )
              : const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    Icons.backspace,
                  ),
                ),
        ),
      ),
    );
  }
}
