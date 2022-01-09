import 'package:countdown_apps/clock/domain/entities/alarm.dart';

class AlarmModels extends Alarm {
  const AlarmModels({
    required int alarmTimeInMs,
    int? alarmId,
    required int timeToStopAlarm,
    required bool isStop,
    required bool isActive,
  }) : super(
          alarmId: alarmId,
          alarmTimeInMs: alarmTimeInMs,
          timeToStopAlarm: timeToStopAlarm,
          isStop: isStop,
          isActive: isActive,
        );

  factory AlarmModels.fromJson(Map<String, dynamic> json) {
    return AlarmModels(
      alarmTimeInMs: json['alarmTimeInMs'],
      alarmId: json['alarmId'],
      timeToStopAlarm: json['timeToStopAlarm'],
      isStop: json['isStop'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alarmTimeInMs': alarmTimeInMs,
      'alarmId': alarmId,
      'timeToStopAlarm': timeToStopAlarm,
      'isStop': isStop,
      'isActive': isActive,
    };
  }
}
