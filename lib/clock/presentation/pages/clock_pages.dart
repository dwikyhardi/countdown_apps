import 'dart:math';

import 'package:countdown_apps/core/text_converter/text_converter.dart';
import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:countdown_apps/clock/presentation/bloc/clock_bloc.dart';
import 'package:countdown_apps/clock/presentation/painter/clock_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ClockPages extends StatefulWidget {
  static const routeName = '/';

  const ClockPages({Key? key}) : super(key: key);

  @override
  _ClockPagesState createState() => _ClockPagesState();
}

class _ClockPagesState extends State<ClockPages> {
  late DateTime _dateTime;
  double _startPositionVertical = 0.0;
  double _endPositionVertical = 0.0;
  double _startPositionHorizontal = 0.0;
  double _endPositionHorizontal = 0.0;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  (AppBar().preferredSize.height * 2.5),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _analogWatchFace(context),
                  _digitalWatchFace(context),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      BlocProvider.of<ClockBloc>(context)
                          .add(AddAlarmEvent(_dateTime.millisecondsSinceEpoch));
                    },
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      BlocProvider.of<ClockBloc>(context)
                          .add(OpenChartEvent(context));
                    },
                    child: Icon(
                      Icons.stacked_line_chart,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<Alarm>>(
                stream: BlocProvider.of<ClockBloc>(context).streamListAlarm(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.data?.isNotEmpty ?? false)) {
                    return Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (BuildContext buildContext, int index) {
                            Alarm? alarmData = snapshot.data?[index];
                            return _alarmChild(alarmData);
                          }),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _alarmChild(Alarm? alarmData) {
    DateFormat formatter = DateFormat('HH:mm');
    return Slidable(
      enabled: true,
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            autoClose: true,
            onPressed: (BuildContext buildContext) {
              BlocProvider.of<ClockBloc>(context)
                  .add(RemoveAlarmEvent(alarmData?.alarmId ?? -1));
            },
            backgroundColor: CupertinoColors.destructiveRed,
            foregroundColor: CupertinoColors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: (alarmData?.alarmTimeInMs ?? 0) != 0
            ? Text(
                formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(
                    alarmData?.alarmTimeInMs ?? 0,
                  ),
                ),
              )
            : const SizedBox(),
        subtitle: (alarmData?.timeToStopAlarm ?? 0) != 0
            ? Text(
                '${((alarmData?.timeToStopAlarm ?? 0) - (alarmData?.alarmTimeInMs ?? 0)) / 1000}s',
              )
            : const SizedBox(),
        trailing: CupertinoSwitch(
          onChanged: (change) {
            BlocProvider.of<ClockBloc>(context).add(
              SetIsActiveAlarmEvent(
                alarmData?.alarmId ?? -1,
                change,
              ),
            );
          },
          value: alarmData?.isActive ?? false,
        ),
      ),
    );
  }

  Widget _analogWatchFace(BuildContext context) {
    DateFormat formatter = DateFormat('EE dd MMM');
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onVerticalDragStart: (DragStartDetails start) {
                setState(() {
                  _startPositionVertical = start.localPosition.dy;
                });
              },
              onVerticalDragUpdate: (DragUpdateDetails update) {
                setState(() {
                  _endPositionVertical = update.localPosition.dy;
                });
                _onUpdateHourHand();
              },
              onHorizontalDragStart: (DragStartDetails start) {
                setState(() {
                  _startPositionHorizontal = start.localPosition.dx;
                });
              },
              onHorizontalDragUpdate: (DragUpdateDetails update) {
                setState(() {
                  _endPositionHorizontal = update.localPosition.dx;
                });
                _onUpdateMinuteHand();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: CustomPaint(
                    painter: ClockPainter(
                      context: context,
                      dateTime: _dateTime,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(75, 0),
          child: Center(
            child: Text(
              formatter.format(_dateTime),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color ??
                    Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Positioned _digitalWatchFace(BuildContext context) {
    return Positioned(
      bottom: AppBar().preferredSize.height * 1.5,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '${TextConverter()(_dateTime.hour.toString())} : ${TextConverter()(_dateTime.minute.toString())}',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1?.color ?? Colors.white,
            fontSize: 44,
          ),
        ),
      ),
    );
  }

  void _onUpdateHourHand() {
    int newHour = _dateTime.hour;
    if (_startPositionVertical > _endPositionVertical) {
      if (_endPositionVertical < (_startPositionVertical - 25)) {
        setState(() {
          _startPositionVertical -= 25;
          newHour -= 1;
        });
      }
    } else if (_startPositionVertical < _endPositionVertical) {
      if (_endPositionVertical > (_startPositionVertical + 25)) {
        setState(() {
          _startPositionVertical += 25;
          newHour += 1;
        });
      }
    }

    setState(() {
      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
          newHour, _dateTime.minute);
    });
  }

  void _onUpdateMinuteHand() {
    int newMinute = _dateTime.minute;
    if (_startPositionHorizontal > _endPositionHorizontal) {
      if (_endPositionHorizontal < (_startPositionHorizontal - 25)) {
        setState(() {
          _startPositionHorizontal -= 25;
          newMinute -= 1;
        });
      }
    } else if (_startPositionHorizontal < _endPositionHorizontal) {
      if (_endPositionHorizontal > (_startPositionHorizontal + 25)) {
        setState(() {
          _startPositionHorizontal += 25;
          newMinute += 1;
        });
      }
    }

    setState(() {
      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
          _dateTime.hour, newMinute);
    });
  }
}
