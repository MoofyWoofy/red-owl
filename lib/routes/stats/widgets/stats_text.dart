import 'package:flutter/material.dart';

/// A single text cell used inside the stats counters row on the Stats page.
///
/// [isTopText] controls the styling:
/// - `true`  → larger bold font for the numeric value (e.g. "42").
/// - `false` → normal weight for the label beneath it (e.g. "Played").
///
/// Both variants are centered so they align within their [Expanded] parent.
class StatsText extends StatelessWidget {
  const StatsText({super.key, required this.text, required this.isTopText});

  /// The string to display.
  final String text;

  /// Whether this is the numeric value row (bold, larger) or the label row.
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
