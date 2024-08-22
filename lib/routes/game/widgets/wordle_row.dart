import 'package:flutter/material.dart';
import 'package:red_owl/routes/game/widgets/shared.dart' show WordleBox;

class WordleRow extends StatelessWidget {
  const WordleRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 5; i++)
          const Padding(padding: EdgeInsets.all(4.0), child: WordleBox())
      ],
    );
  }
}
