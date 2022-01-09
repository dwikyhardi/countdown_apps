import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/entities/alarm.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:dartz/dartz.dart';

class StreamAlarmUseCase extends StreamUseCase<List<Alarm>, NoParams> {
  final ClockRepository repository;

  StreamAlarmUseCase(this.repository);

  @override
  Stream<Either<Failure, List<Alarm>>> call(NoParams params) async* {
    yield* repository.streamAlarm();
  }
}
