// Widget tests for the History list and its date filter on the Stats page.
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/database/database.dart' hide History;
import 'package:red_owl/routes/stats/widgets/shared.dart' show History;
import 'package:red_owl/util/shared.dart' show getDateOnly;

import '../../helpers/test_helpers.dart';

void main() {
  late DateTime today;

  /// Inserts a history row [daysAgo] days before today.
  Future<void> insertRow(String word, int daysAgo, GameState state) {
    final db = AppDatabase();
    return db.into(db.history).insert(HistoryCompanion.insert(
          word: word,
          date: getDateOnly(today.subtract(Duration(days: daysAgo))),
          gameState: state.name,
        ));
  }

  setUp(() async {
    today = DateTime.now();
    AppDatabase.setSingleton(AppDatabase.forTesting(NativeDatabase.memory()));
  });

  tearDown(() async {
    await AppDatabase().close();
    AppDatabase.resetSingleton();
  });

  testWidgets('shows all games under the default filter', (tester) async {
    await insertRow('AAAAA', 0, GameState.won);
    await insertRow('BBBBB', 10, GameState.lost);
    await insertRow('CCCCC', 60, GameState.incomplete);

    await tester.pumpWidget(makeTestApp(child: const History()));
    await tester.pumpAndSettle();

    expect(find.text('AAAAA'), findsOneWidget);
    expect(find.text('BBBBB'), findsOneWidget);
    expect(find.text('CCCCC'), findsOneWidget);
  });

  testWidgets('the 30-day filter hides older games', (tester) async {
    await insertRow('AAAAA', 0, GameState.won);
    await insertRow('BBBBB', 10, GameState.lost);
    await insertRow('CCCCC', 60, GameState.incomplete);

    await tester.pumpWidget(makeTestApp(child: const History()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('30 days'));
    await tester.pumpAndSettle();

    expect(find.text('AAAAA'), findsOneWidget);
    expect(find.text('BBBBB'), findsOneWidget);
    // The 60-day-old game falls outside the rolling window.
    expect(find.text('CCCCC'), findsNothing);
  });

  testWidgets('shows a friendly empty state when no games are recorded',
      (tester) async {
    await tester.pumpWidget(makeTestApp(child: const History()));
    await tester.pumpAndSettle();

    expect(find.text('Play a game first.'), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
  });

  testWidgets('shows an empty-range message when nothing matches',
      (tester) async {
    // Only an old game exists.
    await insertRow('CCCCC', 60, GameState.incomplete);

    await tester.pumpWidget(makeTestApp(child: const History()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('30 days'));
    await tester.pumpAndSettle();

    expect(find.text('CCCCC'), findsNothing);
    expect(find.text('No games in this range.'), findsOneWidget);
  });
}
