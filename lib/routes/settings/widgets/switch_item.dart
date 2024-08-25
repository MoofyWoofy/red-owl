import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchItem extends ConsumerStatefulWidget {
  const SwitchItem({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final IconData icon;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SwitchItemState();
}

class _SwitchItemState extends ConsumerState<SwitchItem> {
  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(widget.title),
        value: _toggle,
        secondary: Icon(widget.icon),
        controlAffinity: ListTileControlAffinity.platform,
        onChanged: (value) {
          setState(() {
            _toggle = value;
          });
        });
  }
}
