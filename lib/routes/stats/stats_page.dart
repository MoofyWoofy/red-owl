import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart'
    show HistoryColors, SharedPreferencesKeys;
import 'package:red_owl/routes/stats/widgets/shared.dart';
import 'package:red_owl/util/shared.dart'
    show Localization, SharedPreferenceService, getWinRate;
import 'package:red_owl/widgets/shared.dart' show HelpIconButton, appBar;
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

/// The Statistics page reachable from the Home screen or from any settings
/// gear action.
///
/// Layout (top-to-bottom):
/// 1. **AppBar** with a share icon (exports a text summary) and a help icon
///    (explains the history row color coding).
/// 2. **"Statistics"** heading + [StatsInfo] — four key metrics.
/// 3. **"Guess Distribution"** heading + [StatsGraph] — bar chart.
/// 4. **"History"** heading + [History] (Expanded) — scrollable game log.
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: context.l10n.stats,
        context: context,
        showSettingIcon: true,
        widgets: [
          // ── Share button ─────────────────────────────────────────────────
          IconButton(
            tooltip: context.l10n.share,
            onPressed: () {
              // Build a short shareable text from the stored stats.
              final [gamesPlayed, gamesWon, _, maxStreak] =
                  SharedPreferenceService()
                          .getStringList(SharedPreferencesKeys.statsData) ??
                      ['0', '0', '0', '0'];

              final winRate = getWinRate(gamesWon, gamesPlayed);

              final String shareText = """
${context.l10n.checkOutWordleStats}!
🔠 $gamesWon ${context.l10n.wordsGuessed}
🏆 $winRate% ${context.l10n.winRate}
🔥 $maxStreak ${context.l10n.maxStreak}
""";

              SharePlus.instance.share(ShareParams(text: shareText));
            },
            icon: const Icon(Icons.share),
          ),
          // ── Help button — explains history row colors ─────────────────────
          HelpIconButton(
            body: [
              // Green row legend.
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.l10n.green,
                      style: TextStyle(
                          backgroundColor: Theme.of(context)
                              .extension<HistoryColors>()!
                              .green),
                    ),
                    TextSpan(
                      text: ' ${context.l10n.helpGuessCorrect}.',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Yellow row legend.
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.l10n.yellow,
                      style: TextStyle(
                          backgroundColor: Theme.of(context)
                              .extension<HistoryColors>()!
                              .yellow),
                    ),
                    TextSpan(
                      text: ' ${context.l10n.helpGameIncomplete}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Red row legend.
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: context.l10n.red,
                      style: TextStyle(
                          backgroundColor: Theme.of(context)
                              .extension<HistoryColors>()!
                              .red),
                    ),
                    TextSpan(
                      text: " ${context.l10n.helpGuessWrong}.",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              // Example history tiles showing each color in context.
              Text('${context.l10n.example}:'),
              const SizedBox(height: 5),
              HistoryTile(
                date: DateTime(2024, 5, 23),
                word: context.l10n.burnt,
                backgroundColor:
                    Theme.of(context).extension<HistoryColors>()!.green!,
              ),
              const SizedBox(height: 8),
              HistoryTile(
                date: DateTime(2024, 5, 22),
                word: context.l10n.whisk,
                backgroundColor:
                    Theme.of(context).extension<HistoryColors>()!.yellow!,
              ),
              const SizedBox(height: 8),
              HistoryTile(
                date: DateTime(2024, 5, 21),
                word: context.l10n.ideas,
                backgroundColor:
                    Theme.of(context).extension<HistoryColors>()!.red!,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          StatsHeading(text: context.l10n.statistics),
          const StatsInfo(),
          StatsHeading(text: context.l10n.guessDistribution),
          const StatsGraph(),
          StatsHeading(text: context.l10n.history),
          // History list takes all remaining vertical space.
          const Expanded(
            child: History(),
          )
        ],
      ),
    );
  }
}
