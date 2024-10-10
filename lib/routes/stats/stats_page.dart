import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart'
    show HistoryColors, SharedPreferencesKeys;
import 'package:red_owl/routes/stats/widgets/shared.dart';
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, getWinRate;
import 'package:red_owl/widgets/shared.dart' show HelpIconButton, appBar;
import 'package:share_plus/share_plus.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Stats',
        context: context,
        showSettingIcon: true,
        widgets: [
          IconButton(
            onPressed: () {
              // Get Stats from shared Prefs, if null default is ['0', '0', '0', '0']
              final [gamesPlayed, gamesWon, _, maxStreak] =
                  SharedPreferenceService()
                          .getStringList(SharedPreferencesKeys.statsData) ??
                      ['0', '0', '0', '0'];

              final winRate = getWinRate(gamesWon, gamesPlayed);

              final String shareText = """
Check out my Wordle! stats!
🔠 $gamesWon Words Guessed
🏆 $winRate% Win Rate
🔥 $maxStreak Max Streak
""";

              Share.share(shareText);
            },
            icon: const Icon(Icons.share),
          ),
          HelpIconButton(
            body: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Green',
                      style: TextStyle(
                          backgroundColor: Theme.of(context)
                              .extension<HistoryColors>()!
                              .green),
                    ),
                    TextSpan(
                      text: ' means you guessed correctly.',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Yellow',
                      style: TextStyle(
                          backgroundColor: Theme.of(context)
                              .extension<HistoryColors>()!
                              .yellow),
                    ),
                    TextSpan(
                      text: ' means the game was incomplete.',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Red',
                      style: TextStyle(
                          backgroundColor: Theme.of(context)
                              .extension<HistoryColors>()!
                              .red),
                    ),
                    TextSpan(
                      text: " means you didn't guess the word.",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const Text('Example:'),
              const SizedBox(height: 5),
              HistoryTile(
                date: DateTime(2024, 5, 23),
                word: 'BURNT',
                backgroundColor:
                    Theme.of(context).extension<HistoryColors>()!.green!,
              ),
              const SizedBox(height: 8),
              HistoryTile(
                date: DateTime(2024, 5, 22),
                word: 'WHISK',
                backgroundColor:
                    Theme.of(context).extension<HistoryColors>()!.yellow!,
              ),
              const SizedBox(height: 8),
              HistoryTile(
                date: DateTime(2024, 5, 21),
                word: 'IDEAS',
                backgroundColor:
                    Theme.of(context).extension<HistoryColors>()!.red!,
              ),
            ],
          ),
        ],
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
