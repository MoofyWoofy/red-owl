// Widget tests for the PracticePage.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/database/database.dart';
import 'package:red_owl/routes/shared.dart' show PracticePage;
import 'package:red_owl/routes/game/widgets/shared.dart' show GameBoard;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService;

import '../../helpers/test_helpers.dart';

const _testWords = ['apple', 'berry', 'chair', 'dwarf'];

void main() {
  setUp(() async {
    setSharedPreferencesMock({'isDarkMode': false});
    await SharedPreferenceService().init();
    await installFakePathProvider();
    setAssetBundleMock(_testWords);
    AppDatabase.setSingleton(AppDatabase.forTesting(NativeDatabase.memory()));
    await WordleService().init();
  });

  tearDown(() async {
    await AppDatabase().close();
    AppDatabase.resetSingleton();
    setAssetBundleMock(null);
  });

  testWidgets('renders the practice title, board and new-word action',
      (tester) async {
    await tester.pumpWidget(makeTestAppRaw(child: const PracticePage()));
    await tester.pumpAndSettle();

    expect(find.text('Practice'), findsOneWidget);
    expect(find.byType(GameBoard), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    // No settings gear on the practice page.
    expect(find.byIcon(Icons.settings), findsNothing);
  });

  testWidgets('the new-word action can be tapped without error',
      (tester) async {
    await tester.pumpWidget(makeTestAppRaw(child: const PracticePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
    expect(find.byType(GameBoard), findsOneWidget);
  });
}
