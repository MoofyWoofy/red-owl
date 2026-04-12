import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/riverpod/shared.dart'
    show gridProvider, boolFamilyProvider;
import 'package:red_owl/routes/settings/routes/view_custom_wordlist.dart';
import 'package:red_owl/routes/settings/widgets/shared.dart'
    show GameInProgressDialog, SwitchItem;
import 'package:red_owl/util/misc.dart' show isGameInProgress;
import 'package:red_owl/util/shared.dart' show Localization, WordleService;
import 'package:red_owl/widgets/shared.dart' show Logo, appBar;
import 'package:url_launcher/url_launcher.dart';

/// The Settings page, accessible from the gear icon in any [AppBar].
///
/// Contains:
/// - **Dark Mode** toggle — switches between [lightTheme] and [darkTheme].
/// - **Use custom word list** toggle — switches the active word list source.
///   When enabled, two additional action buttons appear:
///   - **Import** — opens a file picker to load a `.txt` word list. Each
///     word must be exactly 5 alphabetic characters; any invalid line aborts
///     the import with a snack bar message.
///   - **View** — navigates to [ViewCustomListPage].
/// - **About** button at the bottom — opens a system [AboutDialog] with the
///   app version and privacy policy link.
///
/// Destructive operations (toggling or importing when a game is in progress)
/// first show a [GameInProgressDialog] and only proceed if the user confirms.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: context.l10n.settings,
        // Show ✕ instead of a gear icon (this page IS the settings page).
        showCancelIcon: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Dark Mode ────────────────────────────────────────────
                    SwitchItem(
                      title: context.l10n.darkMode,
                      icon: Icons.contrast,
                      boolProviderId: BoolFamilyProviderIDs.isDarkMode,
                      sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    // ── Custom Word List ─────────────────────────────────────
                    SwitchItem(
                      title: context.l10n.customWordList,
                      icon: Icons.list_alt,
                      boolProviderId: BoolFamilyProviderIDs.useCustomList,
                      sharedPrefsKey: SharedPreferencesKeys.useCustomList,
                      // Custom callback: warn the player if a game is in progress
                      // before switching word lists (the board will be reset).
                      callback: (value) async {
                        var grid = ref.watch(gridProvider);
                        bool updateCustomList = true;
                        if (isGameInProgress(grid)) {
                          updateCustomList = await showDialog(
                                context: context,
                                builder: (_) => GameInProgressDialog(
                                    content:
                                        context
                                        .l10n.gameInProgressChangingWordList),
                              ) ??
                              false;
                          // Reset the board only if the user confirmed.
                          if (updateCustomList) {
                            ref.read(gridProvider.notifier).resetGrid();
                          }
                        }
                        if (updateCustomList) {
                          ref
                              .read(
                                boolFamilyProvider(
                                id: BoolFamilyProviderIDs.useCustomList,
                                sharedPrefsKey:
                                    SharedPreferencesKeys.useCustomList,
                              ).notifier)
                              .updateBoolean(
                                  SharedPreferencesKeys.useCustomList, value);
                          // Re-initialise WordleService to pick a word from the
                          // newly selected list.
                          await WordleService().init();
                        }
                      },
                    ),
                    // ── Import / View buttons (visible only when custom list is on) ──
                    if (ref.watch(
                      boolFamilyProvider(
                        id: BoolFamilyProviderIDs.useCustomList,
                        sharedPrefsKey: SharedPreferencesKeys.useCustomList,
                      ),
                    ))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Import button: opens file picker and validates the file.
                          OutlinedButton.icon(
                            onPressed: () async {
                              var grid = ref.watch(gridProvider);
                              bool importCustomList = true;
                              // Warn the user if a game is currently in progress.
                              if (isGameInProgress(grid)) {
                                importCustomList = await showDialog(
                                  context: context,
                                  builder: (_) => GameInProgressDialog(
                                    content:
                                      context
                                        .l10n.gameInProgressImportingWordList,
                                  ),
                                );
                              }
                              if (importCustomList) {
                                FilePickerResult? result =
                                    await FilePicker.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['txt'],
                                );

                                if (result != null) {
                                  File file = File(result.files.single.path!);

                                  // Validate every word: must be exactly 5 ASCII letters.
                                  final contents = await file.readAsString();
                                  List<String> words = contents
                                      .split('\n')
                                      .map((e) => e.trim())
                                      .toList();
                                  RegExp regExp = RegExp(r'^[a-zA-Z]{5}$');

                                  for (var i = 0; i < words.length; i++) {
                                    if (!regExp.hasMatch(words[i])) {
                                      // Invalid word found — show which line and abort.
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            content: Text(
                                              'line: ${i + 1} "${words[i]}" is not valid',
                                              textAlign: TextAlign.center,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                  }

                                  // All words valid — copy to the app documents directory.
                                  Directory directory =
                                      await getApplicationDocumentsDirectory();

                                  file.copy(
                                      '${directory.path}/custom_list.txt');
                                  file.delete();
                                  // Reinitialise service to load the new word.
                                  await WordleService().init();
                                  // Reset the board since the word list changed.
                                  ref.read(gridProvider.notifier).resetGrid();

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        content: Text(
                                          context.l10n.success,
                                          textAlign: TextAlign.center,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
                                // else: user cancelled the picker — no action needed.
                              }
                            },
                            icon: const Icon(Icons.file_upload_outlined),
                            label: Text(context.l10n.import),
                          ),
                          const SizedBox(width: 16),
                          // View button: navigate to the word list viewer.
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewCustomListPage()),
                              );
                            },
                            icon: const Icon(Icons.list),
                            label: Text(context.l10n.view),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            // ── About button ─────────────────────────────────────────────────
            TextButton(
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                overlayColor: Colors.transparent,
              ),
              onPressed: () async {
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                if (context.mounted) {
                  showAboutDialog(
                    context: context,
                    applicationIcon: const Logo(size: 75),
                    applicationVersion: packageInfo.version,
                    children: [
                      Text(
                        context.l10n.yetAnotherWordApp,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () async {
                          final uri = Uri.parse(
                              'https://moofywoofy.github.io/red-owl/');
                          if (!await launchUrl(uri)) {
                            throw Exception('Could not launch $uri');
                          }
                        },
                        child: Text(context.l10n.privacyPolicy),
                      )
                    ],
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.l10n.about),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
