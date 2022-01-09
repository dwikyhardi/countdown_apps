part of 'clock_bloc.dart';

abstract class ClockEvent extends Equatable {
  const ClockEvent();
}

class AddAlarmEvent extends ClockEvent {
  final int alarmTimeInMs;

  const AddAlarmEvent(this.alarmTimeInMs);

  @override
  List<Object> get props => [alarmTimeInMs];
}

class RemoveAlarmEvent extends ClockEvent {
  final int alarmId;

  const RemoveAlarmEvent(this.alarmId);

  @override
  List<Object> get props => [alarmId];
}

class StopAlarmEvent extends ClockEvent {
  final int alarmId;
  final int timeToStopAlarm;

  const StopAlarmEvent(this.alarmId, this.timeToStopAlarm);

  @override
  List<Object> get props => [alarmId, timeToStopAlarm];
}

class GetAlarmEvent extends ClockEvent {
  final int alarmId;

  const GetAlarmEvent(this.alarmId);

  @override
  List<Object> get props => [alarmId];
}

class SetIsActiveAlarmEvent extends ClockEvent {
  final int alarmId;
  final bool isActive;

  const SetIsActiveAlarmEvent(this.alarmId, this.isActive);

  @override
  List<Object> get props => [alarmId,isActive];
}

class OpenChartEvent extends ClockEvent {

  final BuildContext context;

  const OpenChartEvent(this.context);

  @override
  List<Object> get props => [context];
}
