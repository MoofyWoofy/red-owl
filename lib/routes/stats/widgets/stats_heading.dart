import 'package:flutter/material.dart';

/// A bold section heading used on the Stats page.
///
/// Renders [text] in [TextTheme.headlineMedium] with uniform padding.
/// Used above the stats counters, the guess distribution chart, and the
/// history list to visually separate each section.
class StatsHeading extends StatelessWidget {
  const StatsHeading({super.key, required this.text});

  /// The heading label to display.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
