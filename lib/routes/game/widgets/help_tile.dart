import 'package:flutter/material.dart';

class HelpTile extends StatelessWidget {
  const HelpTile({
    super.key,
    required this.background,
    required this.letter,
  });
  final Color background;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              background, //  Theme.of(context).extension<CustomColors>()!.green!
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                letter,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }
}
