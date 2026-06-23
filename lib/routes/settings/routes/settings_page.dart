import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/riverpod/shared.dart'
    show
        gridProvider,
        boolFamilyProvider,
        localeProvider,
        systemLocaleCode,
        fontScaleProvider,
        fontScaleCodes,
        motionSpeedProvider,
        motionSpeedCodes,
        reminderTimeProvider;
import 'package:red_owl/routes/settings/routes/view_custom_wordlist.dart';
import 'package:red_owl/routes/settings/widgets/shared.dart'
    show GameInProgressDialog, ReminderSetting, SwitchItem;
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
              // Scroll when the settings list is taller than the viewport (small
              // screens, large text scale), but keep it vertically centred when
              // it fits.
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
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
                    // ── Color-blind / high-contrast mode ─────────────────────
                    SwitchItem(
                      title: context.l10n.colorBlindMode,
                      icon: Icons.visibility,
                      boolProviderId: BoolFamilyProviderIDs.isColorBlindMode,
                      sharedPrefsKey: SharedPreferencesKeys.isColorBlindMode,
                    ),
                    const SizedBox(height: 20),
                    // ── Hard mode ────────────────────────────────────────────
                    SwitchItem(
                      title: context.l10n.hardMode,
                      icon: Icons.local_fire_department,
                      boolProviderId: BoolFamilyProviderIDs.isHardMode,
                      sharedPrefsKey: SharedPreferencesKeys.isHardMode,
                      // Lock the toggle once today's game is underway so the
                      // ruleset can't be changed mid-puzzle.
                      callback: (value) {
                        final grid = ref.read(gridProvider);
                        if (grid.row > 0 && !grid.isGameOver) {
                          showSnackBar(context, context.l10n.hardModeLocked, 3);
                          return;
                        }
                        ref
                            .read(boolFamilyProvider(
                              id: BoolFamilyProviderIDs.isHardMode,
                              sharedPrefsKey: SharedPreferencesKeys.isHardMode,
                            ).notifier)
                            .updateBoolean(
                                SharedPreferencesKeys.isHardMode, value);
                      },
                    ),
                    const SizedBox(height: 20),
                    // ── Language selector ────────────────────────────────────
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(context.l10n.language),
                      trailing: Text(
                        _languageLabel(
                          context,
                          ref.watch(localeProvider)?.languageCode,
                        ),
                      ),
                      onTap: () => _pickLanguage(context, ref),
                    ),
                    // ── Text size ────────────────────────────────────────────
                    ListTile(
                      leading: const Icon(Icons.format_size),
                      title: Text(context.l10n.fontSize),
                      trailing:
                          Text(_fontScaleLabel(context, ref.watch(fontScaleProvider))),
                      onTap: () => _pickFontScale(context, ref),
                    ),
                    // ── Animation speed ──────────────────────────────────────
                    ListTile(
                      leading: const Icon(Icons.speed),
                      title: Text(context.l10n.animationSpeed),
                      trailing: Text(
                          _motionLabel(context, ref.watch(motionSpeedProvider))),
                      onTap: () => _pickMotionSpeed(context, ref),
                    ),
                    const SizedBox(height: 20),
                    // ── Daily reminder notification ──────────────────────────
                    const ReminderSetting(),
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
                        var grid = ref.read(gridProvider);
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

  /// Endonyms (native names) for the supported UI languages, shown in the
  /// language picker so each option is recognisable regardless of the current
  /// language.
  static const Map<String, String> _languageEndonyms = {
    'en': 'English',
    'nl': 'Nederlands',
  };

  /// Human-readable label for the currently selected [languageCode]
  /// (`null` / `'system'` → the localised "System default").
  String _languageLabel(BuildContext context, String? languageCode) {
    if (languageCode == null || languageCode == systemLocaleCode) {
      return context.l10n.systemDefault;
    }
    return _languageEndonyms[languageCode] ?? languageCode;
  }

  /// Generic single-choice picker dialog.
  ///
  /// Shows [title] and a radio list built from [codes], with [current]
  /// pre-selected and each option labelled by [labelBuilder]. Returns the code
  /// the user chose, or `null` if they dismissed the dialog.
  Future<String?> _pickCode(
    BuildContext context, {
    required String title,
    required List<String> codes,
    required String current,
    required String Function(BuildContext, String) labelBuilder,
  }) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(title),
        children: [
          RadioGroup<String>(
            groupValue: current,
            onChanged: (value) => Navigator.of(dialogContext).pop(value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final code in codes)
                  RadioListTile<String>(
                    value: code,
                    title: Text(labelBuilder(dialogContext, code)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog letting the user choose the UI language (or follow the
  /// system language) and persists the choice via [localeProvider].
  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final selected = await _pickCode(
      context,
      title: context.l10n.language,
      // System default first, then every supported locale.
      codes: [
        systemLocaleCode,
        ...AppLocalizations.supportedLocales.map((l) => l.languageCode),
      ],
      current: ref.read(localeProvider)?.languageCode ?? systemLocaleCode,
      labelBuilder: _languageLabel,
    );
    if (selected != null) {
      ref.read(localeProvider.notifier).setLocale(selected);
    }
  }

  /// Localised label for a text-size [code].
  String _fontScaleLabel(BuildContext context, String code) {
    switch (code) {
      case 'small':
        return context.l10n.fontSizeSmall;
      case 'large':
        return context.l10n.fontSizeLarge;
      case 'xlarge':
        return context.l10n.fontSizeExtraLarge;
      default:
        return context.l10n.fontSizeNormal;
    }
  }

  /// Shows the text-size picker and persists the choice via [fontScaleProvider].
  Future<void> _pickFontScale(BuildContext context, WidgetRef ref) async {
    final selected = await _pickCode(
      context,
      title: context.l10n.fontSize,
      codes: fontScaleCodes,
      current: ref.read(fontScaleProvider),
      labelBuilder: _fontScaleLabel,
    );
    if (selected != null) {
      ref.read(fontScaleProvider.notifier).setScale(selected);
    }
  }

  /// Localised label for an animation-speed [code].
  String _motionLabel(BuildContext context, String code) {
    switch (code) {
      case 'reduced':
        return context.l10n.motionReduced;
      case 'fast':
        return context.l10n.motionFast;
      case 'slow':
        return context.l10n.motionSlow;
      default:
        return context.l10n.motionNormal;
    }
  }

  /// Shows the animation-speed picker and persists the choice via
  /// [motionSpeedProvider].
  Future<void> _pickMotionSpeed(BuildContext context, WidgetRef ref) async {
    final selected = await _pickCode(
      context,
      title: context.l10n.animationSpeed,
      codes: motionSpeedCodes,
      current: ref.read(motionSpeedProvider),
      labelBuilder: _motionLabel,
    );
    if (selected != null) {
      ref.read(motionSpeedProvider.notifier).setSpeed(selected);
    }
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
      // The reminder time is provider-cached, so re-read the imported value.
      ref.invalidate(reminderTimeProvider);

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
