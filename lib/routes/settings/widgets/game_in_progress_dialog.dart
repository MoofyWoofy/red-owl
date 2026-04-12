import 'package:flutter/material.dart';

/// A confirmation dialog shown before destructive settings changes when a
/// game is currently in progress.
///
/// Returns `true` via [Navigator.pop] when the user taps "Yes" (proceed)
/// and `false` when they tap "No" (cancel). The caller awaits the result
/// with `showDialog<bool>(...)` and only applies the change if `true`.
///
/// Used in two places:
/// 1. Toggling the custom word list — would reset the active game board.
/// 2. Importing a new custom word list — also resets the board.
class GameInProgressDialog extends StatelessWidget {
  const GameInProgressDialog({super.key, required this.content});

  /// The explanatory message shown below the "Are you sure?" title, describing
  /// what will be lost or changed if the user confirms.
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Are you sure?',
        textAlign: TextAlign.center,
      ),
      content: Text(content),
      actions: [
        // "No" — cancel the operation and return false.
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('No'),
        ),
        // "Yes" — confirm the operation and return true.
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Yes'),
        )
      ],
    );
  }
}
