// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_time_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier holding the daily-reminder time as a [TimeOfDay].
///
/// Persisted under [SharedPreferencesKeys.reminderTime] as an `HH:mm` 24-hour
/// string. The `ReminderSetting` widget watches this so the displayed time
/// updates immediately when the user picks a new one, rather than only after a
/// restart.

@ProviderFor(ReminderTimeNotifier)
final reminderTimeProvider = ReminderTimeNotifierProvider._();

/// Riverpod notifier holding the daily-reminder time as a [TimeOfDay].
///
/// Persisted under [SharedPreferencesKeys.reminderTime] as an `HH:mm` 24-hour
/// string. The `ReminderSetting` widget watches this so the displayed time
/// updates immediately when the user picks a new one, rather than only after a
/// restart.
final class ReminderTimeNotifierProvider
    extends $NotifierProvider<ReminderTimeNotifier, TimeOfDay> {
  /// Riverpod notifier holding the daily-reminder time as a [TimeOfDay].
  ///
  /// Persisted under [SharedPreferencesKeys.reminderTime] as an `HH:mm` 24-hour
  /// string. The `ReminderSetting` widget watches this so the displayed time
  /// updates immediately when the user picks a new one, rather than only after a
  /// restart.
  ReminderTimeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderTimeNotifierHash();

  @$internal
  @override
  ReminderTimeNotifier create() => ReminderTimeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimeOfDay value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimeOfDay>(value),
    );
  }
}

String _$reminderTimeNotifierHash() =>
    r'28208338371a0c5a8508a0a45df4a7be250d1154';

/// Riverpod notifier holding the daily-reminder time as a [TimeOfDay].
///
/// Persisted under [SharedPreferencesKeys.reminderTime] as an `HH:mm` 24-hour
/// string. The `ReminderSetting` widget watches this so the displayed time
/// updates immediately when the user picks a new one, rather than only after a
/// restart.

abstract class _$ReminderTimeNotifier extends $Notifier<TimeOfDay> {
  TimeOfDay build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimeOfDay, TimeOfDay>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimeOfDay, TimeOfDay>,
              TimeOfDay,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
