import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/routes/settings/widgets/shared.dart' show SwitchItem;
import 'package:red_owl/widgets/shared.dart' show appBar;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: 'Settings',
        showSettingsPage: false,
        automaticallyImplyLeading: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SwitchItem(
                title: 'Dark Mode',
                icon: Icons.contrast,
                boolProviderId: BoolFamilyProviderIDs.isDarkMode,
                sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
              ),
              SizedBox(height: 20),
              SwitchItem(
                title: 'Use custom word list',
                icon: Icons.list_alt,
                boolProviderId: BoolFamilyProviderIDs.useCustomList,
                sharedPrefsKey: SharedPreferencesKeys.useCustomList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
