import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show CustomColors, LetterStatus;
import 'package:red_owl/riverpod/shared.dart';

class Tile extends ConsumerWidget {
  const Tile({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? backgroundColor, textColor;
    Color borderColor =
        Theme.of(context).extension<CustomColors>()!.borderInactive!;

    if (index < ref.watch(gridProvider).tiles.length) {
      switch (ref.watch(gridProvider).tiles[index].status) {
        case LetterStatus.initial:
          backgroundColor = null;
          borderColor =
              Theme.of(context).extension<CustomColors>()!.borderActive!;
          break;
        case LetterStatus.green:
          backgroundColor = Theme.of(context).extension<CustomColors>()!.green!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
        case LetterStatus.yellow:
          backgroundColor =
              Theme.of(context).extension<CustomColors>()!.yellow!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
        case LetterStatus.notInWord:
          backgroundColor =
              Theme.of(context).extension<CustomColors>()!.notInWord!;
          borderColor = Colors.transparent;
          textColor = Colors.white;
          break;
      }
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: index < ref.watch(gridProvider).tiles.length
          ? FittedBox(
              fit: BoxFit.contain,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    ref.watch(gridProvider).tiles[index].letter,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
