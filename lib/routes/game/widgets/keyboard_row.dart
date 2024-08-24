import 'package:flutter/material.dart';
import 'package:red_owl/routes/game/widgets/shared.dart' show Letter, WordleBox;
import 'package:red_owl/config/shared.dart' show letterStatus;

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    super.key,
    required this.minIndex,
    required this.maxIndex,
  });
  final int minIndex, maxIndex;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letterStatus.entries.map((e) {
        index++;
        if (index >= minIndex && index <= maxIndex) {
          switch (e.key) {
            case 'ENTER':
            case 'DELETE':
              return Expanded(flex: 2, child: Letter(letter: e.key));
            default:
              return Expanded(child: Letter(letter: e.key));
          }
        }
        return const SizedBox();
      }).toList(),
    );
  }
}
