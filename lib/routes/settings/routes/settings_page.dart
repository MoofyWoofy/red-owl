import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/riverpod/shared.dart'
    show gridProvider, boolFamilyNotifierProvider;
import 'package:red_owl/routes/settings/routes/view_custom_list.dart';
import 'package:red_owl/routes/settings/widgets/shared.dart'
    show GameInProgressDialog, SwitchItem;
import 'package:red_owl/util/shared.dart' show WordleService;
import 'package:red_owl/widgets/shared.dart' show Logo, appBar;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: 'Settings',
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
                    const SwitchItem(
                      title: 'Dark Mode',
                      icon: Icons.contrast,
                      boolProviderId: BoolFamilyProviderIDs.isDarkMode,
                      sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    SwitchItem(
                      title: 'Use custom word list',
                      icon: Icons.list_alt,
                      boolProviderId: BoolFamilyProviderIDs.useCustomList,
                      sharedPrefsKey: SharedPreferencesKeys.useCustomList,
                      callback: (value) async {
                        var grid = ref.watch(gridProvider);
                        bool updateCustomList = true;
                        if (grid.tiles.isNotEmpty && !grid.isGameOver) {
                          updateCustomList = await showDialog(
                                context: context,
                                builder: (_) => const GameInProgressDialog(
                                    content:
                                        'Game in progress, changing word list will reset the game'),
                              ) ??
                              false;
                          // If user selected 'yes' then reset grid
                          if (updateCustomList) {
                            ref.read(gridProvider.notifier).resetGrid();
                          }
                        }
                        if (updateCustomList) {
                          ref
                              .read(boolFamilyNotifierProvider(
                                id: BoolFamilyProviderIDs.useCustomList,
                                sharedPrefsKey:
                                    SharedPreferencesKeys.useCustomList,
                              ).notifier)
                              .updateBoolean(
                                  SharedPreferencesKeys.useCustomList, value);
                          await WordleService().init();
                        }
                      },
                    ),
                    if (ref.watch(
                      boolFamilyNotifierProvider(
                        id: BoolFamilyProviderIDs.useCustomList,
                        sharedPrefsKey: SharedPreferencesKeys.useCustomList,
                      ),
                    ))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              var grid = ref.watch(gridProvider);
                              bool importCustomList = true;
                              if (grid.tiles.isNotEmpty || grid.isGameOver) {
                                importCustomList = await showDialog(
                                  context: context,
                                  builder: (_) => const GameInProgressDialog(
                                    content:
                                        'Game in progress, importing word list will reset the game',
                                  ),
                                );
                              }
                              if (importCustomList) {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['txt'],
                                );

                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  Directory directory =
                                      await getApplicationDocumentsDirectory();

                                  file.copy(
                                      '${directory.path}/custom_list.txt');
                                  file.delete();
                                  await WordleService().init();
                                  // Reset grid
                                  ref.read(gridProvider.notifier).resetGrid();
                                } else {
                                  // User canceled the picker
                                }
                              }
                            },
                            icon: const Icon(Icons.file_upload_outlined),
                            label: const Text('Import'),
                          ),
                          const SizedBox(width: 16),
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
                            label: const Text('View'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                overlayColor: Colors.transparent,
              ),
              onPressed: () => showAboutDialog(
                context: context,
                applicationIcon: const Logo(size: 75),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('About'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
