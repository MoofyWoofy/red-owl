import 'package:flutter/material.dart';

class GameInProgressDialog extends StatelessWidget {
  const GameInProgressDialog({super.key, required this.content});
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('No'),
        ),
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
