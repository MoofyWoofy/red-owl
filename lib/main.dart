import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:red_owl/routes/shared.dart';
import 'package:red_owl/config/shared.dart' show CustomColors;

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Red Owl',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red, brightness: Brightness.dark),
          brightness: Brightness.dark,
          extensions: const <ThemeExtension<dynamic>>[
            CustomColors(
              initial: Color.fromRGBO(129, 131, 132, 1),
              yellow: Color.fromRGBO(129, 131, 132, 1),
              green: Color.fromRGBO(83, 141, 78, 1),
              notInWord: Color.fromRGBO(58, 58, 60, 1),
              borderInactive: Color.fromRGBO(58, 58, 60, 1),
              borderActive: Color.fromRGBO(86, 87, 88, 1),
            )
          ]
      ),
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
                            builder: (context) => const StatsPage()),
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
