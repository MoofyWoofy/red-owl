// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsGraph extends StatelessWidget {
  const StatsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: AspectRatio(aspectRatio: 16 / 9, child: _GuessDistributionChart()),
    );
  }
}

class _GuessDistributionChart extends StatelessWidget {
  const _GuessDistributionChart();

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
          maxY: 100,
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
      leftTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      topTitles: AxisTitles(),
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
    // TODO: return dyanamic data
    return <BarChartGroupData>[
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 62,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: 89,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: 41,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
    ];
  }
}
