import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart'
    show BoolFamilyProviderIDs, SharedPreferencesKeys;
import 'package:red_owl/riverpod/shared.dart'
    show boolFamilyProvider, gridProvider;
import 'package:red_owl/util/shared.dart' show Localization, buildEmojiGrid;
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

/// App-bar action that shares the finished board as an emoji result grid.
///
/// Enabled only once the game is over. Builds the NYT-style grid from the board
/// state via [buildEmojiGrid] (honouring the color-blind palette) and opens the
/// system share sheet.
class ShareResultButton extends ConsumerWidget {
  const ShareResultButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grid = ref.watch(gridProvider);
    final enabled = grid.isGameOver;

    return IconButton(
      icon: const Icon(Icons.ios_share),
      tooltip: context.l10n.shareResult,
      onPressed: enabled ? () => _share(context, ref) : null,
    );
  }

  void _share(BuildContext context, WidgetRef ref) {
    final grid = ref.read(gridProvider);
    final colorBlind = ref.read(boolFamilyProvider(
      id: BoolFamilyProviderIDs.isColorBlindMode,
      sharedPrefsKey: SharedPreferencesKeys.isColorBlindMode,
    ));
    final date =
        MaterialLocalizations.of(context).formatCompactDate(DateTime.now());

    final text = buildEmojiGrid(
      tiles: grid.tiles,
      isGameWon: grid.isGameWon,
      colorBlind: colorBlind,
      titlePrefix: '${context.l10n.appName} $date',
    );
    SharePlus.instance.share(ShareParams(text: text));
  }
}
