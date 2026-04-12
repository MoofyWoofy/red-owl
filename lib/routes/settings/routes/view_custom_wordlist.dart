import 'package:flutter/material.dart';
import 'package:red_owl/util/shared.dart' show WordleService;
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
          title: 'Custom list',
        ),
        body: FutureBuilder(
          future: _words,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // Re-throw so the framework's error boundary can catch it.
              throw snapshot.error!;
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            List<String> words = snapshot.data!;

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
