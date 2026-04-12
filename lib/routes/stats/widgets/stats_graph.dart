import 'dart:math' show max;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/misc.dart' show convertListStringToListDouble;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

/// Wraps the private [_GuessDistributionChart] inside a fixed-aspect-ratio
/// container with consistent padding.
///
/// Placed between the "Guess Distribution" heading and the History section
/// on the Stats page.
class StatsGraph extends StatelessWidget {
  const StatsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 12, 30, 12),
      child: AspectRatio(aspectRatio: 16 / 9, child: _GuessDistributionChart()),
    );
  }
}

/// Horizontal bar chart showing how many times the player won in 1–6 guesses.
///
/// The chart is rotated 90° ([RotatedBox]) so the bars run horizontally while
/// fl_chart renders them as a vertical bar chart internally. Axis labels are
/// counter-rotated 270° to appear upright.
///
/// Data is loaded from SharedPreferences in [initState] as a list of 6 string
/// counts (`guessDistribution`). fl_chart's bar-touch tooltips are enabled but
/// rendered transparently so the count value floats above each bar.
class _GuessDistributionChart extends StatefulWidget {
  const _GuessDistributionChart();

  @override
  State<_GuessDistributionChart> createState() =>
      _GuessDistributionChartState();
}

class _GuessDistributionChartState extends State<_GuessDistributionChart> {
  /// Raw distribution counts as strings, one per guess-count bucket (1–6).
  late List<String> _arr;

  @override
  void initState() {
    super.initState();
    _arr = SharedPreferenceService()
            .getStringList(SharedPreferencesKeys.guessDistribution) ??
        ['0', '0', '0', '0', '0', '0'];
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      // Rotate 90° so fl_chart's vertical bars appear horizontal.
      quarterTurns: 1,
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData(context),
          titlesData: titlesData(context),
          borderData: FlBorderData(show: false),
          barGroups: barGroups(context),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          minY: 0,
          // Scale the Y axis to the highest bucket value so bars fill the space.
          maxY: convertListStringToListDouble(_arr).reduce(max),
        ),
      ),
    );
  }

  /// Configures the touch tooltip that shows the numeric count above each bar.
  ///
  /// Touch interaction is disabled; the tooltip is used in "always visible"
  /// mode by setting [showingTooltipIndicators] on each bar group.
  BarTouchData barTouchData(BuildContext context) {
    return BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        // 270° rotation because the whole chart is rotated 90°.
        rotateAngle: 270,
        getTooltipColor: (group) => Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }

  /// Configures axis titles: only the bottom axis (rotated to appear as the
  /// left axis after the 90° rotation) shows guess-count labels (1–6).
  FlTitlesData titlesData(BuildContext context) {
    return FlTitlesData(
      leftTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (val, meta) => RotatedBox(
            quarterTurns: 0,
            child: SideTitleWidget(
              meta: meta,
              // 4.7123889803847 radians = 270° counter-clockwise, counteracting
              // the 90° rotation applied to the whole chart.
              angle: 4.7123889803847,
              child: Text(
                '${(val.toInt())}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds one [BarChartGroupData] per guess-count bucket.
  ///
  /// The x value is 1-based (1–6) matching the guess number labels.
  /// [showingTooltipIndicators] forces the count tooltip to always be visible.
  List<BarChartGroupData> barGroups(BuildContext context) {
    return _arr
        .asMap()
        .entries
        .map((e) => BarChartGroupData(
              x: e.key + 1,
              barRods: [
                BarChartRodData(
                  toY: double.parse(e.value),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
              // Index 0 means "show the first (and only) rod's tooltip".
              showingTooltipIndicators: [0],
            ))
        .toList();
  }
}
