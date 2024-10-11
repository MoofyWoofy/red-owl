import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/routes/stats/widgets/shared.dart';
import 'package:red_owl/util/shared.dart'
    show Localization, SharedPreferenceService, getWinRate;

class StatsInfo extends StatefulWidget {
  const StatsInfo({super.key});

  @override
  State<StatsInfo> createState() => _StatsInfoState();
}

class _StatsInfoState extends State<StatsInfo> {
  late List<String> arr;

  @override
  void initState() {
    super.initState();
    arr = SharedPreferenceService()
            .getStringList(SharedPreferencesKeys.statsData) ??
        ['0', '0', '0', '0'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StatsText(
                text: arr[0],
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: getWinRate(arr[1], arr[0]),
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: arr[2],
                isTopText: true,
              ),
            ),
            Expanded(
              child: StatsText(
                text: arr[3],
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
      ],
    );
  }
}
