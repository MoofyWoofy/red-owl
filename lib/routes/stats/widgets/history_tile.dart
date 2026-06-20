import 'package:flutter/material.dart';

/// A single row in the Stats page history list.
///
/// Renders the game date (in the user's regional format) and the answer word
/// side by side on a
/// solid [backgroundColor] that indicates the game outcome:
/// - Green  → player won
/// - Red    → player lost
/// - Yellow → game was incomplete (abandoned at day rollover)
class HistoryTile extends StatelessWidget {
  const HistoryTile({
    super.key,
    /// Background color communicating the game outcome.
    required this.backgroundColor,
    /// The calendar date the game was played.
    required this.date,
    /// The 5-letter answer word for that day (uppercase).
    required this.word,
  });

  /// Solid background color indicating the game result.
  final Color backgroundColor;

  /// Date the game was played — displayed in the user's regional format.
  final DateTime date;

  /// The Wordle answer for that day.
  final String word;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            MaterialLocalizations.of(context).formatCompactDate(date),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            word,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
