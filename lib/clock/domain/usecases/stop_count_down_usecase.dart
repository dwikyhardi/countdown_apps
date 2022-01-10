import 'dart:async';

import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:countdown_apps/clock/domain/usecases/get_count_down_usecase.dart'
    as paramsId;
import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class StopCountDownUseCase extends UseCase<bool, Params> {
  final ClockRepository repository;

  StopCountDownUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.stopCountDown(
      streamController: params.streamController,
      countDownId: params.countDownId,
      timeToStopCountDown: params.timeToStopCountDown,
      remainingCountDownTimeInMs: params.remainingCountDownTimeInMs,
    );
  }
}

class Params extends paramsId.Params {
  final int timeToStopCountDown;
  final int remainingCountDownTimeInMs;
  final StreamController<CountDownModels?>? streamController;

  Params({
    required this.timeToStopCountDown,
    required int countDownId,
    required this.remainingCountDownTimeInMs,
    required this.streamController,
  }) : super(countDownId: countDownId);
}
