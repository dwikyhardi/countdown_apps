import 'dart:async';

import 'package:countdown_apps/clock/data/datasource/clock_datasource.dart';
import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:countdown_apps/core/di/injection_container.dart';
import 'package:countdown_apps/core/error/exception.dart';
import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/notification/notification.dart' as notif;
import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ClockRepositoryImpl implements ClockRepository {
  final ClockDatasource datasource;

  ClockRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, CountDown>> startCountDown({
    required int countDownTimeInMs,
    required int? countDownId,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?> streamController,
  }) async {
    try {
      var id = await datasource.startCountDown(
        countDownId: countDownId,
        countDownTimeInMs: countDownTimeInMs,
        remainingCountDownTimeInMs: remainingCountDownTimeInMs,
        streamController: streamController,
      );
      CountDown result = await datasource.getCountDown(countDownId: id);

      sl<notif.Notification>().scheduleNotification(
          countDownId: result.countDownId ?? 0,
          countDownTimeInMs: result.countDownTimeInMs);

      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> stopCountDown({
    required int countDownId,
    required int timeToStopCountDown,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?>? streamController,
  }) async {
    try {
      var result = await datasource.stopCountDown(
        countDownId: countDownId,
        timeToStopCountDown: timeToStopCountDown,
        remainingCountDownTimeInMs: remainingCountDownTimeInMs,
        streamController: streamController,
      );
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, CountDown>> getCountDown(
      {required int countDownId}) async {
    try {
      var result = await datasource.getCountDown(countDownId: countDownId);
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeCountDown(
      {required int countDownId}) async {
    try {
      await sl<FlutterLocalNotificationsPlugin>().cancel(countDownId);
      await datasource.deleteCountDown(countDownId: countDownId);
      return const Right(true);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Stream<Either<Failure, List<CountDown>>> streamCountDown() async* {
    try {
      StreamTransformer<List<CountDown>, Either<Failure, List<CountDown>>>
          transformer = StreamTransformer.fromHandlers(handleData:
              (List<CountDown> data,
                  EventSink<Either<Failure, List<CountDown>>> output) {
        if (data.isNotEmpty) {
          output.add(Right(data));
        } else {
          output.add(const Right([]));
        }
      });
      yield* datasource.streamCountDown().transform(transformer);
    } on DatabaseException {
      yield Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<CountDown>>> getAllCountDown() async {
    try {
      return Right(await datasource.getAllCountDown());
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }
}
