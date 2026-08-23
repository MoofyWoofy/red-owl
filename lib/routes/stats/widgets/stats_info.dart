import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/routes/stats/widgets/shared.dart';
import 'package:red_owl/util/shared.dart'
    show
        Localization,
        SharedPreferenceService,
        getAverageGuesses,
        guessDistributionLength,
        normalizeCounters,
        statsDataLength,
        getWinRate;

/// Displays the four top-level statistics in a two-row grid:
///
/// ```
/// [ Played ]  [ Win% ]  [ Streak ]  [ Max Streak ]
/// [ played ]  [  win ]  [ current ] [  maxStreak ]
/// ```
///
/// The values are read directly from SharedPreferences in [initState] so
/// they are fixed for the lifetime of the widget (the Stats page does not
/// need live updates).
class StatsInfo extends StatefulWidget {
  const StatsInfo({super.key});

  @override
  State<StatsInfo> createState() => _StatsInfoState();
}

class _StatsInfoState extends State<StatsInfo> {
  /// `[gamesPlayed, gamesWon, currentStreak, maxStreak]` as string values.
  late List<String> arr;

  /// Average number of guesses per win, derived from the guess distribution.
  late String avgGuesses;

  @override
  void initState() {
    super.initState();
    // Normalise rather than defaulting only on null: the stored array can also
    // be the wrong length (an install that ran an older build, or a partial
    // write), and the `arr[3]` reads below would then throw a RangeError.
    arr = normalizeCounters(
      SharedPreferenceService().getStringList(SharedPreferencesKeys.statsData),
      statsDataLength,
    );
    avgGuesses = getAverageGuesses(
      normalizeCounters(
        SharedPreferenceService()
            .getStringList(SharedPreferencesKeys.guessDistribution),
        guessDistributionLength,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Top row: numeric values ───────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StatsText(
                text: arr[0], // games played
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                // Win rate derived from wins/played (avoids divide-by-zero).
                text: getWinRate(arr[1], arr[0]),
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: arr[2], // current streak
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: arr[3], // max streak
                isTopText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // ── Bottom row: labels ────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StatsText(
                text: context.l10n.played,
                isTopText: false,
              ),
            ),
            Expanded(
              child: StatsText(
                text: context.l10n.win,
                isTopText: false,
              ),
            ),
            Expanded(
              child: StatsText(
                text: context.l10n.currentStreak,
                isTopText: false,
              ),
            ),
            Expanded(
              child: StatsText(
                text: context.l10n.maxStreak,
                isTopText: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // ── Secondary row: wins count and average guesses per win ─────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StatsText(
                text: arr[1], // games won
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: avgGuesses,
                isTopText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StatsText(
                text: context.l10n.wins,
                isTopText: false,
              ),
            ),
            Expanded(
              child: StatsText(
                text: context.l10n.avgGuesses,
                isTopText: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
