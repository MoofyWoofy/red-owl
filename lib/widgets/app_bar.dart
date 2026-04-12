import 'package:flutter/material.dart';
import 'package:red_owl/routes/shared.dart' show SettingsPage;
import 'package:red_owl/util/shared.dart' show Localization;

/// Creates a standardised [AppBar] used across all pages in the app.
///
/// The trailing action icon is controlled by two mutually exclusive flags:
/// - [showSettingIcon]: shows a gear icon that pushes [SettingsPage].
/// - [showCancelIcon]: shows an ✕ icon that pops the current route (used on
///   [SettingsPage] itself to avoid a circular push).
///
/// Additional [widgets] are prepended to the actions list before the icon,
/// allowing pages to inject their own action buttons (e.g. share and help
/// icons on [StatsPage]).
///
/// Parameters:
/// - [context]                  – required for navigation and localization.
/// - [title]                    – text shown in the centre of the bar.
/// - [showSettingIcon]          – whether to show the settings gear (default false).
/// - [automaticallyImplyLeading]– whether Flutter should auto-insert a back
///   arrow (default true).
/// - [centerTitle]              – whether the title is centred (default true).
/// - [showCancelIcon]           – whether to show a close/pop icon (default false).
/// - [widgets]                  – extra action widgets placed before the icon.
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
      // Any caller-supplied action buttons come first.
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
        // Cancel / close icon — pops the current page instead of pushing.
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
