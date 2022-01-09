import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:countdown_apps/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ClockRepository {

  Future<Either<Failure, Alarm>> addAlarm({required int alarmTimeInMs});
  Future<Either<Failure, bool>> removeAlarm({required int alarmId});
  Future<Either<Failure, Alarm>> getAlarm({required int alarmId});
  Future<Either<Failure, List<Alarm>>> getAllAlarm();
  Stream<Either<Failure, List<Alarm>>> streamAlarm();
  Future<Either<Failure, bool>> stopAlarm({required int alarmId, required int timeToStopAlarm});
  Future<Either<Failure, bool>> setActiveAlarm({required int alarmId, required bool isActive});

}
