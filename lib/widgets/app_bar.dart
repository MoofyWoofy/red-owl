import 'package:flutter/material.dart';
import 'package:red_owl/routes/shared.dart' show SettingsPage;
import 'package:red_owl/util/shared.dart' show Localization;

AppBar appBar({
  required BuildContext context,
  required String title,
  bool showSettingIcon = false,
  bool automaticallyImplyLeading = true,
  bool centerTitle = true,
  bool showCancelIcon = false,
  List<Widget> widgets = const [],
}) {
  return AppBar(
    title: Text(title),
    centerTitle: centerTitle,
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: 4,
    actions: [
      ...widgets,
      if (showSettingIcon) ...[
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: context.l10n.settings,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ] else if (showCancelIcon) ...[
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: context.l10n.exit,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ]
    ],
  );
}
