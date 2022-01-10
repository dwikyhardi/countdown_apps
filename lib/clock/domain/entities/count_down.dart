import 'package:equatable/equatable.dart';

class CountDown extends Equatable {
  final int countDownTimeInMs;
  final int remainingCountDownTimeInMs;
  final int? countDownId;
  final int timeToStopCountDown;
  final bool isStop;
  final bool isActive;

  const CountDown({
    required this.countDownId,
    required this.countDownTimeInMs,
    required this.remainingCountDownTimeInMs,
    required this.timeToStopCountDown,
    required this.isStop,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        countDownId,
        countDownTimeInMs,
        remainingCountDownTimeInMs,
        timeToStopCountDown,
        isStop,
        isActive,
      ];
}
