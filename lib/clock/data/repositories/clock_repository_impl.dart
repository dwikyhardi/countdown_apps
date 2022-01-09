import 'dart:async';

import 'package:countdown_apps/core/di/injection_container.dart';
import 'package:countdown_apps/core/error/exception.dart';
import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/notification/notification.dart' as notif;
import 'package:countdown_apps/clock/data/datasource/clock_datasource.dart';
import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ClockRepositoryImpl implements ClockRepository {
  final ClockDatasource datasource;

  ClockRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Alarm>> addAlarm({required int alarmTimeInMs}) async {
    try {
      var id = await datasource.addAlarm(alarmTimeInMs: alarmTimeInMs);
      Alarm result = await datasource.getAlarm(alarmId: id);

      sl<notif.Notification>().scheduleNotification(
          alarmId: result.alarmId ?? 0, alarmTimeInMs: result.alarmTimeInMs);

      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> stopAlarm(
      {required int alarmId, required int timeToStopAlarm}) async {
    try {
      var result = await datasource.stopAlarm(
          alarmId: alarmId, timeToStopAlarm: timeToStopAlarm);
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Alarm>> getAlarm({required int alarmId}) async {
    try {
      var result = await datasource.getAlarm(alarmId: alarmId);
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeAlarm({required int alarmId}) async {
    try {
      await sl<FlutterLocalNotificationsPlugin>().cancel(alarmId);
      await datasource.deleteAlarm(alarmId: alarmId);
      return const Right(true);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Stream<Either<Failure, List<Alarm>>> streamAlarm() async* {
    try {
      StreamTransformer<List<Alarm>, Either<Failure, List<Alarm>>> transformer =
          StreamTransformer.fromHandlers(handleData: (List<Alarm> data,
              EventSink<Either<Failure, List<Alarm>>> output) {
        if (data.isNotEmpty) {
          output.add(Right(data));
        } else {
          output.add(Left(DatabaseFailure()));
        }
      });
      yield* datasource.streamAlarm().transform(transformer);
    } on DatabaseException {
      yield Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setActiveAlarm({
    required int alarmId,
    required bool isActive,
  }) async {
    try {
      var result = await datasource.setIsActiveAlarm(
          alarmId: alarmId, isActive: isActive);
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Alarm>>> getAllAlarm() async {
    try {
      var result = await datasource.getAllAlarm();
      return Right(result);
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }
}
