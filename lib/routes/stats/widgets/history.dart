import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show HistoryColors;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/routes/stats/widgets/history_tile.dart';
import 'package:red_owl/util/shared.dart' show Localization, getDateOnly;

/// Which slice of the game history to show.
enum HistoryFilter {
  /// Every recorded game.
  all,

  /// Games from the last 30 days (rolling window ending today).
  last30,

  /// Games within a user-picked [DateTimeRange].
  custom,
}

/// Fetches and displays the game history from the Drift database as a
/// scrollable, filterable list of [HistoryTile] widgets.
///
/// A [SegmentedButton] lets the player narrow the list to all games, the last
/// 30 days, or a custom date range (picked via [showDateRangePicker]). Records
/// are ordered newest-first and coloured from the [HistoryColors] theme
/// extension based on the stored [GameState].
class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  /// Future that resolves to the currently-filtered history rows.
  Future<List<HistoryData>>? _historyData;

  /// The active filter.
  HistoryFilter _filter = HistoryFilter.all;

  /// The custom range, set when [_filter] is [HistoryFilter.custom].
  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    _runQuery();
  }

  /// Builds and runs the history query for the active filter.
  void _runQuery() {
    final database = AppDatabase();
    final query = database.select(database.history)
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ]);

    final range = _activeRange();
    if (range != null) {
      query.where((t) =>
          t.date.isBiggerOrEqualValue(range.start) &
          t.date.isSmallerOrEqualValue(range.end));
    }
    _historyData = query.get();
  }

  /// The inclusive date range implied by the active filter, or `null` for
  /// [HistoryFilter.all].
  DateTimeRange? _activeRange() {
    switch (_filter) {
      case HistoryFilter.all:
        return null;
      case HistoryFilter.last30:
        final today = getDateOnly(DateTime.now());
        return DateTimeRange(
          start: today.subtract(const Duration(days: 29)),
          end: today,
        );
      case HistoryFilter.custom:
        return _customRange;
    }
  }

  /// Applies [filter], prompting for a date range when [HistoryFilter.custom].
  Future<void> _selectFilter(HistoryFilter filter) async {
    if (filter == HistoryFilter.custom) {
      final today = getDateOnly(DateTime.now());
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: today,
        initialDateRange: _customRange,
      );
      // Keep the previous filter if the user dismissed the picker.
      if (picked == null) return;
      _customRange = DateTimeRange(
        start: getDateOnly(picked.start),
        end: getDateOnly(picked.end),
      );
    }
    setState(() {
      _filter = filter;
      _runQuery();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Filter selector ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SegmentedButton<HistoryFilter>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: HistoryFilter.all,
                label: Text(context.l10n.filterAll),
              ),
              ButtonSegment(
                value: HistoryFilter.last30,
                label: Text(context.l10n.filterLast30),
              ),
              ButtonSegment(
                value: HistoryFilter.custom,
                icon: const Icon(Icons.date_range),
                label: Text(context.l10n.filterDateRange),
              ),
            ],
            selected: {_filter},
            onSelectionChanged: (selection) => _selectFilter(selection.first),
          ),
        ),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    return FutureBuilder(
      future: _historyData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('error: ${snapshot.error}'));
        }

        final historyItems = snapshot.data;
        if (historyItems == null || historyItems.isEmpty) {
          // Distinguish "never played" from "nothing in the chosen range".
          final message = _filter == HistoryFilter.all
              ? context.l10n.playGameFirst
              : context.l10n.noGamesInRange;
          return Center(child: Text(message));
        }

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
