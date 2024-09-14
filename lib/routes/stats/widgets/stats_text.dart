import 'package:flutter/material.dart';

class StatsText extends StatelessWidget {
  const StatsText({super.key, required this.text, required this.isTopText});
  final String text;
  final bool isTopText;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: isTopText ? FontWeight.bold : FontWeight.normal,
        fontSize: isTopText ? 16 : null,
      ),
    );
  }
}
