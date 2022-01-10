import 'package:countdown_apps/clock/domain/entities/count_down.dart';

class CountDownModels extends CountDown {

  const CountDownModels({
    required int countDownTimeInMs,
    required int remainingCountDownTimeInMs,
    int? countDownId,
    required int timeToStopCountDown,
    required bool isStop,
    required bool isActive,
  }) : super(
          countDownId: countDownId,
          countDownTimeInMs: countDownTimeInMs,
          remainingCountDownTimeInMs: remainingCountDownTimeInMs,
          timeToStopCountDown: timeToStopCountDown,
          isStop: isStop,
          isActive: isActive,
        );

  factory CountDownModels.fromJson(Map<String, dynamic> json) {
    return CountDownModels(
      countDownTimeInMs: json['countDownTimeInMs'],
      countDownId: json['countDownId'],
      timeToStopCountDown: json['timeToStopCountDown'],
      remainingCountDownTimeInMs: json['remainingCountDownTimeInMs'],
      isStop: json['isStop'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countDownTimeInMs': countDownTimeInMs,
      'remainingCountDownTimeInMs': remainingCountDownTimeInMs,
      'countDownId': countDownId,
      'timeToStopCountDown': timeToStopCountDown,
      'isStop': isStop,
      'isActive': isActive,
    };
  }
}
