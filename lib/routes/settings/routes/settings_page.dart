import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/riverpod/shared.dart'
    show gridProvider, boolFamilyProvider;
import 'package:red_owl/routes/settings/routes/view_custom_wordlist.dart';
import 'package:red_owl/routes/settings/widgets/shared.dart'
    show GameInProgressDialog, SwitchItem;
import 'package:red_owl/util/misc.dart' show isGameInProgress;
import 'package:red_owl/util/shared.dart'
    show
        BackupService,
        Localization,
        WordleService,
        WordListImportStatus,
        showSnackBar;
import 'package:red_owl/widgets/shared.dart' show Logo, appBar;
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams, XFile;
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
                            onPressed: () =>
                                _importCustomWordList(context, ref),
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
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 12),
                    // ── Backup: export / import all user data ─────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _exportData(context),
                          icon: const Icon(Icons.upload_file_outlined),
                          label: Text(context.l10n.exportData),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () => _importData(context, ref),
                          icon: const Icon(Icons.download_outlined),
                          label: Text(context.l10n.importData),
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

  /// Lets the user pick a `.txt` file and imports it as the custom word list.
  ///
  /// Warns first if a game is in progress (importing resets the board), then
  /// delegates validation/saving to [WordleService.importWordList] and shows a
  /// localised message describing the result.
  Future<void> _importCustomWordList(
      BuildContext context, WidgetRef ref) async {
    if (isGameInProgress(ref.read(gridProvider))) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (_) => GameInProgressDialog(
          content: context.l10n.gameInProgressImportingWordList,
        ),
      );
      if (proceed != true) return;
    }

    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (picked == null) return; // User cancelled the picker.

    final result =
        await WordleService().importWordList(File(picked.files.single.path!));
    if (!context.mounted) return;

    switch (result.status) {
      case WordListImportStatus.success:
        // The word list changed — reload the word of the day and reset the board.
        await WordleService().init();
        ref.read(gridProvider.notifier).resetGrid();
        if (context.mounted) {
          // Warn (but still import) when the list is too small for a full year.
          if (result.belowRecommendedMinimum) {
            showSnackBar(
                context, context.l10n.importFewWords(result.words!.length), 3);
          } else {
            showSnackBar(context, context.l10n.success);
          }
        }
      case WordListImportStatus.invalidWord:
        showSnackBar(
          context,
          context.l10n.importInvalidLine(
              result.lineNumber!, result.invalidWord!),
          3,
        );
      case WordListImportStatus.readError:
        showSnackBar(context, context.l10n.importReadError, 3);
      case WordListImportStatus.fileTooLarge:
        showSnackBar(context, context.l10n.importTooLarge, 3);
    }
  }

  /// Exports settings, stats and history to a JSON file and opens the system
  /// share sheet.
  ///
  /// If the user has a custom word list, first asks whether to bundle it into
  /// the export. Any failure surfaces as a snack bar rather than crashing.
  Future<void> _exportData(BuildContext context) async {
    bool includeWordList = false;
    if (await BackupService().hasCustomWordList()) {
      if (!context.mounted) return;
      includeWordList = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(context.l10n.includeWordListTitle),
              content: Text(context.l10n.includeWordListContent),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(context.l10n.no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(context.l10n.yes),
                ),
              ],
            ),
          ) ??
          false;
    }

    try {
      final file =
          await BackupService().exportToFile(includeWordList: includeWordList);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        fileNameOverrides: [path.basename(file.path)],
      ));
    } catch (_) {
      if (context.mounted) {
        showSnackBar(context, context.l10n.exportFailed);
      }
    }
  }

  /// Imports a previously exported JSON backup, replacing the current data.
  ///
  /// Warns the user that existing data will be overwritten, picks a `.json`
  /// file, applies it via [BackupService.importFromJson], then refreshes the
  /// in-memory providers (theme, custom-list toggle) and resets the board so
  /// the active game stays consistent with the (possibly changed) word list.
  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(context.l10n.importData),
            content: Text(context.l10n.importOverwriteWarning),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(context.l10n.no),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(context.l10n.yes),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null) return; // User cancelled the picker.

    try {
      final file = File(result.files.single.path!);
      await BackupService().importFromJson(await file.readAsString());

      // Re-load the word of the day and reset the board, since the imported
      // settings/word list may differ from the active game.
      await WordleService().init();
      ref.read(gridProvider.notifier).resetGrid();
      // Force the theme and custom-list toggle to re-read the imported values.
      ref.invalidate(boolFamilyProvider(
        id: BoolFamilyProviderIDs.isDarkMode,
        sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
      ));
      ref.invalidate(boolFamilyProvider(
        id: BoolFamilyProviderIDs.useCustomList,
        sharedPrefsKey: SharedPreferencesKeys.useCustomList,
      ));

      if (context.mounted) {
        showSnackBar(context, context.l10n.success);
      }
    } catch (_) {
      if (context.mounted) {
        showSnackBar(context, context.l10n.importFailed);
      }
    }
  }
}
