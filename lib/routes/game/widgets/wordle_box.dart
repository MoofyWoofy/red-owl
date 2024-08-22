import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show CustomColors;

class WordleBox extends StatelessWidget {
  const WordleBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).extension<CustomColors>()!.borderInactive!,
            width: 2),
      ),
    );
  }
}
