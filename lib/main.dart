import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_owl/riverpod/shared.dart' show boolFamilyProvider;
import 'package:red_owl/l10n/app_localizations.dart';
import 'package:red_owl/routes/shared.dart';
import 'package:red_owl/config/shared.dart'
    show
        lightTheme,
        darkTheme,
        lightThemeHighContrast,
        darkThemeHighContrast,
        SharedPreferencesKeys,
        BoolFamilyProviderIDs;
import 'package:red_owl/util/shared.dart'
    show Localization, SharedPreferenceService, WordleService;
import 'package:red_owl/widgets/shared.dart' show Logo, appBar;

/// Application entry point.
///
/// Initialises services that must be ready before the first frame:
/// 1. [SharedPreferenceService] — loads the persisted key-value store so the
///    dark-mode toggle and grid state are available synchronously in [build].
/// 2. [WordleService] — resolves today's word from the active word list.
///
/// Wraps the widget tree in a [ProviderScope] so all Riverpod providers are
/// accessible throughout the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceService().init();
  await WordleService().init();
  runApp(const ProviderScope(child: App()));
}

/// Root widget that wires up theming and localization.
///
/// Watches the [boolFamilyProvider] for dark-mode so the whole app
/// re-themes reactively whenever the user toggles the setting in [SettingsPage].
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.watch(
      boolFamilyProvider(
      id: BoolFamilyProviderIDs.isDarkMode,
      sharedPrefsKey: SharedPreferencesKeys.isDarkMode,
    ));
    bool isColorBlindMode = ref.watch(
      boolFamilyProvider(
      id: BoolFamilyProviderIDs.isColorBlindMode,
      sharedPrefsKey: SharedPreferencesKeys.isColorBlindMode,
    ));

    return MaterialApp(
      title: 'Red Owl',
      // Pick the standard or color-blind/high-contrast palette for each
      // brightness, then let themeMode choose between light and dark.
      theme: isColorBlindMode ? lightThemeHighContrast : lightTheme,
      darkTheme: isColorBlindMode ? darkThemeHighContrast : darkTheme,
      // Switch between light and dark theme based on the user's preference.
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(title: 'Red Owl'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

/// The landing screen shown immediately after the splash.
///
/// Provides two navigation paths:
/// - **Daily** → [WordlePage] (slides in from the right).
/// - **Stats** → [StatsPage] (slides up from the bottom).
///
/// Both transitions use a custom [PageRouteBuilder] with a [SlideTransition]
/// so the navigation direction communicates the spatial relationship between
/// screens.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  /// The string displayed in the [AppBar] title.
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
              // App logo centered above the action buttons.
              const Logo(),
              Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // WordlePage slides in from the right (Offset(1.0, 0.0)).
                      Navigator.of(context).push(_createRouteTo(
                          const WordlePage(), const Offset(1.0, 0.0)));
                    },
                    label: Text(context.l10n.daily),
                    icon: const Icon(Icons.calendar_today),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      // StatsPage slides up from the bottom (Offset(0.0, 1.0)).
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

  /// Creates a [PageRouteBuilder] that slides [page] in from [begin].
  ///
  /// [begin] is an [Offset] in fractional page units:
  /// - `Offset(1.0, 0.0)` slides from the right.
  /// - `Offset(0.0, 1.0)` slides from the bottom.
  ///
  /// Uses [Curves.easeIn] for a snappy but not abrupt feel.
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
