import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show CustomColors;

class Letter extends StatelessWidget {
  const Letter({super.key, this.letter, this.icon});
  final String? letter;
  final IconData? icon;

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
          child: letter != null
              ? Text(
                  letter!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(icon),
                ),
        ),
      ),
    );
  }
}
