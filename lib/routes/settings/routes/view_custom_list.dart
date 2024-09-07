import 'package:flutter/material.dart';
import 'package:red_owl/util/shared.dart' show WordleService;
import 'package:red_owl/widgets/shared.dart' show appBar;

class ViewCustomListPage extends StatefulWidget {
  const ViewCustomListPage({super.key});

  @override
  State<ViewCustomListPage> createState() => _ViewCustomListPageState();
}

class _ViewCustomListPageState extends State<ViewCustomListPage> {
  Future<List<String>>? _words;

  @override
  void initState() {
    super.initState();
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
              throw snapshot.error!;
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            List<String> words = snapshot.data!;

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
