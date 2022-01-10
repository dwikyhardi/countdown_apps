import 'package:countdown_apps/core/error/failure.dart';
import 'package:countdown_apps/core/usecase/usecase.dart';
import 'package:countdown_apps/clock/domain/entities/count_down.dart';
import 'package:countdown_apps/clock/domain/repositories/clock_repository.dart';
import 'package:dartz/dartz.dart';

class GatCountDownUseCase extends UseCase<CountDown, Params> {
  final ClockRepository repository;

  GatCountDownUseCase(this.repository);

  @override
  Future<Either<Failure, CountDown>> call(Params params) async {
    return repository.getCountDown(countDownId: params.countDownId);
  }
}

class Params {
  final int countDownId;

  Params({required this.countDownId});
}
