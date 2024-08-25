import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/routes/settings/widgets/shared.dart' show SwitchItem;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SwitchItem(
                title: 'Dark Mode',
                icon: Icons.contrast,
              ),
              const SizedBox(height: 20),
              const SwitchItem(
                title: 'Use custom word list',
                icon: Icons.list_alt,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
