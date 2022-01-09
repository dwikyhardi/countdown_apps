import 'package:countdown_apps/core/di/injection_container.dart';
import 'package:countdown_apps/core/error/exception.dart';
import 'package:countdown_apps/core/notification/notification.dart' as notif;
import 'package:countdown_apps/clock/data/model/alarm_model.dart';
import 'package:countdown_apps/clock/data/table/alarm_table.dart';
import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class ClockDatasource {
  Future<int> addAlarm({required int alarmTimeInMs});

  Future<void> deleteAlarm({required int alarmId});

  Future<Alarm> getAlarm({required int alarmId});

  Future<bool> stopAlarm({required int alarmId, required int timeToStopAlarm});

  Future<bool> setIsActiveAlarm({required int alarmId, required bool isActive});

  Stream<List<Alarm>> streamAlarm();

  Future<List<Alarm>> getAllAlarm();
}

class ClockDataSourceImpl implements ClockDatasource {
  final AppDatabase database;
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  ClockDataSourceImpl(this.database, this.notificationsPlugin);

  @override
  Future<int> addAlarm({required int alarmTimeInMs}) async {
    try {
      return await database.appDao.saveAlarm(AlarmModels(
          alarmTimeInMs: alarmTimeInMs,
          timeToStopAlarm: 0,
          isStop: false,
          isActive: true));
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<Alarm> getAlarm({required int alarmId}) async {
    try {
      return await database.appDao.getAlarm(alarmId);
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<void> deleteAlarm({required int alarmId}) async {
    try {
      await database.appDao.deleteAlarm(alarmId);
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Stream<List<Alarm>> streamAlarm() async* {
    try {
      yield* database.appDao.streamAlarms();
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<bool> stopAlarm(
      {required int alarmId, required int timeToStopAlarm}) async {
    try {
      return await database.appDao.stopAlarm(alarmId, timeToStopAlarm);
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<bool> setIsActiveAlarm(
      {required int alarmId, required bool isActive}) async {
    try {
      int? newAlarmTimeInMs;
      if (isActive) {
        await getAlarm(alarmId: alarmId).then((value) async {
          DateTime alarmTime =
              DateTime.fromMillisecondsSinceEpoch(value.alarmTimeInMs);
          if (alarmTime.isAfter(DateTime.now())) {
            await sl<notif.Notification>().scheduleNotification(
                alarmId: alarmId, alarmTimeInMs: value.alarmTimeInMs);
          } else {
            newAlarmTimeInMs =
                alarmTime.add(const Duration(days: 1)).millisecondsSinceEpoch;
          }
        });
      } else if (!isActive) {
        await sl<FlutterLocalNotificationsPlugin>().cancel(alarmId);
      }

      return await database.appDao
          .setIsActiveAlarm(alarmId, isActive, newAlarmTimeInMs);
    } on Exception {
      throw DatabaseException();
    }
  }

  @override
  Future<List<Alarm>> getAllAlarm() async {
    try {
      return await database.appDao.getAllAlarm();
    } on Exception {
      throw DatabaseException();
    }
  }
}
