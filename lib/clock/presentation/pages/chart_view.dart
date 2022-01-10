import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartView extends StatefulWidget {
  final List<CountDown> listCountDown;

  const ChartView({Key? key, required this.listCountDown}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  final DateFormat formatter = DateFormat('HH:mm');

  final Color barBackgroundColor = const Color(0xff72d8bf);
  int touchedIndex = -1;
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
              child: BarChart(
                BarChartData(
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
                            DateTime.fromMillisecondsSinceEpoch(widget
                                .listCountDown[value.toInt()]
                                .countDownTimeInMs));
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
                  // minX: 0,
                  // maxX: widget.listCountDown.length.toDouble() - 1,
                  minY: 0,
                  maxY: _maxY,
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  barGroups: List.generate(chartSpot.length, (index) {
                    var data = chartSpot[index];
                    return makeGroupData(
                      data.x.toInt(),
                      data.y,
                      isTouched: index == touchedIndex,
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors:
              isTouched ? [Colors.yellow] : [barColor ?? barBackgroundColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow.shade900, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          // backDrawRodData: BackgroundBarChartRodData(
          //   show: true,
          //   y: _maxY,
          //   colors: [barBackgroundColor],
          // ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  void _setChartSpot() {
    for (int i = 0; i < widget.listCountDown.length; i++) {
      CountDown countDown = widget.listCountDown[i];
      double stopTime = countDown.timeToStopCountDown.toDouble() -
          countDown.countDownTimeInMs.toDouble();
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
      } else if (_maxY > 61 && _maxY <= 1000) {
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
