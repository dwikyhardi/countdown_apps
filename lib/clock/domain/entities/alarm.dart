import 'package:equatable/equatable.dart';

class Alarm extends Equatable {
  final int alarmTimeInMs;
  final int? alarmId;
  final int timeToStopAlarm;
  final bool isStop;
  final bool isActive;

  const Alarm({
    required this.alarmId,
    required this.alarmTimeInMs,
    required this.timeToStopAlarm,
    required this.isStop,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        alarmId,
        alarmTimeInMs,
        timeToStopAlarm,
        isStop,
        isActive,
      ];
}
