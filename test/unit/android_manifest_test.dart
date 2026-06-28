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

    test('declares SCHEDULE_EXACT_ALARM so reminders can fire to the minute',
        () {
      expect(manifest, contains('android.permission.SCHEDULE_EXACT_ALARM'));
    });
  });

  group('notification icons', () {
    const densities = ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi'];

    for (final d in densities) {
      test('drawable-$d has the reminder small and large icons', () {
        final res = 'android/app/src/main/res/drawable-$d';
        expect(File('$res/ic_stat_reminder.png').existsSync(), isTrue,
            reason: 'monochrome status-bar icon used as AndroidNotificationDetails.icon');
        expect(File('$res/ic_notification_large.png').existsSync(), isTrue,
            reason: 'full-color logo used as the notification large icon');
      });
    }
  });

  // The reminder icons are referenced only by name string at runtime, so the
  // release resource shrinker treats them as unused and strips them — which
  // makes scheduleDailyReminder throw PlatformException(invalid_icon) and the
  // reminder toggle silently fail. res/raw/keep.xml prevents that. This only
  // reproduces in a real release build, so guard the keep rule here.
  group('res/raw/keep.xml', () {
    late String keep;

    setUpAll(() {
      final file = File('android/app/src/main/res/raw/keep.xml');
      expect(file.existsSync(), isTrue,
          reason: 'keep.xml must exist so the resource shrinker retains the '
              'notification icons in release builds');
      keep = file.readAsStringSync();
    });

    test('keeps ic_stat_reminder from being shrunk out of release builds', () {
      expect(keep, contains('@drawable/ic_stat_reminder'),
          reason: 'without this keep rule the status-bar icon is stripped and '
              'enabling the daily reminder throws invalid_icon in release');
    });

    test('keeps ic_notification_large from being shrunk out of release builds',
        () {
      expect(keep, contains('@drawable/ic_notification_large'));
    });
  });
}
