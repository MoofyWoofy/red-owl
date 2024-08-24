import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show CustomColors;

class Letter extends StatelessWidget {
  const Letter({super.key, required this.letter});
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.black38,
        onTap: () {},
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
