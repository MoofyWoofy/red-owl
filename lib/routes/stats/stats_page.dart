import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/routes/stats/widgets/shared.dart';
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, getWinRate;
import 'package:red_owl/widgets/shared.dart' show appBar;
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
          )
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
