import 'package:flutter/material.dart' show TimeOfDay;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

part 'reminder_time_notifier.g.dart';

/// Default daily-reminder time (8 PM) used when the user has not chosen one.
const TimeOfDay defaultReminderTime = TimeOfDay(hour: 20, minute: 0);

/// Riverpod notifier holding the daily-reminder time as a [TimeOfDay].
///
/// Persisted under [SharedPreferencesKeys.reminderTime] as an `HH:mm` 24-hour
/// string. The `ReminderSetting` widget watches this so the displayed time
/// updates immediately when the user picks a new one, rather than only after a
/// restart.
@riverpod
class ReminderTimeNotifier extends _$ReminderTimeNotifier {
  @override
  TimeOfDay build() {
    final raw =
        SharedPreferenceService().getString(SharedPreferencesKeys.reminderTime);
    return parseReminderTime(raw) ?? defaultReminderTime;
  }

  /// Persists [time] as an `HH:mm` string and updates the active value so
  /// watchers rebuild.
  void setTime(TimeOfDay time) {
    final value =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    SharedPreferenceService()
        .setString(SharedPreferencesKeys.reminderTime, value);
    state = time;
  }
}

/// Parses an `HH:mm` string into a [TimeOfDay], or returns `null` when [raw] is
/// absent or malformed.
TimeOfDay? parseReminderTime(String? raw) {
  if (raw == null) return null;
  final parts = raw.split(':');
  final hour = int.tryParse(parts.first);
  final minute = parts.length > 1 ? int.tryParse(parts[1]) : null;
  if (hour == null || minute == null) return null;
  return TimeOfDay(hour: hour, minute: minute);
}
