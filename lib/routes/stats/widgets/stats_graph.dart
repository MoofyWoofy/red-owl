import 'dart:math' show max;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/misc.dart' show convertListStringToListDouble;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

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

class _GuessDistributionChart extends StatefulWidget {
  const _GuessDistributionChart();

  @override
  State<_GuessDistributionChart> createState() =>
      _GuessDistributionChartState();
}

class _GuessDistributionChartState extends State<_GuessDistributionChart> {
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
          maxY: convertListStringToListDouble(_arr).reduce(max),
        ),
      ),
    );
  }

  BarTouchData barTouchData(BuildContext context) {
    return BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
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
              angle:
                  4.7123889803847, // Rotate 270 degrees counter-clockwise (in radians)
              axisSide: AxisSide.left,
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
              showingTooltipIndicators: [0],
            ))
        .toList();
  }
}
