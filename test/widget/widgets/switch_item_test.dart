// Widget tests for the SwitchItem widget.
//
// Verifies: title and icon rendering, SwitchListTile presence, default value,
// toggle state update via provider, and custom callback invocation.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/routes/settings/widgets/shared.dart' show SwitchItem;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  group('SwitchItem', () {
    setUp(() async {
      setSharedPreferencesMock({
        'isDarkMode': false,
        'useCustomList': false,
      });
      await SharedPreferenceService().init();
    });

    testWidgets('renders title and icon', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: const SwitchItem(
          title: 'Dark Mode',
          icon: Icons.dark_mode,
          boolProviderId: BoolFamilyProviderIDs.isDarkMode,
          sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('renders a SwitchListTile', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: const SwitchItem(
          title: 'Test Switch',
          icon: Icons.toggle_on,
          boolProviderId: BoolFamilyProviderIDs.isDarkMode,
          sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('switch starts in off position for false default', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: const SwitchItem(
          title: 'Off by default',
          icon: Icons.toggle_off,
          boolProviderId: BoolFamilyProviderIDs.useCustomList,
          sharedPrefsKey: SharedPreferencesKeys.useCustomList,
        ),
      ));
      await tester.pumpAndSettle();
      final switchTile =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(switchTile.value, false);
    });

    testWidgets('toggling the switch updates the state', (tester) async {
      await tester.pumpWidget(makeTestApp(
        child: const SwitchItem(
          title: 'Toggle me',
          icon: Icons.toggle_on,
          boolProviderId: BoolFamilyProviderIDs.useCustomList,
          sharedPrefsKey: SharedPreferencesKeys.useCustomList,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      final switchTile =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(switchTile.value, true);
    });

    testWidgets('uses custom callback when provided', (tester) async {
      bool callbackCalled = false;
      bool? callbackValue;

      await tester.pumpWidget(makeTestApp(
        child: SwitchItem(
          title: 'Custom callback',
          icon: Icons.settings,
          boolProviderId: BoolFamilyProviderIDs.useCustomList,
          sharedPrefsKey: SharedPreferencesKeys.useCustomList,
          callback: (value) {
            callbackCalled = true;
            callbackValue = value;
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(callbackCalled, true);
      expect(callbackValue, true);
    });
  });
}
