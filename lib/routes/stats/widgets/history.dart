import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show HistoryColors;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/routes/stats/widgets/history_tile.dart';
import 'package:red_owl/util/shared.dart' show Localization;

/// Fetches and displays the full game history from the Drift database as a
/// scrollable list of [HistoryTile] widgets.
///
/// Records are ordered newest-first. Each tile's background color is chosen
/// from the [HistoryColors] theme extension based on the stored [GameState].
///
/// The database connection is opened in [initState] and closed in [dispose]
/// to avoid connection leaks.
class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  /// Future that resolves to all history rows, ordered by date descending.
  Future<List<HistoryData>>? _historyData;

  /// The database instance used only while this widget is alive.
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    // Select all rows, most recent first.
    _historyData = (_database.select(_database.history)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .get();
  }

  @override
  void dispose() {
    // Always close the database connection when the widget is removed.
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
          // Friendly prompt when the player has not finished any game yet.
          return Center(child: Text(context.l10n.playGameFirst));
        }

        final historyItems = snapshot.data!;

        return ListView.separated(
          itemCount: historyItems.length,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final historyItem = historyItems[index];

            // Map the stored game state string to a background color.
            Color backgroundColor;
            final gameState = GameState.values.byName(historyItem.gameState);

            switch (gameState) {
              case GameState.won:
                backgroundColor =
                    Theme.of(context).extension<HistoryColors>()!.green!;
                break;
              case GameState.lost:
                backgroundColor =
                    Theme.of(context).extension<HistoryColors>()!.red!;
                break;
              case GameState.incomplete:
                backgroundColor =
                    Theme.of(context).extension<HistoryColors>()!.yellow!;
                break;
            }

            return HistoryTile(
              backgroundColor: backgroundColor,
              date: historyItem.date,
              word: historyItem.word,
            );
          },
        );
      },
    );
  }
}
