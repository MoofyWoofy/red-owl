import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart'
    show BoolFamilyProviderIDs, SharedPreferencesKeys;
import 'package:red_owl/routes/settings/widgets/shared.dart' show SwitchItem;
import 'package:red_owl/riverpod/shared.dart' show boolFamilyProvider;
import 'package:red_owl/util/shared.dart'
    show Localization, NotificationService, SharedPreferenceService;

/// Default reminder time (8 PM) when the user hasn't chosen one.
const TimeOfDay _defaultReminderTime = TimeOfDay(hour: 20, minute: 0);

/// The opt-in daily-reminder setting: a toggle (off by default) plus a time
/// row shown when enabled.
///
/// Enabling requests the notification permission and schedules a repeating
/// local notification via [NotificationService]; disabling cancels it. The
/// chosen time is stored as a `HH:mm` string.
class ReminderSetting extends ConsumerWidget {
  const ReminderSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(boolFamilyProvider(
      id: BoolFamilyProviderIDs.reminderEnabled,
      sharedPrefsKey: SharedPreferencesKeys.reminderEnabled,
    ));
    final time = _storedTime();

    return Column(
      children: [
        SwitchItem(
          title: context.l10n.dailyReminder,
          icon: Icons.notifications_outlined,
          boolProviderId: BoolFamilyProviderIDs.reminderEnabled,
          sharedPrefsKey: SharedPreferencesKeys.reminderEnabled,
          callback: (value) => _setEnabled(context, ref, value),
        ),
        if (enabled)
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(context.l10n.reminderTime),
            trailing: Text(time.format(context)),
            onTap: () => _pickTime(context, ref, time),
          ),
      ],
    );
  }

  /// Reads the stored reminder time, or the default if unset/malformed.
  TimeOfDay _storedTime() {
    final raw =
        SharedPreferenceService().getString(SharedPreferencesKeys.reminderTime);
    if (raw == null) return _defaultReminderTime;
    final parts = raw.split(':');
    final hour = int.tryParse(parts.first);
    final minute = parts.length > 1 ? int.tryParse(parts[1]) : null;
    if (hour == null || minute == null) return _defaultReminderTime;
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Persists the boolean and schedules or cancels the reminder.
  Future<void> _setEnabled(
      BuildContext context, WidgetRef ref, bool value) async {
    final notifier = ref.read(boolFamilyProvider(
      id: BoolFamilyProviderIDs.reminderEnabled,
      sharedPrefsKey: SharedPreferencesKeys.reminderEnabled,
    ).notifier);

    if (!value) {
      await NotificationService().cancelReminder();
      notifier.updateBoolean(SharedPreferencesKeys.reminderEnabled, false);
      return;
    }

    // Enabling — require the OS notification permission first.
    final granted = await NotificationService().requestPermission();
    if (!granted) return; // Leave the toggle off if permission was denied.

    final time = _storedTime();
    if (!context.mounted) return;
    await NotificationService().scheduleDailyReminder(
      hour: time.hour,
      minute: time.minute,
      title: context.l10n.appName,
      body: context.l10n.reminderBody,
    );
    notifier.updateBoolean(SharedPreferencesKeys.reminderEnabled, true);
  }

  /// Lets the user pick a new reminder time and reschedules.
  Future<void> _pickTime(
      BuildContext context, WidgetRef ref, TimeOfDay current) async {
    final picked =
        await showTimePicker(context: context, initialTime: current);
    if (picked == null) return;

    final value =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    SharedPreferenceService()
        .setString(SharedPreferencesKeys.reminderTime, value);

    if (!context.mounted) return;
    await NotificationService().scheduleDailyReminder(
      hour: picked.hour,
      minute: picked.minute,
      title: context.l10n.appName,
      body: context.l10n.reminderBody,
    );
    // Rebuild so the new time shows.
    ref.invalidate(boolFamilyProvider(
      id: BoolFamilyProviderIDs.reminderEnabled,
      sharedPrefsKey: SharedPreferencesKeys.reminderEnabled,
    ));
  }
}
