import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/riverpod/shared.dart' show gridProvider, PracticeGrid;
import 'package:red_owl/routes/game/widgets/shared.dart' show GameBoard;
import 'package:red_owl/util/shared.dart' show Localization;
import 'package:red_owl/widgets/shared.dart' show appBar;

/// The practice / unlimited-mode screen.
///
/// Plays exactly like the daily game but with a fresh **random** word each
/// round and no stats or history tracking. It overrides `gridProvider` with a
/// [PracticeGrid] for its subtree, so the shared [GameBoard], tiles and
/// keyboard work unchanged while reading the practice notifier instead of the
/// daily one. A toolbar action starts a new word at any time.
class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // Swap the daily notifier for the practice one within this page only.
      //
      // This trips riverpod_lint's scoped_providers_should_specify_dependencies,
      // knowingly and permanently. The lint wants `dependencies` declared on
      // the provider, but that marker means "this provider requires a scope to
      // supply it", which is false here: the root scope always provides the
      // daily notifier and this override merely replaces it for one page.
      // Declaring it would also oblige every widget that reads gridProvider --
      // most of the game UI -- to claim a dependency on a scope none of them
      // require. The warning cannot currently be silenced either: plugin
      // diagnostics ignore `// ignore:` comments, and the analyzer rejects
      // their codes in analysis_options' `errors:` map as unrecognised. So it
      // stands as the one expected warning from `dart analyze`.
      overrides: [gridProvider.overrideWith(PracticeGrid.new)],
      child: const _PracticeView(),
    );
  }
}

class _PracticeView extends ConsumerWidget {
  const _PracticeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: context.l10n.practice,
        widgets: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: context.l10n.newWord,
            onPressed: () => ref.read(gridProvider.notifier).resetGrid(),
          ),
        ],
      ),
      body: const GameBoard(),
    );
  }
}
