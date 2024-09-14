import 'package:flutter/material.dart';

class StatsHeading extends StatelessWidget {
  const StatsHeading({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
