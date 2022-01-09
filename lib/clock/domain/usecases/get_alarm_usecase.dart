import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:dartz/dartz.dart';

class GatAlarmUseCase extends UseCase<Alarm, Params> {
  final ClockRepository repository;

  GatAlarmUseCase(this.repository);

  @override
  Future<Either<Failure, Alarm>> call(Params params) async {
    return repository.getAlarm(alarmId: params.alarmId);
  }
}

class Params {
  final int alarmId;

  Params({required this.alarmId});
}
