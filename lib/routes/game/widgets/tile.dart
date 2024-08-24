import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart' show CustomColors;
import 'package:red_owl/riverpod/shared.dart';

class Tile extends ConsumerWidget {
  const Tile({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).extension<CustomColors>()!.borderInactive!,
            width: 2),
      ),
      child: index < ref.watch(gridProvider).tiles.length
          ? Center(child: Text(ref.watch(gridProvider).tiles[index].letter))
          : const SizedBox(),
    );
  }
}
