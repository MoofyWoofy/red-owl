import 'package:flutter/material.dart';
import 'package:red_owl/util/shared.dart' show Localization;

class HelpIconButton extends StatelessWidget {
  const HelpIconButton({
    super.key,
    this.title,
    required this.body,
  });
  final String? title;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.help,
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: title == null
                  ? null
                  : Text(title!, textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: ListBody(
                  children: body,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(context.l10n.close),
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
