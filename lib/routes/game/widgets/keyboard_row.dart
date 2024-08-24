import 'package:flutter/material.dart';
import 'package:red_owl/routes/game/widgets/shared.dart' show Letter;
import 'package:red_owl/config/shared.dart' show keyboardStatus;

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    super.key,
    required this.minIndex,
    required this.maxIndex,
    this.addSpacer = false,
  });
  final int minIndex, maxIndex;
  final bool addSpacer;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (addSpacer) const Spacer(),
        ...keyboardStatus.entries.map((e) {
          
        index++;
        if (index >= minIndex && index <= maxIndex) {
          switch (e.key) {
            case 'ENTER':
            case 'DELETE':
                return Expanded(flex: 8, child: Letter(letter: e.key));
              default:
                return Expanded(flex: 4, child: Letter(letter: e.key));
          }
        }
        return const SizedBox();
        }),
        if (addSpacer) const Spacer(),
      ],
    );
  }
}
