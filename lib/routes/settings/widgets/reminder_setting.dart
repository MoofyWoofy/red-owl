import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/config/shared.dart'
    show BoolFamilyProviderIDs, SharedPreferencesKeys;
import 'package:red_owl/routes/settings/widgets/shared.dart' show SwitchItem;
import 'package:red_owl/riverpod/shared.dart'
    show boolFamilyProvider, reminderTimeProvider;
import 'package:red_owl/util/shared.dart'
    show Localization, NotificationService, hasPlayedDailyToday, showSnackBar;

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
    // Watch the time so the row updates immediately when the user picks a new
    // one (rather than only after a restart).
    final time = ref.watch(reminderTimeProvider);

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

    // Best-effort: ask for exact-alarm access so the reminder fires to the
    // minute. If declined it still works via inexact scheduling.
    await NotificationService().requestExactAlarmPermission();

    final time = ref.read(reminderTimeProvider);
    if (!context.mounted) return;
    try {
      await NotificationService().scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
        title: context.l10n.appName,
        body: context.l10n.reminderBody,
        // If today's game is already finished, start tomorrow.
        skipToday: hasPlayedDailyToday(),
      );
    } catch (_) {
      // Scheduling can fail at the platform layer (e.g. a notification icon
      // resource missing from the build). Surface it and leave the toggle off
      // rather than silently doing nothing.
      if (context.mounted) {
        showSnackBar(context, context.l10n.reminderError, 3);
      }
      return;
    }
    notifier.updateBoolean(SharedPreferencesKeys.reminderEnabled, true);
  }

  /// Lets the user pick a new reminder time and reschedules.
  Future<void> _pickTime(
      BuildContext context, WidgetRef ref, TimeOfDay current) async {
    final picked =
        await showTimePicker(context: context, initialTime: current);
    if (picked == null) return;

    // Persist + update the notifier so the time row rebuilds immediately.
    ref.read(reminderTimeProvider.notifier).setTime(picked);

    if (!context.mounted) return;
    await NotificationService().scheduleDailyReminder(
      hour: picked.hour,
      minute: picked.minute,
      title: context.l10n.appName,
      body: context.l10n.reminderBody,
      // Keep skipping today if the player has already finished today's game.
      skipToday: hasPlayedDailyToday(),
    );
  }
}
