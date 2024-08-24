import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show CustomColors;
import 'package:red_owl/riverpod/shared.dart';

class Letter extends ConsumerWidget {
  const Letter({super.key, required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            color: Theme.of(context).extension<CustomColors>()?.initial,
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
