import 'dart:async';

import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/clock/presentation/bloc/clock_bloc.dart';
import 'package:countdown_apps/core/di/injection_container.dart';
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
  double _sliderValue = 0.0;
  bool isSetSliderToZero = true;
  Duration _countDownDuration = const Duration();
  StreamController<CountDownModels?> streamController = StreamController();

  ///Seconds in a day
  static const int _daySecond = 60 * 60 * 24;

  ///Seconds in an hour
  static const int _hourSecond = 60 * 60;

  ///Seconds in a minute
  static const int _minuteSecond = 60;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ClockBloc, ClockState>(
              builder: (context, state) {
                debugPrint('Kadieu ClockUpdate ${state.toString()}');
                if(state is ClockUpdate){
                  debugPrint('Kadieu ClockUpdate Cuk ${state.countDownModels.toJson()}');
                  streamController.sink.add(state.countDownModels);
                }

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: _buildSlider(),
                );
              },
            ),
            StreamBuilder<List<CountDown>>(
                stream:
                    sl<ClockBloc>().streamListCountDown(),
                builder: (context, snapshot) {
                  return Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext buildContext, int index) {
                          CountDown? countDownData = snapshot.data?[index];
                          return _countDownChild(countDownData);
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buttonChart(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onPressed: () {
        sl<ClockBloc>().add(OpenChartEvent(context));
      },
      child: Icon(
        Icons.stacked_line_chart,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  ElevatedButton _buttonReset(
      BuildContext context, bool isActive, bool isStop, CountDown? countDown) {
    return ElevatedButton.icon(
      onPressed: () {
        if ((countDown?.isStop ?? false)) {
          _sliderValue = 0.0;
          setState(() {});
        }

        sl<ClockBloc>().add(StopCountDownEvent(
          countDown?.countDownId ?? 0,
          DateTime.now().millisecondsSinceEpoch,
          countDown?.remainingCountDownTimeInMs ?? 0,
          streamController,
        ));
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        fixedSize: Size(MediaQuery.of(context).size.width * 0.35, 40),
        primary: isActive
            ? Colors.redAccent
            : isStop
                ? Colors.redAccent
                : Colors.grey,
        onPrimary: Colors.white,
      ),
      label: Text(isStop ? 'Reset' : 'Stop'),
      icon: const Icon(
        Icons.restart_alt,
      ),
    );
  }

  ElevatedButton _buttonStart(
      BuildContext context, bool isActive, CountDown? countDown) {
    return ElevatedButton.icon(
      onPressed: () {
        if (_sliderValue > 0) {
          late StartCountDownEvent event;
          if (countDown?.countDownId != null) {
            event = StartCountDownEvent(
              countDown?.timeToStopCountDown ??
                  DateTime.now().add(_countDownDuration).millisecondsSinceEpoch,
              countDown?.remainingCountDownTimeInMs ??
                  _countDownDuration.inMilliseconds,
              streamController,
              countDown?.countDownId,
            );
          } else {
            debugPrint(
                '_countDownDuration.toString() ========= ${_countDownDuration.toString()}');
            event = StartCountDownEvent(
              DateTime.now().add(_countDownDuration).millisecondsSinceEpoch,
              _countDownDuration.inMilliseconds,
              streamController,
              null,
            );
          }

          sl<ClockBloc>().add(
            event,
          );
        }
        isSetSliderToZero = true;
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        fixedSize: Size(MediaQuery.of(context).size.width * 0.35, 40),
        primary: isActive
            ? Colors.grey
            : _sliderValue > 0
                ? Colors.lightGreen
                : Colors.grey,
        onPrimary: Colors.white,
      ),
      label: const Text('Start'),
      icon: const Icon(
        Icons.play_arrow,
      ),
    );
  }

  Widget _buildSlider() {
    return StreamBuilder<CountDown?>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          debugPrint('Kadieu ClockUpdate Cuk streamController.stream ${snapshot.data} ======= $_sliderValue');
          if(snapshot.data == null && isSetSliderToZero){
            _sliderValue = 0;
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  _convertToMMss(
                            snapshot.data == null
                        ? _sliderValue
                        : (snapshot.data?.remainingCountDownTimeInMs ?? 0),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color ??
                        Colors.white,
                    fontSize: 44,
                  ),
                ),
              ),
              Slider(
                value: _sliderValue,
                divisions: 1000,
                min: 0.0,
                max: 3600000,
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  debugPrint('_sliderValue ======= $_sliderValue');
                  isSetSliderToZero = false;
                  _sliderValue = value;
                  _convertToMMss(_sliderValue);
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buttonStart(
                    context,
                    (snapshot.data?.isActive ?? false),
                    snapshot.data,
                  ),
                  _buttonReset(
                    context,
                    (snapshot.data?.isActive ?? false),
                    (snapshot.data?.isStop ?? false),
                    snapshot.data,
                  ),
                  _buttonChart(context),
                ],
              ),
            ],
          );
        });
  }

  Widget _countDownChild(CountDown? countDownData) {
    DateFormat formatter = DateFormat('Hms');
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
              sl<ClockBloc>()
                  .add(RemoveCountDownEvent(countDownData?.countDownId ?? -1));
            },
            backgroundColor: CupertinoColors.destructiveRed,
            foregroundColor: CupertinoColors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: (countDownData?.countDownTimeInMs ?? 0) != 0
            ? Text(
                formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(
                    countDownData?.countDownTimeInMs ?? 0,
                  ),
                ),
              )
            : const SizedBox(),
        subtitle: (countDownData?.timeToStopCountDown ?? 0) != 0
            ? Text(
                '${((countDownData?.timeToStopCountDown ?? 0) - (countDownData?.countDownTimeInMs ?? 0)) / 1000}s',
              )
            : const SizedBox(),
      ),
    );
  }

  String _convertToMMss(num remainingTime) {
    int remainingTimeStamp = (DateTime.now()
                .add(Duration(milliseconds: remainingTime.round()))
                .millisecondsSinceEpoch -
            DateTime.now().millisecondsSinceEpoch) ~/
        1000;

    _sliderValue = remainingTimeStamp * 1000;

    int days = 0;
    int hours = 0;
    int min = 0;

    ///Calculate the number of days remaining.
    if (remainingTimeStamp >= _daySecond) {
      days = remainingTimeStamp ~/ _daySecond;
      remainingTimeStamp %= _daySecond;
    }

    ///Calculate remaining hours.
    if (remainingTimeStamp >= _hourSecond) {
      hours = remainingTimeStamp ~/ _hourSecond;
      remainingTimeStamp %= _hourSecond;
    }

    ///Calculate remaining minutes.
    if (remainingTimeStamp >= _minuteSecond) {
      min = remainingTimeStamp ~/ _minuteSecond;
      remainingTimeStamp %= _minuteSecond;
    }

    _countDownDuration = Duration(
      days: days,
      hours: hours,
      minutes: min,
      seconds: remainingTimeStamp,
    );

    return _sliderValue == 3600000 ? '60.0' : '$min.$remainingTimeStamp';
  }
}
