// Widget tests for the HintButton on the daily game page.
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/routes/shared.dart' show WordlePage;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, WordleService, dateToString;

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

  testWidgets('reveals the first letter of the answer', (tester) async {
    await tester.pumpWidget(makeTestAppRaw(child: const WordlePage()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);

    await tester.tap(find.byIcon(Icons.lightbulb_outline));
    // showSnackBar defers via a post-frame callback.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    final answer = WordleService().wordOfTheDay;
    expect(find.text('Hint: letter 1 is ${answer[0]}'), findsOneWidget);

    // The hint was consumed and persisted for today.
    expect(
      SharedPreferenceService()
          .getString(SharedPreferencesKeys.hintUsedDate),
      isNotNull,
    );
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });

  testWidgets('reports the hint is spent when already used today',
      (tester) async {
    // Seed today's date so no hint is available from the start.
    setSharedPreferencesMock({
      'isDarkMode': false,
      SharedPreferencesKeys.hintUsedDate.name: dateToString(DateTime.now()),
    });
    await SharedPreferenceService().init();

    await tester.pumpWidget(makeTestAppRaw(child: const WordlePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.lightbulb_outline));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text("You've already used today's hint"), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
