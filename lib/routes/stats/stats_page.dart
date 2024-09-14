import 'package:flutter/material.dart';
import 'package:red_owl/routes/stats/widgets/shared.dart';
import 'package:red_owl/widgets/shared.dart' show appBar;

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Stats',
        context: context,
        showSettingIcon: true,
      ),
      body: const Column(
        children: [
          StatsHeading(text: 'Statistics'),
          StatsInfo(),
          StatsHeading(text: 'Guess Distribution'),
          StatsGraph(),
          StatsHeading(text: 'History'),
          Expanded(
            child: History(),
          )
        ],
      ),
    );
  }
}
