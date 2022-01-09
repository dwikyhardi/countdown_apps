import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartView extends StatefulWidget {
  final List<Alarm> listAlarm;

  const ChartView({Key? key, required this.listAlarm}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  final DateFormat formatter = DateFormat('HH:mm');

  final List<Color> gradientColors = [
    const Color(0xFF008c85),
    const Color(0xFF67f0e7)
  ];

  double _maxY = 0.0;

  Map<int, String> sideTitle = {};
  final List<double> stopTimes = [];
  final List<FlSpot> chartSpot = [];

  @override
  void initState() {
    super.initState();
    _setChartSpot();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: const Color(0xff232d37),
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              padding: const EdgeInsets.only(
                  right: 30.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xff37434d),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: const Color(0xff37434d),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTextStyles: (context, value) => const TextStyle(
                          color: CupertinoColors.inactiveGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                      getTitles: (value) {
                        return formatter.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                widget.listAlarm[value.toInt()].alarmTimeInMs));
                      },
                      margin: 5,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTextStyles: (context, value) => const TextStyle(
                        color: CupertinoColors.inactiveGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      getTitles: (value) {
                        return sideTitle[value.toInt()] ?? '';
                      },
                      reservedSize: 32,
                      margin: 5,
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border:
                          Border.all(color: const Color(0xff37434d), width: 1)),
                  minX: 0,
                  maxX: widget.listAlarm.length.toDouble() - 1,
                  minY: 0,
                  maxY: _maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartSpot,
                      isCurved: true,
                      colors: gradientColors,
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setChartSpot() {
    for (int i = 0; i < widget.listAlarm.length; i++) {
      Alarm alarm = widget.listAlarm[i];
      double stopTime =
          alarm.timeToStopAlarm.toDouble() - alarm.alarmTimeInMs.toDouble();
      if (stopTime < 0) {
        stopTime = 0;
      }

      setState(() {
        stopTimes.add(stopTime / 1000);
      });
      chartSpot.add(FlSpot(i.toDouble(), (stopTime / 1000)));
    }

    _setMaxY();
  }

  void _setMaxY() {
    setState(() {
      _maxY = 0.0;
    });

    double maxYTemp = 0.0;

    for (double temp in stopTimes) {
      if (temp >= maxYTemp) {
        maxYTemp = temp;
      }
    }
    setState(() {
      _maxY = (maxYTemp + 5);
      if (_maxY <= 60) {
        sideTitle = Map.fromIterables(
          List.generate(_maxY ~/ 5, (index) => (index + 1) * 5),
          List.generate(_maxY ~/ 5, (index) => '${(index + 1) * 5}s'),
        );
      } else if (_maxY > 61  && _maxY <= 1000) {
        sideTitle = Map.fromIterables(
          List.generate(_maxY ~/ 20, (index) => (index + 1) * 20),
          List.generate(_maxY ~/ 20, (index) => '${(index + 1) * 20}s'),
        );
      } else if (_maxY >= 1000) {
        sideTitle = Map.fromIterables(
          List.generate(_maxY ~/ 200, (index) => (index + 1) * 200),
          List.generate(_maxY ~/ 200, (index) => '${(index + 1) * 200}s'),
        );
      }
    });
  }
}
