import 'dart:async' show FutureOr, unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/riverpod/shared.dart' show boolFamilyProvider;
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;

/// A labeled toggle row that synchronises with a [BoolFamilyNotifier] provider
/// and (optionally) executes a custom side-effect callback.
///
/// Renders a [SwitchListTile] with:
/// - An icon on the leading side.
/// - A text title.
/// - A platform-adaptive toggle switch.
///
/// When [callback] is provided it is used as the [SwitchListTile.onChanged]
/// handler, giving the caller full control (e.g. to show a confirmation dialog
/// before committing the change). When [callback] is null the notifier's
/// [updateBoolean] method is called directly.
class SwitchItem extends ConsumerStatefulWidget {
  const SwitchItem({
    super.key,
    /// Text label shown next to the toggle.
    required this.title,
    /// Leading icon that visually identifies the setting.
    required this.icon,
    /// Riverpod family ID used to look up the correct [BoolFamilyNotifier].
    required this.boolProviderId,
    /// SharedPreferences key persisted alongside the in-memory state.
    required this.sharedPrefsKey,
    /// Optional custom handler. When provided this replaces the default
    /// [BoolFamilyNotifier.updateBoolean] call.
    this.callback,
  });

  /// Display label for the setting.
  final String title;

  /// Leading icon for the list tile.
  final IconData icon;

  /// Identifies which [BoolFamilyNotifier] instance to use.
  final BoolFamilyProviderIDs boolProviderId;

  /// The SharedPreferences key that backs this toggle.
  final SharedPreferencesKeys sharedPrefsKey;

  /// Custom toggle callback (e.g. to show a confirmation dialog first).
  ///
  /// May be asynchronous. It is invoked through [Future.sync] so that a
  /// returned future is actually observed — passing an `async` closure to a
  /// plain `ValueChanged<bool>` used to discard it, turning any failure into an
  /// unhandled async error. Callbacks remain responsible for reporting their
  /// own failures to the user; anything that escapes is swallowed here rather
  /// than taking down the zone.
  final FutureOr<void> Function(bool)? callback;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SwitchItemState();
}

class _SwitchItemState extends ConsumerState<SwitchItem> {

  @override
  Widget build(BuildContext context) {
    // Watch the provider so the switch rebuilds when the value changes externally.
    bool toggle = ref.watch(boolFamilyProvider(
      id: widget.boolProviderId,
      sharedPrefsKey: widget.sharedPrefsKey,
    ));

    return SwitchListTile(
      title: Text(widget.title),
      value: toggle,
      secondary: Icon(widget.icon),
      // Place the switch on the platform-default side (right on most platforms).
      controlAffinity: ListTileControlAffinity.platform,
      onChanged: (value) {
        final callback = widget.callback;
        if (callback == null) {
          // Default: immediately persist and update state through the notifier.
          ref
              .read(boolFamilyProvider(
                id: widget.boolProviderId,
                sharedPrefsKey: widget.sharedPrefsKey,
              ).notifier)
              .updateBoolean(widget.sharedPrefsKey, value);
          return;
        }
        unawaited(
          Future<void>.sync(() => callback(value)).catchError((Object _) {}),
        );
      },
    );
  }
}
