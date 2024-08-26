import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/riverpod/shared.dart' show boolFamilyNotifierProvider;
import 'package:red_owl/routes/shared.dart';
import 'package:red_owl/config/shared.dart'
    show lightTheme, darkTheme, SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceService().init();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.watch(boolFamilyNotifierProvider(
      id: 'isDarkMode'.hashCode,
      sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
    ));

    return MaterialApp(
      title: 'Red Owl',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(title: 'Red Owl'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const Image(
                  image: AssetImage('assets/icon.png'),
                  height: 150,
                  width: 150,
                ),
              ),
              Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // daily word from API
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const WordlePage(gameType: "Daily")),
                      );
                    },
                    label: const Text('Daily'),
                    icon: const Icon(Icons.calendar_today),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      );
                    },
                    label: const Text('Status'),
                    icon: const Icon(Icons.bar_chart),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
