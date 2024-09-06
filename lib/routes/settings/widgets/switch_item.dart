import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/riverpod/shared.dart' show boolFamilyNotifierProvider;
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;

class SwitchItem extends ConsumerStatefulWidget {
  const SwitchItem({
    super.key,
    required this.title,
    required this.icon,
    required this.boolProviderId,
    required this.sharedPrefsKey,
    this.callback,
  });
  final String title;
  final IconData icon;
  final BoolFamilyProviderIDs boolProviderId;
  final SharedPreferencesKeys sharedPrefsKey;
  final ValueChanged<bool>? callback;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SwitchItemState();
}

class _SwitchItemState extends ConsumerState<SwitchItem> {

  @override
  Widget build(BuildContext context) {
    bool toggle = ref.watch(boolFamilyNotifierProvider(
      id: widget.boolProviderId,
      sharedPrefsKey: widget.sharedPrefsKey,
    ));
    return SwitchListTile(
      title: Text(widget.title),
      value: toggle,
      secondary: Icon(widget.icon),
      controlAffinity: ListTileControlAffinity.platform,
      onChanged: widget.callback ??
          (value) {
        ref
            .read(boolFamilyNotifierProvider(
              id: widget.boolProviderId,
              sharedPrefsKey: widget.sharedPrefsKey,
            ).notifier)
            .updateBoolean(widget.sharedPrefsKey, value);
      },
    );
  }
}
