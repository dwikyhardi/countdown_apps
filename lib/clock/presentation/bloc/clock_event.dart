part of 'clock_bloc.dart';

abstract class ClockEvent extends Equatable {
  const ClockEvent();

  @override
  List<Object?> get props => [];
}

class StartCountDownEvent extends ClockEvent {
  final int countDownTimeInMs;
  final int remainingCountDownTimeInMs;
  final int? countDownId;
  final StreamController<CountDownModels?> streamController;

  const StartCountDownEvent(this.countDownTimeInMs,
      this.remainingCountDownTimeInMs, this.streamController, this.countDownId);

  @override
  List<Object> get props =>
      [countDownTimeInMs, remainingCountDownTimeInMs, streamController];
}

class RemoveCountDownEvent extends ClockEvent {
  final int countDownId;

  const RemoveCountDownEvent(this.countDownId);

  @override
  List<Object> get props => [countDownId];
}

class StopCountDownEvent extends ClockEvent {
  final int countDownId;
  final int timeToStopCountDown;
  final int remainingCountDownTimeInMs;
  final StreamController<CountDownModels?>? streamController;

  const StopCountDownEvent(this.countDownId, this.timeToStopCountDown,
      this.remainingCountDownTimeInMs, this.streamController);

  @override
  List<Object?> get props =>
      [
        countDownId,
        timeToStopCountDown,
        remainingCountDownTimeInMs,
        streamController,
      ];
}

class GetCountDownEvent extends ClockEvent {
  final int countDownId;

  const GetCountDownEvent(this.countDownId);

  @override
  List<Object> get props => [countDownId];
}

class OpenChartEvent extends ClockEvent {
  final BuildContext context;

  const OpenChartEvent(this.context);

  @override
  List<Object> get props => [context];
}
