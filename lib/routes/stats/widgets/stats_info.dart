import 'package:flutter/material.dart';
import 'package:red_owl/routes/stats/widgets/shared.dart';

class StatsInfo extends StatelessWidget {
  const StatsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StatsText(
                text: '59',
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: '85',
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: '4',
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: '17',
                isTopText: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StatsText(
                text: 'Played',
                isTopText: false,
              ),
            ),
            Expanded(
              child: StatsText(
                text: 'Win %',
                isTopText: false,
              ),
            ),
            Expanded(
              child: StatsText(
                text: 'Current Streak',
                isTopText: false,
              ),
            ),
            Expanded(
              child: StatsText(
                text: 'Max Streak',
                isTopText: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
