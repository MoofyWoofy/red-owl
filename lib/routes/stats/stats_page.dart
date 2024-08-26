import 'package:flutter/material.dart';
import 'package:red_owl/widgets/shared.dart' show appBar;

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Stats', context: context),
      body: const Placeholder(),
    );
  }
}
