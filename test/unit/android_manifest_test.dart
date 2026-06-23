// Guards the Android manifest configuration that scheduled daily reminders
// depend on.
//
// flutter_local_notifications (v19) does NOT declare its broadcast receivers in
// the plugin's own manifest, so they must be declared in the app manifest.
// Without ScheduledNotificationReceiver, the reminder alarm still fires but no
// notification is ever posted — the regression this test exists to catch.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AndroidManifest.xml', () {
    late String manifest;

    setUpAll(() {
      final file = File('android/app/src/main/AndroidManifest.xml');
      assert(file.existsSync(),
          'Run this test from the package root; manifest not found at ${file.path}');
      manifest = file.readAsStringSync();
    });

    test('declares the flutter_local_notifications scheduled receiver', () {
      expect(
        manifest,
        contains(
            'com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver'),
        reason: 'Scheduled notifications post via this receiver; without it the '
            'daily reminder alarm fires but nothing is shown.',
      );
    });

    test('declares the boot receiver so reminders survive a reboot', () {
      expect(
        manifest,
        contains(
            'com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver'),
      );
      expect(manifest, contains('android.intent.action.BOOT_COMPLETED'));
    });

    test('keeps the notification permissions required by the reminder', () {
      expect(manifest, contains('android.permission.POST_NOTIFICATIONS'));
      expect(manifest, contains('android.permission.RECEIVE_BOOT_COMPLETED'));
    });
  });
}
