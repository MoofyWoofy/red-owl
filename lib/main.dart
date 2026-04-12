import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/riverpod/shared.dart' show boolFamilyProvider;
import 'package:red_owl/l10n/app_localizations.dart';
import 'package:red_owl/routes/shared.dart';
import 'package:red_owl/config/shared.dart'
    show lightTheme, darkTheme, SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/util/shared.dart'
    show Localization, SharedPreferenceService, WordleService;
import 'package:red_owl/widgets/shared.dart' show Logo, appBar;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceService().init();
  await WordleService().init();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.watch(
      boolFamilyProvider(
      id: BoolFamilyProviderIDs.isDarkMode,
      sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
    ));

    return MaterialApp(
      title: 'Red Owl',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(title: 'Red Owl'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: title, showSettingIcon: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Logo(),
              Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // daily word from API
                      Navigator.of(context).push(_createRouteTo(
                          const WordlePage(), const Offset(1.0, 0.0)));
                    },
                    label: Text(context.l10n.daily),
                    icon: const Icon(Icons.calendar_today),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(_createRouteTo(
                          const StatsPage(), const Offset(0.0, 1.0)));
                    },
                    label: Text(context.l10n.stats),
                    icon: const Icon(Icons.bar_chart),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRouteTo(Widget page, Offset begin) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.easeIn;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
