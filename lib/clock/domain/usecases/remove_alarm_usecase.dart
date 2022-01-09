import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:countdown_apps/clock/domain/usecases/get_alarm_usecase.dart';
import 'package:dartz/dartz.dart';

class RemoveAlarmUseCase extends UseCase<bool, Params> {
  final ClockRepository repository;

  RemoveAlarmUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.removeAlarm(alarmId: params.alarmId);
  }
}
