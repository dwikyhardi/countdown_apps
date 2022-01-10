import 'dart:async';

import 'package:countdown_apps/clock/data/model/count_down_model.dart';
import 'package:countdown_apps/clock/data/table/count_down_table.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/core/di/injection_container.dart';
import 'package:countdown_apps/core/error/exception.dart';
import 'package:countdown_apps/core/notification/notification.dart' as notif;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class ClockDatasource {
  Future<int> startCountDown({
    required int countDownTimeInMs,
    required int? countDownId,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?> streamController,
  });

  Future<void> deleteCountDown({required int countDownId});

  Future<CountDown> getCountDown({required int countDownId});

  Future<bool> stopCountDown({
    required int countDownId,
    required int timeToStopCountDown,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?>? streamController,
  });

  Stream<List<CountDown>> streamCountDown();

  Future<List<CountDown>> getAllCountDown();
}

class ClockDataSourceImpl implements ClockDatasource {
  final AppDatabase database;
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  ClockDataSourceImpl(this.database, this.notificationsPlugin);

  @override
  Future<int> startCountDown({
    required int? countDownId,
    required int countDownTimeInMs,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?> streamController,
  }) async {
    try {
      return await database.appDao.saveCountDown(
        CountDownModels(
          countDownId: countDownId,
          remainingCountDownTimeInMs: remainingCountDownTimeInMs,
          countDownTimeInMs: countDownTimeInMs,
          timeToStopCountDown: 0,
          isStop: false,
          isActive: true,
        ),
        streamController,
      );
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<CountDown> getCountDown({required int countDownId}) async {
    try {
      return await database.appDao.getCountDown(countDownId);
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<void> deleteCountDown({required int countDownId}) async {
    try {
      await database.appDao.deleteCountDown(countDownId);
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Stream<List<CountDown>> streamCountDown() async* {
    try {
      yield* database.appDao.streamCountDowns();
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<bool> stopCountDown({
    required int countDownId,
    required int timeToStopCountDown,
    required int remainingCountDownTimeInMs,
    required StreamController<CountDownModels?>? streamController,
  }) async {
    try {
      var result = await database.appDao.stopCountDown(
        countDownId,
        timeToStopCountDown,
        remainingCountDownTimeInMs,
        streamController,
      );
      await sl<FlutterLocalNotificationsPlugin>().cancel(countDownId);
      return result;
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<List<CountDown>> getAllCountDown() async {
    try {
      return await database.appDao.getAllCountDown();
    } on Exception {
      throw DatabaseException();
    }
  }
}
