import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:dartz/dartz.dart';

class StreamCountDownUseCase extends StreamUseCase<List<CountDown>, NoParams> {
  final ClockRepository repository;

  StreamCountDownUseCase(this.repository);

  @override
  Stream<Either<Failure, List<CountDown>>> call(NoParams params) async* {
    yield* repository.streamCountDown();
  }
}
