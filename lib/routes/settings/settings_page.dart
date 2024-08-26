import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/routes/settings/widgets/shared.dart' show SwitchItem;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              SwitchItem(
                title: 'Dark Mode',
                icon: Icons.contrast,
                boolProviderId: 'isDarkMode'.hashCode,
                sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
              ),
              const SizedBox(height: 20),
              SwitchItem(
                title: 'Use custom word list',
                icon: Icons.list_alt,
                boolProviderId: 'useCustomList'.hashCode,
                sharedPrefsKey: SharedPreferencesKeys.useCustomList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
