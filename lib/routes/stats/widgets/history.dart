import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart'
    show BoolFamilyProviderIDs, SharedPreferencesKeys;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/riverpod/shared.dart' show boolFamilyNotifierProvider;
import 'package:red_owl/util/shared.dart' show dateToString;

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Future<List<HistoryData>>? _historyData;
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _historyData = (_database.select(_database.history)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .get();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _historyData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('error: ${snapshot.error!.toString()}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('snapshot has no data.'));
        }
        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('Play a game first.'));
        }

        final historyItems = snapshot.data!;

        return ListView.separated(
          itemCount: historyItems.length,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 8),
          itemBuilder: (_, index) {
            return _HistoryCard(historyItem: historyItems[index]);
          },
        );
      },
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({
    required this.historyItem,
  });

  final HistoryData historyItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.watch(boolFamilyNotifierProvider(
      id: BoolFamilyProviderIDs.isDarkMode,
      sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
    ));

    return Container(
      decoration: BoxDecoration(
          //* Testing colors
          color: historyItem.guessCorrect
              ? (isDarkMode
                  ? const Color.fromRGBO(0, 76, 48, 1)
                  : const Color.fromRGBO(72, 199, 142, 1))
              : (isDarkMode
                  ? const Color.fromRGBO(101, 10, 30, 1)
                  : const Color.fromRGBO(255, 82, 113, 1)),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateToString(historyItem.date),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            historyItem.word,
            style: const TextStyle(
              fontSize: 20,
              // color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
