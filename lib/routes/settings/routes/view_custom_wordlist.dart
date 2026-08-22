import 'package:flutter/material.dart';
import 'package:red_owl/util/shared.dart' show Localization, WordleService;
import 'package:red_owl/widgets/shared.dart' show appBar;

/// Displays the currently active word list (standard or custom) as a
/// scrollable list of words.
///
/// Loads the word list asynchronously via [WordleService.getWordList] so the
/// user can inspect which words are loaded before starting a game.
/// Useful for verifying that a freshly imported custom list was saved correctly.
class ViewCustomListPage extends StatefulWidget {
  const ViewCustomListPage({super.key});

  @override
  State<ViewCustomListPage> createState() => _ViewCustomListPageState();
}

class _ViewCustomListPageState extends State<ViewCustomListPage> {
  /// Async future resolving to the list of words to display.
  Future<List<String>>? _words;

  @override
  void initState() {
    super.initState();
    // Load the word list once when the page opens.
    _words = WordleService().getWordList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          context: context,
          title: context.l10n.customList,
        ),
        body: FutureBuilder(
          future: _words,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              // Reading the list can fail (missing or unreadable file); show a
              // message rather than re-throwing out of build, which replaces
              // the whole page with a red error screen.
              return Center(child: Text(context.l10n.wordListLoadError));
            }

            final words = snapshot.data ?? const <String>[];
            if (words.isEmpty) {
              // `prototypeItem` below reads `words.first`, so an empty list has
              // to be handled before it — it used to throw
              // `Bad state: No element`.
              return Center(child: Text(context.l10n.wordListEmpty));
            }

            // Use prototypeItem for O(1) layout — all list tiles are identical height.
            return ListView.builder(
              itemCount: words.length,
              prototypeItem: ListTile(
                title: Text(words.first),
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(words[index]),
                );
              },
            );
          },
        ));
  }
}
