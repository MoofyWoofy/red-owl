import 'package:flutter/material.dart';
import 'package:red_owl/util/shared.dart' show Localization;

/// An [IconButton] that shows a help (?) icon and opens a scrollable
/// [AlertDialog] when tapped.
///
/// Used on [WordlePage] (how-to-play instructions) and [StatsPage] (history
/// color legend). The dialog can have an optional [title] and accepts any
/// list of widgets as its [body] content.
class HelpIconButton extends StatelessWidget {
  const HelpIconButton({
    super.key,
    /// Optional title displayed at the top of the dialog, centered.
    /// Omit to show no title row.
    this.title,
    /// Body widgets rendered inside a [SingleChildScrollView] > [ListBody].
    required this.body,
  });

  /// Optional centered title for the dialog.
  final String? title;

  /// Content widgets shown in the scrollable dialog body.
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
              // Only render a title widget when a title string was provided.
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
