import 'package:flutter/material.dart';
import 'package:red_owl/util/shared.dart' show dateToString;

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    super.key,
    required this.backgroundColor,
    required this.date,
    required this.word,
  });

  final Color backgroundColor;
  final DateTime date;
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
            dateToString(date),
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
