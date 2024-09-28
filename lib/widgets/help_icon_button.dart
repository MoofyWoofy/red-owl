import 'package:flutter/material.dart';

class HelpIconButton extends StatelessWidget {
  const HelpIconButton({
    super.key,
    required this.title,
    required this.body,
  });
  final String title;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: ListBody(
                  children: body,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.help),
    );
  }
}
