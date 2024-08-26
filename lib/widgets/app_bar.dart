import 'package:flutter/material.dart';
import 'package:red_owl/routes/shared.dart' show SettingsPage;

AppBar appBar({
  required BuildContext context,
  required String title,
  bool showSettingsPage = true,
  bool automaticallyImplyLeading = true,
  bool centerTitle = true,
}) {
  return AppBar(
    title: Text(title),
    centerTitle: centerTitle,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: [
      IconButton(
        icon: showSettingsPage
            ? const Icon(Icons.settings)
            : const Icon(Icons.clear),
        tooltip: showSettingsPage ? 'Settings' : 'Exit',
        onPressed: () {
          if (showSettingsPage) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
    ],
  );
}
