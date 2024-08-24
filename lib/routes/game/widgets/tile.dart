import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show CustomColors, LetterStatus;
import 'package:red_owl/riverpod/shared.dart';

class Tile extends ConsumerWidget {
  const Tile({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? color;
    Color borderColor =
        Theme.of(context).extension<CustomColors>()!.borderInactive!;

    if (index < ref.watch(gridProvider).tiles.length) {
      switch (ref.watch(gridProvider).tiles[index].status) {
        case LetterStatus.initial:
          color = null;
          borderColor =
              Theme.of(context).extension<CustomColors>()!.borderActive!;
          break;
        case LetterStatus.green:
          color = Theme.of(context).extension<CustomColors>()!.green!;
          borderColor = Colors.transparent;
          break;
        case LetterStatus.yellow:
          color = Theme.of(context).extension<CustomColors>()!.yellow!;
          borderColor = Colors.transparent;
          break;
        case LetterStatus.notInWord:
          color = Theme.of(context).extension<CustomColors>()!.notInWord!;
          borderColor = Colors.transparent;
          break;
      }
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
