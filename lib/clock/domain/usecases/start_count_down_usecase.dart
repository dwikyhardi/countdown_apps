import 'dart:async';

import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class StartCountDownUseCase extends UseCase<CountDown, Params> {
  final ClockRepository repository;

  StartCountDownUseCase(this.repository);

  @override
  Future<Either<Failure, CountDown>> call(Params params) async {
    return await repository.startCountDown(
      countDownId: params.countDownId,
      countDownTimeInMs: params.countDownTimeInMs,
      remainingCountDownTimeInMs: params.remainingCountDownTimeInMs,
      streamController: params.streamController,
    );
  }
}

class Params {
  final int countDownTimeInMs;
  final int remainingCountDownTimeInMs;
  final StreamController<CountDownModels?> streamController;
  final int? countDownId;

  Params(
      {required this.countDownTimeInMs,
      required this.remainingCountDownTimeInMs,
      required this.streamController,
      required this.countDownId});
}
