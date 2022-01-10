import 'dart:async';

import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ClockRepository {
  Future<Either<Failure, CountDown>> startCountDown({
    required int countDownTimeInMs,
    required int? countDownId,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?> streamController,
  });

  Future<Either<Failure, bool>> removeCountDown({required int countDownId});

  Future<Either<Failure, CountDown>> getCountDown({required int countDownId});

  Future<Either<Failure, List<CountDown>>> getAllCountDown();

  Stream<Either<Failure, List<CountDown>>> streamCountDown();

  Future<Either<Failure, bool>> stopCountDown({
    required int countDownId,
    required int timeToStopCountDown,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?>? streamController,
  });
}
